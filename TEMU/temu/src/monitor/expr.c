#include "../../include/temu.h"

#include <sys/types.h>
#include <regex.h>
#include <stdlib.h>

#define TOKEN_SIZE 32


enum {
	NOTYPE = 256, 
	EQ,NEQ,AND,OR, 
	DEREF,NGE,NOT,
	REG, NUMBER, HEX,
};

static struct rule {
	char *regex;
	int token_type;
} rules[] = {
	{" +",	NOTYPE},				
	{"\\+", '+'},					
	{"==", EQ},						
	{"!=", NEQ},
	{"-", '-'},					
	{"\\*", '*'},					
	{"/", '/'},					
	{"&&", AND},
	{"\\|\\|", OR},
	{"!", NOT},
	{"-", NGE},						//负数
	{"\\*", DEREF},					//指针
	{"\\(", '('},
	{"\\)", ')'},
	{"\\$[a-z][0-9]",REG},                             
    {"\\$[a-z]*",REG},                             
	{"0x[0-9a-fA-F]+", HEX},		//16进制实现	
	{"[0-9]+", NUMBER},				
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];

uint32_t getRecursiveResult(uint32_t left,uint32_t right);
bool checkBracket(uint32_t left,uint32_t right);
uint32_t searchDomOp(uint32_t left, uint32_t right);

void init_regex() {
	int i;
	char error_msg[128];
	int ret;

	for(i = 0; i < NR_REGEX; i ++) {
		ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
		if(ret != 0) {
			regerror(ret, &re[i], error_msg, 128);
			Assert(ret == 0, "regex compilation failed: %s\n%s", error_msg, rules[i].regex);
		}
	}
}

typedef struct token {
	int type;
	char str[TOKEN_SIZE];
} Token;

Token tokens[TOKEN_SIZE];
int nr_token;

//以上是初始化部分

//正则表达式解析
static bool make_token(char *e) {
	int position = 0;
	int i;
	regmatch_t pmatch;
	
	nr_token = 0;

	while(e[position] != '\0') {
		for(i = 0; i < NR_REGEX; i ++) {
			if(regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
				char *substr_start = e + position;
				int substr_len = pmatch.rm_eo;

				Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s", i, rules[i].regex, position, substr_len, substr_len, substr_start);

				switch(rules[i].token_type) {
					case NOTYPE:break;				
					//区分解引用和乘法
					case '*':
						if(nr_token==0 || ((tokens[nr_token-1].type!=NUMBER) && (tokens[nr_token-1].type!=HEX) && (tokens[nr_token-1].type!=')')))
						{
								tokens[nr_token].type=DEREF;
								nr_token++;
								break;
						}
					case '-'://区分负数和减法
						if(nr_token==0 || ((tokens[nr_token-1].type!=NUMBER) && (tokens[nr_token-1].type!=HEX) && (tokens[nr_token-1].type!=')')))
						{
								tokens[nr_token].type=NGE;
								nr_token++;
								break;
						}	
					default:
						tokens[nr_token].type = rules[i].token_type;
						strncpy(tokens[nr_token].str,substr_start,substr_len);
						nr_token++;
						break;
				}
				position += substr_len;

				break;
			}
		}

		if(i == NR_REGEX) {
			printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
			return false;
		}
	}

	return true; 
}

// 根据名称查找寄存器
int getREG(const char *regName)
{
	if(strcmp("$pc",regName)==0)
		return cpu.pc;
	int index = -1;
	const char *regfile[] = {"$zero", "ra", "$tp", "$sp", "a0", "$a1", "$a2", "$a3", "$a4", "$a5", "$a6", "$a7", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$x", "$fp", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$s8"};
    int size = sizeof(regfile) / sizeof(regfile[0]);

	int res = 0;

    for (int i = 0; i < size; i++) {
        if (strcmp(regName, regfile[i]) == 0) {
            index =  i;
			break;
        }
    }

	if(index == -1)
	{
		printf("[ERROR] The register in the expression does not exist!\n");
	}
	else
	{
		res = reg_w(index);

	}
	return res;
}

