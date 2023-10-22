#include "temu.h"
#include <stdlib.h>
/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */

//PS 此段的计算式不知道要实现到什么程度，暂且计划实现普通数学计算和寄存器
#include <sys/types.h>
#include <regex.h>

// 规则编号
/* TODO: Add more token types */

# define TOKEN_LEVEL_1 128
# define TOKEN_LEVEL_2 256
# define TOKEN_LEVEL_3 512
# define TOKEN_LEVEL_4 1024
enum {
	//运算符小于lv1

	EQ = TOKEN_LEVEL_1+1,
	NOT_EQ,
	AND,
	OR,
	NOT,

	HEX = TOKEN_LEVEL_2+1,
	NUMBER,

	NOTYPE = TOKEN_LEVEL_3+1,
	REG = TOKEN_LEVEL_4 + 1,
};


// 正则表达式的规则树实现
static struct rule {
	char *regex;
	int token_type;
} rules[] = {
	{"\\$pc",REG},
	{"\\$zero", REG},            // $zero
    {"ra", REG},                 // ra
    {"\\$tp", REG},              // $tp
    {"\\$sp", REG},              // $sp
    {"a[0-9]", REG},             // a0-a9
    {"\\$a[1-7]", REG},          // $a1-$a7
    {"\\$t[0-8]", REG},          // $t0-$t8
    {"\\$x", REG},               // $x
    {"\\$fp", REG},              // $fp
    {"\\$s[0-8]", REG},           // $s0-$s8

	{"0x[0-9A-Fa-f]+",HEX},//16进制数
	{"[0-9]+", NUMBER}, // 数字

	{" +",	NOTYPE},// 匹配空格
	{"\\(", '('}, // 左括号 
  	{"\\)", ')'}, // 右括号

	{"\\*", '*'}, // 乘法
  	{"/", '/'}, // 除法

	{"\\+", '+'},// 加法
	{"-", '-'}, // 减法

	{"==", EQ},// equal
	{"!=",NOT_EQ},
	{"&&",AND},
	{"||",OR},
	{"!",NOT},


};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];

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


# define TOKEN_STR_SIZE 32
typedef struct token {
	int type;
	char str[TOKEN_STR_SIZE];
} Token;


// 预留词法分析的token缓冲区（这是tm的编译原理吗）
#define TOKENS_SIZE 32
#define UNCATCH_TOKEN -404

Token tokens[TOKENS_SIZE];


typedef struct comput_unit{
	Token comput_token[TOKENS_SIZE];
}comput_unit;
comput_unit unit[TOKENS_SIZE];
int unit_size = 0;


// token序列号
int nr_token;

//token识别函数
static bool make_token(char *e) {
	int position = 0;
	int i;
	regmatch_t pmatch;
	
	nr_token = 0;
	const int ERR_LIMIT = 100;
	int index_num = 0;

	while(e[position] != '\0') {

		if(index_num++ > ERR_LIMIT){printf("Too many tokens.\n");break;}

		/* Try all rules one by one. */
		for(i = 0; i < NR_REGEX; i ++) {
			if(regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
				char *substr_start = e + position;
				int substr_len = pmatch.rm_eo;

				Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s", i, rules[i].regex, position, substr_len, substr_len, substr_start);
				position += substr_len;

				//检查token长度，之后再对超限情况做出处理
				if(substr_len>32){printf("Warring: substr_len is more than 32");}

				switch(rules[i].token_type) 
				{
					case NUMBER:
						{strncpy(tokens[nr_token].str,substr_start,substr_len);break;}
					case HEX:
						{strncpy(tokens[nr_token].str,substr_start,substr_len);break;}
					case '+':break;
					case '-':break;
					case '*':break;
					case '/':break;
					case '(':break;
					case ')':break;
					case EQ:break;
					case NOT_EQ:break;
					case AND:break;
					case OR:break;
					case NOT:break;
					case NOTYPE:break;
					case REG:
						{strncpy(tokens[nr_token].str,substr_start,substr_len);break;}

					default:panic("rules switch err\n");
				}

				//记录token类型,排除空格
				if(rules[i].token_type == NOTYPE){break;}
				tokens[nr_token].type = rules[i].token_type; 

				//tokens缓冲区增加,token貌似超出了也能识别到，是由于动态分配内存导致的吗,还是内存上限设置不是上面的32？
				nr_token++;

				break;
			}
		}

		if(i == NR_REGEX) {
			printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
			return false;
		}
	}

	//词法分析器调试部分


	//return的时候注意token计数器是否需要归零？
	return true; 
}


