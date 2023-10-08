#include "temu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>


/* TODO: Add more token types */
enum {
	NOTYPE = 256, 

	EQ,

	HEX,
	NUMBER,

};

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

				switch(rules[i].token_type) 
				{
					case NUMBER:
						{strncpy(tokens[nr_token].str,substr_start,substr_len);break;}
					case HEX:
						{break;}
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
				tokens[nr_token].type=rules[i].token_type; 

				//tokens缓冲区增加
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

	return true; 
}

uint32_t expr(char *e, bool *success) {
	if(!make_token(e)) {
		*success = false;
		return 0;
	}

	/* TODO: Insert codes to evaluate the expression. */
	panic("please implement me");
	return 0;
}

bool callRegExp(char* str){
	return make_token(str);
}