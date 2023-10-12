#include "temu.h"

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
enum {
	EQ = TOKEN_LEVEL_1,

	HEX = TOKEN_LEVEL_2,
	NUMBER,

	NOTYPE = TOKEN_LEVEL_3, 
};


// 正则表达式的规则树实现
static struct rule {
	char *regex;
	int token_type;
} rules[] = {

	/* TODO: Add more rules.
	 * Pay attention to the precedence level of different rules.
	 */

	{"0x[0-9A-Fa-f]+",HEX},//16进制数
	{"[0-9]+", NUMBER}, // 数字

	{" +",	NOTYPE},// 匹配空格
	{"\\(", '('}, // 左括号 
  	{"\\)", ')'}, // 右括号

	{"\\*", '*'}, // 乘法
  	{"/", '/'}, // 除法

	{"\\+", '+'},// 加法
	{"-", '-'}, // 减法

	{"==", EQ}// equal
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
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


// token序列号
int nr_token;

//token识别函数
static bool make_token(char *e) {
	int position = 0;
	int i;
	regmatch_t pmatch;
	
	nr_token = 0;

	while(e[position] != '\0') {
		/* Try all rules one by one. */
		for(i = 0; i < NR_REGEX; i ++) {
			if(regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
				char *substr_start = e + position;
				int substr_len = pmatch.rm_eo;

				Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s", i, rules[i].regex, position, substr_len, substr_len, substr_start);
				position += substr_len;

				/* TODO: Now a new token is recognized with rules[i]. Add codes
				 * to record the token in the array `tokens'. For certain types
				 * of tokens, some extra actions should be performed.
				 */

				//tips:这里是词法分析器的存储token的部分，针对不同类型token做出记录

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
					case NOTYPE:break;

					default:panic("please implement me");
				}

				//记录token类型
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
	printf("total tokens number: %d\n",nr_token);
	for(int i=0;i<nr_token;i++){
		if(tokens[i].type<TOKEN_LEVEL_2){
			printf("token%d: %c, %s\n",i,tokens[i].type,tokens[i].str);
		}
		else printf("token%d: %d, %s\n",i,tokens[i].type,tokens[i].str);
	}


	//return的时候注意token计数器是否需要归零？
	return true; 
}


// 找到dominant operator的封装函数
static int searchDomOp(Token* ts,unsigned token_num){
	Token* scan_ptr = ts;
	Token* dom_op = NULL;

	int bracket = 0;
	int index = -1;
	for(int i=0; i<token_num; scan_ptr++,i++){

		// 匹配括号
		if(bracket == 1){
			if(scan_ptr->type == ')'){
				bracket = 0;
				continue;
			}
			else{
				continue;
			}
		}
		if(scan_ptr->type == '('){
			bracket = 1;
			continue;
		}

		// 扫描运算符
		if(scan_ptr->type < TOKEN_LEVEL_1){
			if(dom_op == NULL){
				dom_op = scan_ptr;
				index = i;
			}

			if((scan_ptr->type = '+')||(scan_ptr->type == '-')){
				//这里处理负数的情况
				if((dom_op->type == '+')&&(scan_ptr->type == '-')){
					if( i == index+1 ){
						continue;
					}
				}


				dom_op = scan_ptr;
				index = i;

				printf("in-for-token:%c\n",ts[index].type);
			}
			else{
				if((scan_ptr->type = '*')||(scan_ptr->type = '/')){
					dom_op = scan_ptr;
					index = i;
				}
			}
		}

		
		
	}

	//检查有无运算符
	if(index == -1){
		return -1;
	}

	//检查是不是负数
	if(index == 0){
		if(dom_op->type == '-'){
			return 0;
		}
		//检查是不是括号边缘
		else if(dom_op->type == '('){
			return -2;
		}
		else if(dom_op->type == ')'){
			return -2;
		}
	}

		//检查括号匹配的完整性
	if(bracket == 1){
		assert(99);
	}

	printf("in-search-token:%c\n",ts[index].type);
	return index;
}


// 字符串转数字
int stringToInt(char* str) {
    int result = 0;
    int sign = 1;
    int i = 0;

    if (str[0] == '-') {
        sign = -1;
        i = 1;
    }

    while (str[i] != '\0') {
        int digit = str[i] - '0';
        result = result * 10 + digit;
        i++;
    }

	//printf("stringToInt:%d\n",sign * result);
    return sign * result;
}


//封装一个递归实现计算的函数
int getRecursiveResult(Token* ts,unsigned token_num){

	Token* p = ts;
	for(int i=0;i<token_num;i++,p++){
		if(p->type<TOKEN_LEVEL_2)
			printf("token:%c\n",p->type);
		else
			printf("token:%d\n",p->type);
	}
	printf("******");

	int index = searchDomOp(ts,token_num);

	p = ts;
	for(int i=0;i<token_num;i++,p++){
		if(p->type<TOKEN_LEVEL_2)
			printf("token:%c\n",p->type);
		else
			printf("token:%d\n",p->type);
	}
	printf("******");

	if(index != -1)
		printf("dom index:%d, type: %c\n",index,ts[index].type);


	if(index == 0){
		printf("0src: %s\n",ts->str);
		return stringToInt(ts->str);
	}
	if(index == -1){
		printf("-1src: %s\n",ts->str);
		return stringToInt(ts->str);
	}
	if(index == -2){
		printf("-2src: %s\n",ts->str);
		return stringToInt((ts++)->str);
	}

	Token* part1 = ts;
	Token* part2 = ts;
	for(int i=0;i<=index;i++){
		part2++;
	}

	//递归开始部分
	//int res = -403;

	int res = -443;
	int res1 = -444;
	int res2 = -445;

	

	switch ((ts[index].type))
	{
	case '+':
		res1 = getRecursiveResult(part1,index);
		res2 = getRecursiveResult(part2,token_num-index-1);
		printf("+ res1:%d,res2:%d\n",res1,res2);
		res = res1+res2;
		break;
	case '-':
		res1 = getRecursiveResult(part1,index);
		res2 = getRecursiveResult(part2,token_num-index-1);
		printf("- res1:%d,res2:%d\n",res1,res2);
		res = res1-res2;
		break;
	case '*':
		res1 = getRecursiveResult(part1,index);
		res2 = getRecursiveResult(part2,token_num-index-1);
		printf("* res1:%d,res2:%d\n",res1,res2);
		res = res1*res2;
		break;
	case '/':
		res1 = getRecursiveResult(part1,index);
		res2 = getRecursiveResult(part2,token_num-index-1);
		printf("/ res1:%d,res2:%d\n",res1,res2);
		res = res1/res2;
		//res = getRecursiveResult(part1,index) / getRecursiveResult(part2,token_num-index-1);
		break;	

	default:
		panic("err in switch.\n");
		break;
	}

	return res;
}


//外部调用函数，这里再做一层封装，作为递归表达式的求值处理
uint32_t expr(char *e, bool *success) {
	if(!make_token(e)) {
		*success = false;
		return 0;
	}

	printf("--------\n");
	/* TODO: Insert codes to evaluate the expression. */
	//panic("please implement me");

	// 这里已经完成了对token的解析，接下来是运算部分，以下代码按照指导书的介绍设计
	//tips: 可能需要实现区分负数的功能

	int result = getRecursiveResult(tokens,nr_token);

	printf("result:%d\n",result);
	return 0;
}


// 最终对外实现函数，返回值的提示之类的还没做，先实现核心功能
bool callRegExp(char* str){
	bool suc = 0;
	bool* psuc = &suc;

	for(int i=0;i<TOKENS_SIZE;i++){
		(tokens[i]).type = UNCATCH_TOKEN;
		for(int j=0; j<TOKEN_STR_SIZE; j++){
			(tokens[i]).str[i] = '\0';
		}
	}

	return expr(str,psuc);
}