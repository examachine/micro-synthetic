%module "paq8f"
%{

extern float compressed_size_bitstring(char *bitstring, int length);

%}

/*struct bitstring {
	char *string;
	int length;
};
*/

extern void init(int level=6);
extern float compressed_size_bitstring(char *bitstring, int length);

