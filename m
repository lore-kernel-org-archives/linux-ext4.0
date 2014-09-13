From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/34] tests: test resize2fs 32->64 and 64->32bit conversion
 code
Date: Sat, 13 Sep 2014 15:13:31 -0700
Message-ID: <20140913221331.13646.71600.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24493 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIMWNg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:13:36 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add some simple tests to check that flex_bg and meta_bg filesystems
can be converted between 32 and 64bit layouts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/r_32to64bit/expect.gz      |  Bin
 tests/r_32to64bit/name           |    1 +
 tests/r_32to64bit/script         |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_32to64bit_meta/expect.gz |  Bin
 tests/r_32to64bit_meta/name      |    1 +
 tests/r_32to64bit_meta/script    |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_64to32bit/expect.gz      |  Bin
 tests/r_64to32bit/name           |    1 +
 tests/r_64to32bit/script         |   75 ++++++++++++++++++++++++++++++++++++++
 tests/r_64to32bit_meta/expect.gz |  Bin
 tests/r_64to32bit_meta/name      |    1 +
 tests/r_64to32bit_meta/script    |   75 ++++++++++++++++++++++++++++++++++++++
 12 files changed, 304 insertions(+)
 create mode 100644 tests/r_32to64bit/expect.gz
 create mode 100644 tests/r_32to64bit/name
 create mode 100644 tests/r_32to64bit/script
 create mode 100644 tests/r_32to64bit_meta/expect.gz
 create mode 100644 tests/r_32to64bit_meta/name
 create mode 100644 tests/r_32to64bit_meta/script
 create mode 100644 tests/r_64to32bit/expect.gz
 create mode 100644 tests/r_64to32bit/name
 create mode 100644 tests/r_64to32bit/script
 create mode 100644 tests/r_64to32bit_meta/expect.gz
 create mode 100644 tests/r_64to32bit_meta/name
 create mode 100644 tests/r_64to32bit_meta/script


