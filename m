From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 33/35] debugfs: implement fallocate
Date: Wed, 01 Apr 2015 19:37:41 -0700
Message-ID: <20150402023741.25243.57801.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36163 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbDBCho (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:37:44 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement a fallocate function for debugfs, and add some tests to
demonstrate that it works (more or less).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debug_cmds.ct                |    3 +
 debugfs/debugfs.8.in                 |    7 +
 debugfs/debugfs.c                    |   36 +++++++
 debugfs/debugfs.h                    |    1 
 tests/d_fallocate/expect.gz          |  Bin
 tests/d_fallocate/name               |    1 
 tests/d_fallocate/script             |  175 ++++++++++++++++++++++++++++++++++
 tests/d_fallocate_bigalloc/expect.gz |  Bin
 tests/d_fallocate_bigalloc/name      |    1 
 tests/d_fallocate_bigalloc/script    |  176 ++++++++++++++++++++++++++++++++++
 tests/d_fallocate_blkmap/expect      |   58 +++++++++++
 tests/d_fallocate_blkmap/name        |    1 
 tests/d_fallocate_blkmap/script      |   85 ++++++++++++++++
 13 files changed, 544 insertions(+)
 create mode 100644 tests/d_fallocate/expect.gz
 create mode 100644 tests/d_fallocate/name
 create mode 100644 tests/d_fallocate/script
 create mode 100644 tests/d_fallocate_bigalloc/expect.gz
 create mode 100644 tests/d_fallocate_bigalloc/name
 create mode 100644 tests/d_fallocate_bigalloc/script
 create mode 100644 tests/d_fallocate_blkmap/expect
 create mode 100644 tests/d_fallocate_blkmap/name
 create mode 100644 tests/d_fallocate_blkmap/script


diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index c6f6d6c..34dad9e 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -157,6 +157,9 @@ request do_dirsearch, "Search a directory for a particular filename",
 request do_bmap, "Calculate the logical->physical block mapping for an inode",
 	bmap;
 
+request do_fallocate, "Allocate uninitialized blocks to an inode",
+	fallocate;
+
 request do_punch, "Punch (or truncate) blocks from an inode by deallocating them",
 	punch, truncate;
 
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 9a09cbf..a463c73 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -306,6 +306,13 @@ from the file \fIfilespec\fR.
 Expand the directory
 .IR filespec .
 .TP
+.BI fallocate " filespec start_block [end_block]
+Allocate and map uninitialized blocks into \fIfilespec\fR between
+logical block \fIstart_block\fR and \fIend_block\fR, inclusive.  If
+\fIend_block\fR is not supplied, this function maps until it runs out
+of free disk blocks or the maximum file size is reached.  Existing
+mappings are left alone.
+.TP
 .BI feature " [fs_feature] [-fs_feature] ..."
 Set or clear various filesystem features in the superblock.  After setting
 or clearing any filesystem features that were requested, print the current
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4b88f73..2af6b71 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2196,6 +2196,42 @@ void do_punch(int argc, char *argv[])
 		return;
 	}
 }