// 找到dominant operator的封装函数
static int searchDomOp(Token* ts,unsigned token_num){

	if(ts == NULL){
		Assert(0,"错误:空指针错误exp-01\n");
	}

	Token* scan_ptr = ts;
	Token* dom_op = NULL;

	int bracket = 0;
	int index = -1;



	for(int i=0; i<token_num; scan_ptr++,i++)
	{

		// 匹配括号(bug fix:只有括号的情况，bug,多重括号会有问题)
		if(scan_ptr->type == '('){
			bracket += 1;
			continue;
		}

		if(bracket == 1)
		{
			if(scan_ptr->type == ')')
			{
				bracket -=1 ;
			}
			continue;

		}

		

		// 扫描运算符
		
		if(scan_ptr->type < TOKEN_LEVEL_1)
		{

			if(dom_op == NULL){
				dom_op = scan_ptr;
				index = i;
			}

			if((scan_ptr->type == '+')||(scan_ptr->type == '-')){
				//这里处理负数的情况
				if( i == index+1 ){
					//printf("#警告:负数请加括号\n");
					continue;
				}


				dom_op = scan_ptr;
				index = i;
			}

			if((scan_ptr->type == '*')||(scan_ptr->type == '/')){
				if((dom_op->type == '+')||(scan_ptr->type == '-')){
					continue;
				}
				dom_op = scan_ptr;
				index = i;
			}
		}

		if((scan_ptr->type < TOKEN_LEVEL_2)&&(scan_ptr->type > TOKEN_LEVEL_1))
		{
			dom_op = scan_ptr;
			index = i;

			if((scan_ptr->type == AND)||(scan_ptr->type == OR)){
				dom_op = scan_ptr;
				index = i;
			}
			else{
				if((scan_ptr->type == NOT_EQ)||(scan_ptr->type == EQ)){
					dom_op = scan_ptr;
					index = i;
				}
			}
			
		}

		
	}

	//检查括号匹配的完整性
	if(bracket != 0){
		Assert(0,"#括号匹配不完整\n");
	}

	//检查有无运算符
	if(index == -1){
		//情况1：无运算符,括号包含了整个算式（3+4）
		if(ts[0].type == '(')
		{
			index = -2;
		}
		//情况2：无运算符,纯非负数字 1
		index = -1;
	}

	//检查是不是纯负数
	if(index == 0){
		//纯负数 -1
		if(dom_op->type == '-'){
			index = -3;
		}
	}

	//printf("$index: %d\n",index);
	return index;
}

// 根据名称查找寄存器
char* getREG(const char *regName)
{
	int index = -1;
	const char *regfile[] = {"$zero", "ra", "$tp", "$sp", "a0", "$a1", "$a2", "$a3", "$a4", "$a5", "$a6", "$a7", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$x", "$fp", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$s8"};
    int size = sizeof(regfile) / sizeof(regfile[0]);

	char* str  =(char*) malloc(sizeof(char)*20);
	memset(str,'\0',20);
	int res = 0;

    for (int i = 0; i < size; i++) {
        if (strcmp(regName, regfile[i]) == 0) {
            index =  i;
			break;
        }
    }

	if(index == -1)
	{
		res = cpu.pc;
		sprintf(str, "%d", res);
	}
	else
	{
		res = reg_w(index);
		sprintf(str, "%d", res);
	}
	return str;
}

// 16进制字符串转数字
int HEXToInt(char* str){
	int result = 0;
    int i = 0;

    while (str[i] != '\0') 
	{
		int digit = str[i] - '0';
		switch (str[i])
		{
		case 'a':
			digit = 10;
			break;
		case 'b':
			digit = 11;
			break;
		case 'c':
			digit = 12;
			break;
		case 'd':
			digit = 13;
			break;
		case 'e':
			digit = 14;
			break;
		case 'f':
			digit = 15;
			break;
		case 'A':
			digit = 10;
			break;
		case 'B':
			digit = 11;
			break;
		case 'C':
			digit = 12;
			break;
		case 'D':
			digit = 13;
			break;
		case 'E':
			digit = 14;
			break;
		case 'F':
			digit = 15;
			break;
		
		default:
			digit = str[i] - '0';
			break;
		}
        result = result * 16 + digit;
        i++;
    }

    return result;
}