// 递归函数
uint32_t getRecursiveResult(uint32_t left,uint32_t right){
	if (left>right)
		assert(0);

	//纯数字或寄存器，字符串转换
	if(left == right)
	{
		uint32_t n;
		switch (tokens[right].type)
		{
		case HEX:
			n = strtoull(tokens[right].str,NULL,16);
			break;
		case NUMBER:
			n = strtoull(tokens[right].str,NULL,10);
			break;
		
		case REG:
			n = getREG(tokens[right].str);
			break;
		}

	
		return n;
	}

	//去括号
	else if(checkBracket(left,right) == true)
		return getRecursiveResult(left+1,right-1);
	//递归计算
	else
	{
		uint32_t OpIndex=searchDomOp(left,right);

		switch (tokens[OpIndex].type)
		{
		case NGE:
			return -getRecursiveResult(left+1,right);
			break;
		case NOT:
			return !getRecursiveResult(left+1,right);
			break;
		case DEREF:
			return mem_read(getRecursiveResult(left+1,right),4);
			break;
		default:
			break;
		}
			

		uint32_t left_res=getRecursiveResult(left,OpIndex-1);
		uint32_t right_res=getRecursiveResult(OpIndex+1,right);

		int res=0;
		switch(tokens[OpIndex].type)
		{
			case '+': res = left_res + right_res;break;
			case '-': res = left_res - right_res;break;
			case '*': res = left_res * right_res;break;
			case '/': res = left_res / right_res;break;
			case EQ: res = left_res == right_res;break;
			case NEQ: res = left_res != right_res;break;
			case AND: res = left_res && right_res;break;
			case OR: res = left_res || right_res;break;
			default:
				Assert(0,"[ERROR] Unknown symbol.\n");
		}
		return res;
	}
}

// 检查括号完整性,这里调整了之前对正则表达式的要求
bool checkBracket(uint32_t left,uint32_t right){
	int BracketNum=0;
	if(tokens[left].type!='(' || tokens[right].type!=')')
	{
		return false;
	}
	while(left <= right)
	{
		if(BracketNum<0)
			return false;
		if(tokens[left].type=='(')
			BracketNum++;
		if(tokens[left].type==')')
			BracketNum--;
		if(BracketNum == 0)
			break;
		left++;
	}

	//只能允许一个括号
	if(left == right)
		return true;
	else
		return false;
}

//找到dominant operator
uint32_t searchDomOp(uint32_t left, uint32_t right){	
	int BracketNum = 0;
	int OpIndex = left;
	int OpRank = 0;

	for(;left<=right;left++)
	{
		// 跳过数据类型
		if(tokens[left].type == NUMBER || tokens[left].type == HEX || tokens[left].type == NOT || tokens[left].type == DEREF || tokens[left].type == REG || tokens[left].type == NGE)
			continue;
		
		// 跳过括号
		else if(tokens[left].type == '(')
		{
			BracketNum++;
			left++;

			int max_len = 0;
			// 检查匹配
			while(BracketNum!=0)
			{
				if(tokens[left].type == '(')
					BracketNum++;
				else if(tokens[left].type == ')')
					BracketNum--;
				left++;
				if(max_len++ == 1000)
					Assert(0,"[ERROR] Expression error.\n");
			}
			left--;
		}
		
		else if(tokens[left].type == NGE)
		{
			if(OpRank<=2)
			{
				OpIndex=left;
				OpRank=2;
			}
		}
		else if(tokens[left].type == '/' || tokens[left].type =='*')
		{
			if(OpRank<=3)
			{
				OpIndex=left;
				OpRank=3;
			}
		}
		else if(tokens[left].type == '+' || tokens[left].type =='-')
		{
			if(OpRank<=4)
			{
				OpIndex=left;
				OpRank=4;
			}
		}
		else if(tokens[left].type == EQ || tokens[left].type ==NEQ)
		{
			if(OpRank<=7)
			{
				OpIndex=left;
				OpRank=7;
			}
		}
		else if(tokens[left].type == AND)
		{
			if(OpRank<=11)
			{
				OpIndex=left;
				OpRank=11;
			}
		}
		else if(tokens[left].type == OR)
		{
			if(OpRank<=12)
			{
				OpIndex=left;
				OpRank=12;
			}
		}
	}
	return OpIndex;

}


uint32_t expr(char *e, bool *success) {
	if(!make_token(e)) {
		*success = false;
		return 0;
	}
	return getRecursiveResult(0,nr_token-1);
}

// 最终对外实现函数
int callRegExp(char* str){
	bool suc = 0;
	bool* psuc = &suc;


	int result = expr(str,psuc);
	printf("expr result:%d\n",result);
	return result;
}