+
+void do_fallocate(int argc, char *argv[])
+{
+	ext2_ino_t	ino;
+	blk64_t		start, end;
+	int		err;
+	errcode_t	errcode;
+
+	if (common_args_process(argc, argv, 3, 4, argv[0],
+				"<file> start_blk [end_blk]",
+				CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
+		return;
+	err = strtoblk(argv[0], argv[2], "logical block", &start);
+	if (err)
+		return;
+	if (argc == 4) {
+		err = strtoblk(argv[0], argv[3], "logical block", &end);
+		if (err)
+			return;
+	} else
+		end = ~0;
+
+	errcode = ext2fs_fallocate(current_fs, EXT2_FALLOCATE_INIT_BEYOND_EOF,
+				   ino, NULL, ~0ULL, start, end - start + 1);
+
+	if (errcode) {
+		com_err(argv[0], errcode,
+			"while fallocating inode %u from %llu to %llu\n", ino,
+			(unsigned long long) start, (unsigned long long) end);
+		return;
+	}
+}
 #endif /* READ_ONLY */
 
 void do_symlink(int argc, char *argv[])
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index e163d0a..76bb22c 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -166,6 +166,7 @@ extern void do_imap(int argc, char **argv);
 extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
+extern void do_fallocate(int argc, char **argv);
 extern void do_symlink(int argc, char **argv);
 
 extern void do_dump_mmp(int argc, char **argv);
diff --git a/tests/d_fallocate/expect.gz b/tests/d_fallocate/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..3e6ffc38595b7c451e3de0df3a16f795cf33421b
GIT binary patch
literal 3770
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

literal 0
HcmV?d00001

diff --git a/tests/d_fallocate/name b/tests/d_fallocate/name
new file mode 100644
index 0000000..72d0ed3
--- /dev/null
+++ b/tests/d_fallocate/name
@@ -0,0 +1 @@
+fallocate sparse files and big files
diff --git a/tests/d_fallocate/script b/tests/d_fallocate/script
new file mode 100644
index 0000000..ae8956e
--- /dev/null
+++ b/tests/d_fallocate/script
@@ -0,0 +1,175 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 8
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 2
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 2
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE > /dev/null 2>&1
+$DEBUGFS_EXE -f $TMPFILE.cmd2 $TMPFILE >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/d_fallocate_bigalloc/expect.gz b/tests/d_fallocate_bigalloc/expect.gz
new file mode 100644
index 0000000000000000000000000000000000000000..8640bc29dc71b09810f110d07d84d883b1109b88
GIT binary patch
literal 2673
zcmV-%3Xb(3iwFQXkyum$1KnF)Z``;QeGTSU5GV@l7Fk=o<fTLdMX}vYfB;!^fwTzv
zR7`BeR&CE1GviItUtftl8dDm5kloQs2MB0octq(O>GE7&&g$cOx2ZO_SK@G2ici(;
z`r%=FEk2j)!}G2b)n4om)x(2$-rSTsaZ~<QK5U;J%gtf+p)AGS;qbJ-y1XpE9`wbR
z>b|<TFL#^r;bObHy{u};*NdmSr^~+{PrKcT$8B@oP5tNN`cQ2*tJP1tdbIi)#OLav
z+<)62%17~~I@}4vtc;NN;!_R2-;4F;M(E6%8os?L_p8;9%~?J6cDH?g5{LDt`V?29
z{=9ni>Snts#l&azaaTF8JKz5b-akK;yWk3gyI5aeZ=W|9;&{j52&>hv>-}EHEAi7^
zd3}GpnEh+q^lNv{ef6LEeqC1zy53Z~^7^pdeXCX4JzqDH`A%xE)Ae?<ssF5gs}A3M
zKOOYjm7mL9xw$TdyJ!r@K@ZRI{`v87U7sz~@KEj#|H6%52`Mj~OzuC#clJX5QEaxG
zAL{WB)$Q~4dH?<Ex|7zIUSWTyt2bY(LwzIllecdkyliz-etN$Bycb_;rb~ae_W!O#
z`Bhx5SMQrAQoPw5c2zx;|GeMcR@dtXfAH(wx4k=hUv6&eXX@?4`gXq(*`>(pZ{=nE
z&-Kg14^5-2a97qGNm(fOozBER>X)QCbVuK>AD<q|b6kRMx=CC@-3re9k!#&YwwKW2
z=!jFmDc4^Cr$%t9#gXy2x~=>BBi9b&^bu!)v#!4d&h~H}sy-EGqe&FFU8<SNvgW96
z>m&E!S(-?>{>tOX(<CQo(!dq2zXq-t8SjLq`iW}#TaQz=H(r+}dp??MNR!6!44QN#
zO$?e$B25M~nM9flt}~yeNoMDN>l{xu^W$6aq#}8;o+p{5@gy@1TpCX@^E^p8!;@Tw
zC#gJ7Ql;@E6?oE#JZbQx6M4dOFL{P1S|W<q<L2NgpO4}c@|2UuVFIeZjN_>QPeme6
z1$eSEJgH@PBI$Xe_}R|!L<r-Q7{&=<oD#!0A&k>Z7?*k>o)|oFB2S3plo-beahww4
zI3bSHTpZ`$!;=gRoXo=Ui>%|-Rkmt+wg5gQ7J<KMd&B}qN8F3uYWjm%t446@h-2W`
z^=IIC1gDQU6AEID!zoM{QuT4%;yQvTOc-i<!nh`VHbF!vh-!@oK6*e95za7*ydVlQ
z%;}Au2;!b}g&9Vj&M<vJj!(LF{WWlUPLRMiH~k@qHY2zbLC6t;nW<?feDgK&`5a+~
zUju&g6MiQniORum5g$n$PnelhVMZLoP=3+$2T#QePi7gObmn=|GL0vVnMqR`PZ~3m
zrZk>3W+qKDJmm}Vq`?y>@`Ra5C(KN_>kpnxK9bRl@PwJEX(xFq7UHP@Pd1S!Of;OB
zVK6cbj?XY0PmBqpX(xHI%kadA|E$t@V#I$=%rF@7pLHTnh~qpH$5plvPl)537{?iL
zoQp)B5XU(o!^m8J@YEVC8sSMU!;?WAH;HlFAdZ{F48tIfn}iHQy8fOgqhv4scX+xv
zA4@u932%XE?V62b2~pf6<`)K0+$7`|?D~VH9QHXMWT{*xyD+KQg+X><60-|~pl>3w
zi#90v@jN|w)_>Wi&1{|-;L^-&p0(pm2Eor~&n=oqq_DP|TL>A-Ax#HRy9JxMSkSca
z4#j{Rz`4a{>3Z7ZVza|F?SLE&PWqm1;mNJOVpUO(ji+0jPxhJx26qzRiZL9wIR92P
z`CW4o%$<_PaHhp60?w@hVJ?wo441b!cSlXzcrik3rBObMBM!W<OM<}*jq+k!9D^6*
zauDlR#}rnpPH-}7aR$8P4KG@GoK|Bv+2V5Wk~`0c)i|Ax;i$zG;H7AIVd-%!$8g8z
zr2sFM9XY`981DGISkFtd?%d3+z>V_KJ}-XVxo)MKbHIxk<)wXIq+g}1Upe>M`}-^W
zczID2gRlK<alZGyIELZ+q04$<m^xwD^om7<ViASKqD}xdodC?Prvif8*|-yWO=p2d
zxt_)&;1>qpb&m^XLPBAQ!opG~=$f8WAe5Bq_QffL@3%)N3JG&ZbSy%N5xwmB^s?db
zx~G>M(94E;Y24vU)oM;JhF%=47eg<TsF#6WCR#6pyUC;V%Ar?2t=I3XhK>0ga`VrG
z&oRBS5TSfVVfk!MFblzKv|!c?)|T301@j?~!cyCeV7|y!w=z~RA0FvgmKzmJE+beo
z@h1u9>v$B_@n!_`6}+a66-+7!rV|Cz5KKo4hIk=4S}=xSJR=w_B$!DMENcKc1bZnc
z4hTk}U<e|zO_lVlU^xUU5(O(DSP?B)0l{pvU>0{{X9QEr2u4|=V7{_RVP$jX4I_9C
ziuN1?&q0ZvgWx$R+H(**2Ss}hg6E(a&mr|fg6UMj7=m%MU@#pNZ8`|1gAz>#!E{ix
z=^&U6iZ&gDctLZfgBKEP+H~Zng28kIrQ42Rd2d;TP_(76XxkAi@0Du_<yx94*XE}}
z!>p)Lv%)Q|Bea59Q3Gbh91)?=3T8zOn3cRmbc9wgD{9)T+$~cQuE$koswABEmTd?n
z;ijEfwgE0o`xN=KuPr5qWU7+~gk4Vs#OWJ7EVP1=P-7|kfY7?>50f)qc7BojWu=Z#
zcBZiGd@6UaMn@<(Q&@2B3(X4&olgpFPK7oQ+Dr+3n%^q}q4Qy(PeZq_W;gAy(5InW
z!GMgeJq3YShl0Tz1@-UKK-?7!<|wFq_XRV{2&QGCV7^G+v}uBAEXZgXE0~5k(lS;s
z4FfW|=r<ymhB*of@iT&Hn4_Qs-xn-jNH9(nOhYi8D42#|94#2kk>+T@U_eG!TL%Pl
z_XKkk><E|>4CW}<3(yy=SV%CNDp&!*ibTN*2xg-NgE`VRRxpN<7+vNb5Uepd43onn
zCg)TzhRF#wCG-We%Lv9QQ80#CVM-H>VOChh3dS%itfB>jSz%5T3}%IOv|unDJZd^r
zwvb?{rh{QRIMH-4Ob17s4u<LAXw$(k9c&W?gX!QRLNJxNo)GM1n?_$Sxr|^Y)pQt`
z4wGm)3`~cKHXR10!$g}71JhwtnqUT|!%&Q1()F|$=_T*$2v(g>E*;9%vmD9{WN$i@
z3&F$alMQ>5*_(moFdUn`8CVX(vDuq}<uJKTO4AK2hcU5fx`E{|c}$w_?glfzX;)+Q
zV4D8#WmaQyNhw=h2wPn!-0Cv9$%U}Vg~ClPliOPe+gm7cdkbNE3x(TTCO5VaHnvc>
zv87A<{W<nwsa|Z8*r6iB9V(q2SSol;TrIxcn_{h>BAPuh13R!3wym@^{QAzkPbqR|
z-ilyP%m2milHcyivi<eALyIrFZSza>?GC6vWa2x{GkWd6FK_<LhRpXDtGCtHzld+m
zugu3z@?D*GN%I2KT&vJQ_I?-rr{*KxzI*>heE8>wzrXoKeEji)_~mauzkB=c&CmYp
f9)!C;rDnRY1HYwqzH#!$)N=J-JwLQM>OTMg)z2kH

literal 0
HcmV?d00001

diff --git a/tests/d_fallocate_bigalloc/name b/tests/d_fallocate_bigalloc/name
new file mode 100644
index 0000000..915645c
--- /dev/null
+++ b/tests/d_fallocate_bigalloc/name
@@ -0,0 +1 @@
+fallocate sparse files and big files with bigalloc
diff --git a/tests/d_fallocate_bigalloc/script b/tests/d_fallocate_bigalloc/script
new file mode 100644
index 0000000..6b6bf97
--- /dev/null
+++ b/tests/d_fallocate_bigalloc/script
@@ -0,0 +1,176 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+	cluster_size = 8192
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+make_file() {
+	name="$1"
+	start="$2"
+	flag="$3"
+
+	cat << ENDL
+write /dev/null $name
+sif /$name size 40960
+eo /$name
+set_bmap $flag 10 $((start + 10))
+set_bmap $flag 13 $((start + 13))
+set_bmap $flag 26 $((start + 26))
+set_bmap $flag 29 $((start + 29))
+ec
+sif /$name blocks 32
+setb $((start + 10))
+setb $((start + 13))
+setb $((start + 26))
+setb $((start + 29))
+ENDL
+}
+
+#Files we create:
+# a: fallocate a 40k file
+# b*: falloc sparse file starting at b*
+# c*: falloc spare file ending at c*
+# d: midcluster to midcluster, surrounding sparse
+# e: partial middle cluster alloc
+# f: one big file
+# g*: falloc sparse init file starting at g*
+# h*: falloc sparse init file ending at h*
+# i: midcluster to midcluster, surrounding sparse init
+# j: partial middle cluster alloc
+# k: one big init file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a size 40960
+fallocate /a 0 39
+ENDL
+echo "ex /a" >> $TMPFILE.cmd2
+
+make_file sample $base --uninit >> $TMPFILE.cmd
+echo "ex /sample" >> $TMPFILE.cmd2
+base=10000
+
+for i in 8 9 10 11 12 13 14 15; do
+	make_file b$i $(($base + (40 * ($i - 8)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /b$i $i 39" >> $TMPFILE.cmd
+	echo "ex /b$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file c$i $(($base + 320 + (40 * ($i - 24)))) --uninit >> $TMPFILE.cmd
+	echo "fallocate /c$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /c$i" >> $TMPFILE.cmd2
+done
+
+make_file d $(($base + 640)) --uninit >> $TMPFILE.cmd
+echo "fallocate /d 4 35" >> $TMPFILE.cmd
+echo "ex /d" >> $TMPFILE.cmd2
+
+make_file e $(($base + 680)) --uninit >> $TMPFILE.cmd
+echo "fallocate /e 19 20" >> $TMPFILE.cmd
+echo "ex /e" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null f
+sif /f size 1024
+eo /f
+set_bmap --uninit 0 9000
+ec
+sif /f blocks 16
+setb 9000
+fallocate /f 0 8999
+ENDL
+echo "ex /f" >> $TMPFILE.cmd2
+
+# Now do it again, but with initialized blocks
+base=20000
+for i in 8 9 10 11 12 13 14 15; do
+	make_file g$i $(($base + (40 * ($i - 8)))) >> $TMPFILE.cmd
+	echo "fallocate /g$i $i 39" >> $TMPFILE.cmd
+	echo "ex /g$i" >> $TMPFILE.cmd2
+done
+
+for i in 24 25 26 27 28 29 30 31; do
+	make_file h$i $(($base + 320 + (40 * ($i - 24)))) >> $TMPFILE.cmd
+	echo "fallocate /h$i 0 $i" >> $TMPFILE.cmd
+	echo "ex /h$i" >> $TMPFILE.cmd2
+done
+
+make_file i $(($base + 640)) >> $TMPFILE.cmd
+echo "fallocate /i 4 35" >> $TMPFILE.cmd
+echo "ex /i" >> $TMPFILE.cmd2
+
+make_file j $(($base + 680)) >> $TMPFILE.cmd
+echo "fallocate /j 19 20" >> $TMPFILE.cmd
+echo "ex /j" >> $TMPFILE.cmd2
+
+cat >> $TMPFILE.cmd << ENDL
+write /dev/null k
+sif /k size 1024
+eo /k
+set_bmap 0 19000
+ec
+sif /k blocks 16
+setb 19000
+fallocate /k 0 8999
+sif /k size 9216000
+ENDL
+echo "ex /k" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE > /dev/null 2>&1
+$DEBUGFS_EXE -f $TMPFILE.cmd2 $TMPFILE >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/d_fallocate_blkmap/expect b/tests/d_fallocate_blkmap/expect
new file mode 100644
index 0000000..f7ae606
--- /dev/null
+++ b/tests/d_fallocate_blkmap/expect
@@ -0,0 +1,58 @@
+Creating filesystem with 65536 1k blocks and 4096 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/4096 files (0.0% non-contiguous), 2340/65536 blocks
+Exit status is 0
+debugfs write files
+debugfs: stat /a
+Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 40960
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 82
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-1):1312-1313, (2-11):8000-8009, (IND):8010, (12-39):8011-8038
+TOTAL: 41
+
+debugfs: stat /b
+Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 10240000
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 20082
+Fragment:  Address: 0    Number: 0    Size: 0
+Size of extra inode fields: 28
+BLOCKS:
+(0-11):10000-10011, (IND):10012, (12-267):10013-10268, (DIND):10269, (IND):10270, (268-523):10271-10526, (IND):10527, (524-779):10528-10783, (IND):10784, (780-1035):10785-11040, (IND):11041, (1036-1291):11042-11297, (IND):11298, (1292-1547):11299-11554, (IND):11555, (1548-1803):11556-11811, (IND):11812, (1804-2059):11813-12068, (IND):12069, (2060-2315):12070-12325, (IND):12326, (2316-2571):12327-12582, (IND):12583, (2572-2827):12584-12839, (IND):12840, (2828-3083):12841-13096, (IND):13097, (3084-3339):13098-13353, (IND):13354, (3340-3595):13355-13610, (IND):13611, (3596-3851):13612-13867, (IND):13868, (3852-4107):13869-14124, (IND):14125, (4108-4363):14126-14381, (IND):14382, (4364-4619):14383-14638, (IND):14639, (4620-4875):14640-14895, (IND):14896, (4876-5131):14897-15152, (IND):15153, 
 (5132-5387):15154-15409, (IND):15410, (5388-5643):15411-15666, (IND):15667, (5644-5899):15668-15923, (IND):15924, (5900-6155):15925-16180, (IND):16181, (6156-6411):16182-16437, (IND):16438,!
  (6412-6667):16439-16694, (IND):16695, (6668-6923):16696-16951, (IND):16952, (6924-7179):16953-17208, (IND):17209, (7180-7435):17210-17465, (IND):17466, (7436-7691):17467-17722, (IND):17723, (7692-7947):17724-17979, (IND):17980, (7948-8203):17981-18236, (IND):18237, (8204-8459):18238-18493, (IND):18494, (8460-8715):18495-18750, (IND):18751, (8716-8971):18752-19007, (IND):19008, (8972-9227):19009-19264, (IND):19265, (9228-9483):19266-19521, (IND):19522, (9484-9739):19523-19778, (IND):19779, (9740-9995):19780-20035, (IND):20036, (9996-9999):20037-20040
+TOTAL: 10041
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (6841, counted=6840).
+Fix? yes
+
+Free blocks count wrong for group #1 (1551, counted=1550).
+Fix? yes
+
+Free blocks count wrong (53116, counted=53114).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/4096 files (7.7% non-contiguous), 12422/65536 blocks
+Exit status is 1
diff --git a/tests/d_fallocate_blkmap/name b/tests/d_fallocate_blkmap/name
new file mode 100644
index 0000000..ba2b61d
--- /dev/null
+++ b/tests/d_fallocate_blkmap/name
@@ -0,0 +1 @@
+fallocate sparse files and big files on a blockmap fs
diff --git a/tests/d_fallocate_blkmap/script b/tests/d_fallocate_blkmap/script
new file mode 100644
index 0000000..9c48cbc
--- /dev/null
+++ b/tests/d_fallocate_blkmap/script
@@ -0,0 +1,85 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+cat > $TMPFILE.conf << ENDL
+[fs_types]
+ext4 = {
+        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal,^extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^64bit
+        blocksize = 1024
+        inode_size = 256
+        inode_ratio = 16384
+}
+ENDL
+MKE2FS_CONFIG=$TMPFILE.conf $MKE2FS -F -o Linux -b 1024 -O ^bigalloc -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+rm -rf $TMPFILE.conf
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write files" >> $OUT
+
+#Files we create:
+# a: fallocate a 40k file
+# k: one big file
+base=5000
+cat > $TMPFILE.cmd << ENDL
+write /dev/null a
+sif /a bmap[2] 8000
+sif /a size 40960
+sif /a i_blocks 2
+setb 8000
+fallocate /a 0 39
+
+write /dev/null b
+sif /b size 10240000
+sif /b bmap[0] 10000
+sif /b i_blocks 2
+setb 10000
+fallocate /b 0 9999
+ENDL
+echo "stat /a" >> $TMPFILE.cmd2
+echo "stat /b" >> $TMPFILE.cmd2
+
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE > /dev/null 2>&1
+$DEBUGFS_EXE -f $TMPFILE.cmd2 $TMPFILE >> $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed -e '/^.*time:.*$/d' < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE.cmd $TMPFILE.cmd2
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