// 10进制字符串转数字
int stringToInt(char* str) {
    int result = 0;
    int sign = 1;
    int i = 0;
	//识别负数
	if (str[0] == '-') 
	{
		sign = -1;
		i = 1;
	}

    while (str[i] != '\0') {
		if(str[i] == 'x'){
			//识别到HEX
			result =  sign * HEXToInt(&str[i+1]);
			break;
		}
        int digit = str[i] - '0';
        result = result * 10 + digit;
        i++;
    }

	//printf("%s :stringToInt: %d\n",str, sign * result);
    return sign * result;
}


//封装一个递归实现计算的函数
int getRecursiveResult(Token* ts,unsigned token_num){

	int index = searchDomOp(ts,token_num);

	if(index == 0)//错误
	{
		Assert(0,"index 是 0\n");
	}
	if(index == -1)//转数字
	{	
		return stringToInt(ts->str);
	}
	if(index == -2)//去括号
	{
		ts++;
		return getRecursiveResult(ts,token_num-2);
	}
	if(index == -3)//是负数
	{	
		//printf("捕获到负数\n");
		Token li[3];
		li[0].type = NUMBER;
		strcpy(li[0].str,"0");
		li[1].type = '-';
		li[2].type = NUMBER;
		strcpy(li[2].str,ts[1].str);
		return getRecursiveResult(&li[0],3);
	}

	Token* part1 = ts;
	Token* part2 = ts;


	for(int i=0;i<index+1;i++){
		part2++;
	}

	//递归开始部分
	int res = -443;
	int res1 = -444;
	int res2 = -445;
	char icon[10] = "UNKNOW";

	res1 = getRecursiveResult(part1,index);
	res2 = getRecursiveResult(part2,token_num-index-1);

	switch ((ts[index].type))
	{
	case '+':
		res = res1+res2;
		strcpy(icon,"+");
		break;

	case '-':
		res = res1-res2;
		strcpy(icon,"-");
		break;

	case '*':
		res = res1*res2;
		strcpy(icon,"*");
		break;

	case '/':
		res = res1/res2;
		strcpy(icon,"/");
		break;
	
	case AND:
		res = res1&&res2;
		strcpy(icon,"&&");	
		break;

	case OR:
		res = res1&&res2;
		strcpy(icon,"||");
		break;

	case EQ:
		res = res1==res2;
		strcpy(icon,"==");
		break;

	case NOT_EQ:
		res = res1!=res2;
		strcpy(icon,"!=");
		break;


	default:
		panic("err in switch. \n");
		break;
	}


	//printf("%d %s %d = %d\n",res1,icon,res2,res);
	return res;
}


//外部调用函数，这里再做一层封装，作为递归表达式的求值处理
int expr(char *e, bool *success) 
{
	//解析所有token
	if(!make_token(e)) {
		*success = false;
		return 0;
	}
	*success = true;

	//在这里替换所有寄存器代号为具体值
	Token* ptr = tokens;
	for(int i=0;i<nr_token;i++,ptr++)
	{
		if(ptr->type == REG)
		{
			ptr->type = NUMBER;
			char* res = getREG(ptr->str);
			strcpy(ptr->str,res);
		}
	}

	int result = getRecursiveResult(tokens,nr_token);
	//printf("expr result:%d\n",result);

	return result;
}


// 最终对外实现函数，返回值的提示之类的还没做，先实现核心功能
int callRegExp(char* str){
	bool suc = 0;
	bool* psuc = &suc;

	//初始化
	for(int i=0;i<TOKENS_SIZE;i++){

		(tokens[i]).type = UNCATCH_TOKEN;
		
		for(int j=0; j<TOKEN_STR_SIZE; j++){
			(tokens[i]).str[j] = '\0';
		}
	}

	int result = expr(str,psuc);

	if(suc == 0){
		assert(0);
	}
	return result;
}
