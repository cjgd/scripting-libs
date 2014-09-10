# iso2asc.pl -- converts lastin1 to best ascii aproximation
# $Id$
# Carlos Duarte <cgd@teleweb.pt>, 991101

# tables are from Markus Kuhn -- 1993-02-20 doc on iso8859-1 to ascii

use strict; 

{my (@t0, @t1); {
	my @a = split ' ',<<'EOF'; 
� 161 ! !	� 162 c c	� 163 ? ?	� 164 ? ?
� 165 Y Y	� 166 | |	� 167 ? ?	� 168 " "
� 169 c (c)	� 170 a a	� 171 < <<	� 172 - -
� 173 - -	� 174 R (R)	� 175 - -	� 176 ? o
� 177 ? +/-	� 178 2  2	� 179 3 3	� 180 ' '
� 181 u u	� 182 P P	� 183 . .	� 184 , ,
� 185 1 1	� 186 o o	� 187 > >>	� 188 ? 1/4
� 189 ? 1/2	� 190 ? 3/4	� 191 ? ?	� 192 A A
� 193 A A	� 194 A A	� 195 A A	� 196 A A
� 197 A A	� 198 A AE	� 199 C C	� 200 E E
� 201 E E	� 202 E E	� 203 E E	� 204 I I
� 205 I I	� 206 I I	� 207 I I	� 208 D D
� 209 N N	� 210 O O	� 211 O O	� 212 O O
� 213 O O	� 214 O O	� 215 x x	� 216 O O
� 217 U U	� 218 U U	� 219 U U	� 220 U U
� 221 Y Y	� 222 T Th	� 223 s ss	� 224 a a
� 225 a a	� 226 a a	� 227 a a	� 228 a a
� 229 a a	� 230 a ae	� 231 c c	� 232 e e
� 233 e e	� 234 e e	� 235 e e	� 236 i i
� 237 i i	� 238 i i	� 239 i i	� 240 d d
� 241 n n	� 242 o o	� 243 o o	� 244 o o
� 245 o o	� 246 o o	� 247 : :	� 248 o o
� 249 u u	� 250 u u	� 251 u u	� 252 u u
� 253 y y	� 254 t th	� 255 y y
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
