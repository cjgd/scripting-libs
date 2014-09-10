# iso2asc.pl -- converts lastin1 to best ascii aproximation
# $Id$
# Carlos Duarte <cgd@teleweb.pt>, 991101

# tables are from Markus Kuhn -- 1993-02-20 doc on iso8859-1 to ascii

use strict; 

{my (@t0, @t1); {
	my @a = split ' ',<<'EOF'; 
¡ 161 ! !	¢ 162 c c	£ 163 ? ?	¤ 164 ? ?
¥ 165 Y Y	¦ 166 | |	§ 167 ? ?	¨ 168 " "
© 169 c (c)	ª 170 a a	« 171 < <<	¬ 172 - -
­ 173 - -	® 174 R (R)	¯ 175 - -	° 176 ? o
± 177 ? +/-	² 178 2  2	³ 179 3 3	´ 180 ' '
µ 181 u u	¶ 182 P P	· 183 . .	¸ 184 , ,
¹ 185 1 1	º 186 o o	» 187 > >>	¼ 188 ? 1/4
½ 189 ? 1/2	¾ 190 ? 3/4	¿ 191 ? ?	À 192 A A
Á 193 A A	Â 194 A A	Ã 195 A A	Ä 196 A A
Å 197 A A	Æ 198 A AE	Ç 199 C C	È 200 E E
É 201 E E	Ê 202 E E	Ë 203 E E	Ì 204 I I
Í 205 I I	Î 206 I I	Ï 207 I I	Ð 208 D D
Ñ 209 N N	Ò 210 O O	Ó 211 O O	Ô 212 O O
Õ 213 O O	Ö 214 O O	× 215 x x	Ø 216 O O
Ù 217 U U	Ú 218 U U	Û 219 U U	Ü 220 U U
Ý 221 Y Y	Þ 222 T Th	ß 223 s ss	à 224 a a
á 225 a a	â 226 a a	ã 227 a a	ä 228 a a
å 229 a a	æ 230 a ae	ç 231 c c	è 232 e e
é 233 e e	ê 234 e e	ë 235 e e	ì 236 i i
í 237 i i	î 238 i i	ï 239 i i	ð 240 d d
ñ 241 n n	ò 242 o o	ó 243 o o	ô 244 o o
õ 245 o o	ö 246 o o	÷ 247 : :	ø 248 o o
ù 249 u u	ú 250 u u	û 251 u u	ü 252 u u
ý 253 y y	þ 254 t th	ÿ 255 y y
EOF
	@t0 = map {chr} 0..255; 
	@t1 = map {chr} 0..255; 
	while (defined($_ = shift @a)) {
		if (/^\d\d\d$/) {
			$t0[$_] = shift @a; 
			$t1[$_] = shift @a; 
		}
	}
}

sub iso2asc {
	local $_ = shift; 
	s/./$t0[ord($&)]/sg; 
	return $_; 
}

sub iso2asc_best {
	local $_ = shift; 
	s/./$t1[ord($&)]/sg; 
	return $_; 
}}

## TEST
while (<>) {
	chomp; 
	print "$_ -> ", iso2asc($_), " --> ", iso2asc_best($_), "\n"; 
}
