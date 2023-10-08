#include "temu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */

//PS 此段的计算式不知道要实现到什么程度，暂且计划实现普通数学计算和寄存器
#include <sys/types.h>
#include <regex.h>

// 规则编号
/* TODO: Add more token types */
enum {
	NOTYPE = 256, 

	EQ,

	HEX,
	NUMBER,

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

	{"\\+", '+'},// 加法
	{"-", '-'}, // 减法
	{"\\*", '*'}, // 乘法
  	{"/", '/'}, // 除法

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

typedef struct token {
	int type;
	char str[32];
} Token;


// 预留词法分析的token缓冲区（这是tm的编译原理吗）
#define TOKENS_SIZE 32
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
		printf("token%d: %d, %s\n",i,tokens[i].type,tokens[i].str);
	}


	//return的时候注意token计数器是否需要归零？
	return true; 
}


//外部调用函数，这里再做一层封装
uint32_t expr(char *e, bool *success) {
	if(!make_token(e)) {
		*success = false;
		return 0;
	}

	/* TODO: Insert codes to evaluate the expression. */
	//panic("please implement me");

	// 这里已经完成了对token的解析，接下来是运算部分
	

	return 0;
}

// 最终对外实现函数，返回值的提示之类的还没做，先实现核心功能
bool callRegExp(char* str){
	bool suc = 0;
	bool* psuc = &suc;
	return expr(str,psuc);
}