diff --git a/tests/r_32to64bit/expect.gz b/tests/r_32to64bit/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c0ba3b77f70ea2cf5d32c91f95edf1d40da5b35c
GIT binary patch
literal 3143
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
H3m5(isi#o3

literal 0
HcmV?d00001

diff --git a/tests/r_32to64bit/name b/tests/r_32to64bit/name
new file mode 100644
index 0000000..fb45fab
--- /dev/null
+++ b/tests/r_32to64bit/name
@@ -0,0 +1 @@
+convert flex_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit/script b/tests/r_32to64bit/script
new file mode 100644
index 0000000..73493a4
--- /dev/null
+++ b/tests/r_32to64bit/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -b" >> $OUT
+$RESIZE2FS $TMPFILE -b -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_32to64bit_meta/expect.gz b/tests/r_32to64bit_meta/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..dc1e284e195e56235b166faaedf2e0337018ab08
GIT binary patch
literal 2955
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
Wd;GU73@H3&a^fbKU_x}`;P^N2d#Bt0

literal 0
HcmV?d00001

diff --git a/tests/r_32to64bit_meta/name b/tests/r_32to64bit_meta/name
new file mode 100644
index 0000000..d83492e
--- /dev/null
+++ b/tests/r_32to64bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 32bit fs to 64bit fs
diff --git a/tests/r_32to64bit_meta/script b/tests/r_32to64bit_meta/script
new file mode 100644
index 0000000..5d02114
--- /dev/null
+++ b/tests/r_32to64bit_meta/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -b" >> $OUT
+$RESIZE2FS $TMPFILE -b -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_64to32bit/expect.gz b/tests/r_64to32bit/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..247458404cca7bca9b2be6422c0a5fb6c1b59e4b
GIT binary patch
literal 3175
zcmaKsXE+;-8is3>Q>v)dPiwSl&qkGerJ9IMwGAmnVkZ)6)<|l!r&g`nRch51YOf|n
zQ6-2~lo%~hD^`da<@mmHew^$4IRBpOdf(@He?0f~iben9%r*E4l$nK=Vd`<Ei8uU1
z&(SM3?*zNu7fxFv4Qu*>1MMFTt}O7dezHVQ@sU(N^`XXR5ZQ7J6aOLW<S5oC;@#Cs
z0OTIM#DR!+Frx))xCQ^wSEl2C<wEyY^+Wq0iW|cJ!!7@g?;YPY2&=&}S7v<&EcqOZ
zX8n{m{M0?Tr?I%Hz@KgY8MJjj4gB$er}i4%ZqGZ2&iH;jC=&Pax91eCzKC0k25XJ~
zv)uxT=lot;BNrI-wdu^5?Ng=~h8l%#=D!{}*2cw2xn?#z{=IcU3@}Wb*$`d-IDa4s
zzC+t4Z!G=vYY=JH4~B)zdTg@*=poyoJ)o0Gt+j^LkLzGuB*STrIue(qLax5*>mdr~
z{+2BiK^jVboKBZ+why8&?v$uf?6((|T<V2ZGcu+-7*3zcrjJFGYNmqS+R?j3`w|~`
zsP@|F`z}F^cWSsd;>TC#y=G}X{5J9Mrs=gUL_^0RVRNhF_g%gSS{0o^U7R2`U!Fm<
zLi!GOk5z1tlWq%Y{Trh78MH+Mz9rDq$9{%lP;hI@%;2@M4f>3ICuL22?~=I4Z?%rV
zj|U{rOAKxMzGo-2Xj#;DyjSq<Prf~Usqf@2!TuIaEo&{BQj6$x5iUmEr)i~GY%jxq
z^*8$><w?+*O5dGD;NYz3#-=JW7uUf|Kx_vhzP$z5Vm<qlJ8;BSv%QK`wr=God6_fe
zGgv$o>9a$va>60`Vx=`M=OQHx06`aONb6$ctdmWe|9A-Qcx}H%=;V4NzAnB`SXb(C
zxK3*3#TCYP)Y|)};*<ZFKD$m6Gv9l8UeMIk%_#Ck*Feb~IdwA~IywAuJq}f~x{TjU
zq_%=<u5ewiE!KE^aWHS22!oU9JUe}Cs@8Yfu`2D|W41sMtasaY%j?kh6&~lgE@$#z
zjbz+@(kehh`sJ#!9uE19U<U284AwPpZ3Cj>Q&2PgM)afzc{$Snsqrp#>25dNvBl2!
z3%1Zl)%Knu(R4C>>^IO^!Yc&T=j12`yo8$AgE=l<)Z%GmCoC~lRG_YNH`?JuxJEAR
z&#y6&HACxl%$mO5qM0rDg7W8?qs51G?-L&+=w7SJTK;5`<`bMPA9<RXa_-0R;2ZMi
z!h_>E6;aKAw=&Y$&}?fNOb?5VLx3n}MANG`Vr|~Jx!MDwku~gJ7=zFuK5K^b=6jNK
zLY#5T*pZrurRH6m9|@6oWb@4ts)GX3>}#`j(Sa#N>`KR%oD*<R2x{U-K7Y~@)A~pb
zgxj+tFHLh!r772^ad1!!I%%Ohqt<L@gc+#?9qn*9@bWZ$&a>o%AaR3o0=I#W&f*os
zRhIbVDhy|j`XDgg50(~2l$^R1rhvk$6X)V3J(zuxjoi__Gtb48Kz%b&#^OfbE)PB9
zo~bmrIvEu&xoIMZEiaFEXI_}(cEFlyf|HWr3H>`fEYZ+U@6K2S_dAtzyIpjIhI82*
zgZe6?x>1P$g=$?B`?kC=PwBg<4yx&e4xq4GVV+OfZZJuS78n|ZesRHZYQoO>GdumE
zl4QSpKB_m@j3tg<bs=p)P&i*V8>K8H_4bp<&48F;X*;Q$w&$-|k>Bjzd7S-o8H_V3
z6sW8Ld^QBJv1Y52Fk~s@yKDn1@7~Db3qJ|5<@s^i4SJ<O*JMND1&A<NADy*U83#<N
zhNSS01ZY1j&!@25m!L+knwRMLJp04_TE>->w@*|{2?Lgt7k2z_V8d-$7)*Yfh%#*V
z<(o);2VOId`OTPKZ(|n-DGyL+1*Dv<2=9HQ?j7Z^G#1fHP|OqF$(QX=j_Qo0OB~c&
zL8G)L#_vaa-U5^sah)~M)6A=-Cl#MJ19nCx#5S;gl`H)c#Dgvl%LD1fCezMrg3V<H
zO-ccp`#g>-^pA}&3tc6er4E(J9UsZz>(!2cbzQ5RSCCH)|GXEbbv6Lqvic4I=uPty
zzWIJD-ezxGL-4Ryb}Q&U<D9==>3+V-NY9;ilH`8pAsF;4qDNYR?u@*fjmWKEQ3rde
zj9NDN#$<BvCbGu#+!F{duxe9~joS!JPy?Y_II|EJNQe6W46Z#+SQU?z)*Zn=RV(5z
za+ds!wwRDDLgbKG$CUm|ULGIN*Il>=@?a$xu>H)4=LoiQg*txi+P)?a9=5Vq+}!Mv
zT&#KFJa<0*^PX=%Qr8O(j!jYaSm2L&?Q3~ofNWKDK4WIGWV=oz74#Y8T@KXPmN1?Y
zmQUmUVi=&X)GkHp;8?9T>}*T)42SUII0j*3mJ7MUm?}bM7;hqE&4iZ{AoK=uUV#&7
z!0&bcjJq<%HMn535QJrsPn*1HG`uMlAuV6`yfs_$Vx~YI2G<I{Ta?q;-CN+truyvR
zYbIH#t#SUOK!AK*yZ1u~WFI0HgO=nvYEpYRm;XSjAhHtyg)H{qN7=Gm&+&F8xuJ2A
z;QwF~UErtJ`D<IH%Q36Z$bD`<o+p<*g^br5?);0IxZCik{K(=c{*3^N0u0S!9Fjh?
zTWpl{IAy+((}pYMgHq~bdO|WQNa#Vok-MFttSTGC^j1B(*Og(1&{6#K?MpEzsZcyn
z^Z{Wsyz@cAjo4Xo?W<ldv6sT=T-56ad<8llTkGaBo=SD)a;^GN&Fr2xYD;^)T)Tzk
zxKUN312Oq>nD=tbIHfv8l0iDJvvc`&d9^o%z2t@PtFP~3&=NhpY%<Il7Hz4L`F)Yq
z-YB~oyiM-7uzWm90x9$Iy6v}Q6Z;7pChOEP!1a}0c}&Jri%i8jCxKT~s*^L_wEeat
z$w^J9Fg0XV|Fw*Q7|~r&Fs-4YpzO@w^(R(mLN!YR?9n2~SYPdKjP6SpXMrMPMf<ZY
zgakf8aAIw-%pxAIQm5ePY>*7|?Y(In&1p0K5H|OK%ez-N+JUf*5rq*{>NK5sucPIk
z50y{KW#(Xj^86$ckn^gc^$dS|KPQyrBM1t=qt080!ek<3O<Z5k#E`;dV-s&)T-bC9
zD=|Hac10tFTh$-Y5T+v$rL(4(GK*UeIvi*3%{Laf&J?|+7A<wZzgrPn!>*9c?__p=
zlVy5IAfr#tuBdlorOGMK8VM-JCI9j{Z8S+QJsB*P_ztXX<|0t(cuqwE?6GVOnKD2(
zvghda3JJ;2#axQ?<v7wzw`hx_w#F=BGY}fJiD-t6wFDPs%ScMiT+*)n$*TZ|Q~NSG
zZsRguSGm?`)KjQYSPo%}4^@>g91FLEsFj6^kb={ByP}7tcS<GRGvg{h<O+Uwb22B$
zT$2-3(##7uyB5H5{zhJLrGrm-9)QB0`{FTP3D%aL010bR{PFhmzJDo?L@5VZatbf^
z?=PbG*Vvqzsj6#7KD}R}teS^^F*2wizy42i9YvTwpw#EOypRR&1fJRN^i}933#1AZ
zTETJ$F|jH7wF%Ix;KT~TcD;&QMW~3`E7tVSe&sH<0!U*;t8Wg0K&$;{Py=5t<;1Tx
zOgIaM#UE%zV~{#$G|75=IOS>AHbB1cj>FUE`T`$9waAZH&k><lOJL3*ujbK<sZ`Qs
zp#47OT6*!pDH6<#zmOQetsnp`s}22&iB#&}Oq6Z#7pfP}JHeQ6snr0dC7(ynP|j*y
zCAN-=scAl^NYxkD#G4HWY{sv4JbxR}8mLMkyn8&&{iq1MDd(RICGFa0q9;bD`hy$W
zOSg6WHP*$R6nA4YS%2hbO#4NjP>yPW!Iyqo-SW^T2s1huE=%5|16N?TON{MNM1+6S
zjf~xz53pI{>=j;zpl2Gs89GI<!yhNmUugRJ({Zt4+h=r6t(9LcbMD(8X_~ag+b3jB
zp#vJVhYL{-AJu-&`NUtFGkay-Z)zNI&i5q4@9?C0=$N!z5VH0VJRRA(3&-xEl!--f
zEOBS}<OH{@gC(TFsc>w=&TvQt92-DLn|Y{Ayl1TZ`{zmlcRXWw>J4t$e!1YphPZRE
z1;-}gmOF-xTX%+)i94rD|0_dM;n-ggWnw>Z=f`1ALE16r(rL=xaJL3y`2YF-EA1p4
qySyunUGASS7E6U66r=?&7a*|9Y5yaSjn@lK)W?8sqC1E)XZ{76j8Z)S

literal 0
HcmV?d00001

diff --git a/tests/r_64to32bit/name b/tests/r_64to32bit/name
new file mode 100644
index 0000000..4c82371
--- /dev/null
+++ b/tests/r_64to32bit/name
@@ -0,0 +1 @@
+convert flex_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit/script b/tests/r_64to32bit/script
new file mode 100644
index 0000000..83a37bd
--- /dev/null
+++ b/tests/r_64to32bit/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -s" >> $OUT
+$RESIZE2FS $TMPFILE -s -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
diff --git a/tests/r_64to32bit_meta/expect.gz b/tests/r_64to32bit_meta/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..178d7bf3e0f6db3deb759ee39bd37567a7945dd0
GIT binary patch
literal 2920
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

literal 0
HcmV?d00001

diff --git a/tests/r_64to32bit_meta/name b/tests/r_64to32bit_meta/name
new file mode 100644
index 0000000..e99ed8b
--- /dev/null
+++ b/tests/r_64to32bit_meta/name
@@ -0,0 +1 @@
+convert meta_bg 64bit fs to 32bit fs
diff --git a/tests/r_64to32bit_meta/script b/tests/r_64to32bit_meta/script
new file mode 100644
index 0000000..e2190ce
--- /dev/null
+++ b/tests/r_64to32bit_meta/script
@@ -0,0 +1,75 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,meta_bg,^resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "resize2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# resize it
+echo "resize2fs test.img -s" >> $OUT
+$RESIZE2FS $TMPFILE -s -f 2>&1 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2>&1 | egrep "(GDT|bitmap|descriptor|^Group|Inode table|features)" >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' -i $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm $EXP
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+

