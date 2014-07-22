From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] debugfs: fix printing of inline data during symlink inode
 dump
Date: Tue, 22 Jul 2014 13:47:52 -0700
Message-ID: <20140722204752.GE8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39911 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaGVUr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 16:47:58 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're dumping a fast symlink inode, we print some odd things to
stdout.  To clean this up, first don't print inline data EA, since the
inode dump doesn't display file and directory contents.  Then, teach
the inode dump function how to print out either an inline data fast
symlink or a non-inline data fast symlink.

(This is a follow-up to the earlier patch "debugfs: Only print the
first 60 bytes from i_block on a fast symlink")

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c            |   47 +++++++++++++++++---
 debugfs/xattrs.c             |    9 ++--
 tests/d_inline_dump/expect   |  101 ++++++++++++++++++++++++++++++++++++++++++
 tests/d_inline_dump/image.gz |  Bin
 tests/d_inline_dump/name     |    1 
 tests/d_inline_dump/script   |   43 ++++++++++++++++++
 tests/d_special_files/expect |    2 -
 7 files changed, 194 insertions(+), 9 deletions(-)
 create mode 100644 tests/d_inline_dump/expect
 create mode 100644 tests/d_inline_dump/image.gz
 create mode 100644 tests/d_inline_dump/name
 create mode 100644 tests/d_inline_dump/script

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 51f386b..68ed05a 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -668,7 +668,46 @@ static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num
 
 	retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
 	if (!retval)
-		fprintf(out, "%sSize of inline data: %zu", prefix, size);
+		fprintf(out, "%sSize of inline data: %zu\n", prefix, size);
+}
+
+static void dump_fast_link(FILE *out, ext2_ino_t inode_num,
+			   struct ext2_inode *inode, const char *prefix)
+{
+	errcode_t retval = 0;
+	char *buf;
+	size_t size;
+
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
+		if (retval)
+			goto out;
+
+		retval = ext2fs_get_memzero(size + 1, &buf);
+		if (retval)
+			goto out;
+
+		retval = ext2fs_inline_data_get(current_fs, inode_num,
+						inode, buf, &size);
+		if (retval)
+			goto out;
+		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix,
+			(int)size, buf);
+
+		retval = ext2fs_free_mem(&buf);
+		if (retval)
+			goto out;
+	} else {
+		int sz = EXT2_I_SIZE(inode);
+
+		if (sz > sizeof(inode->i_block))
+			sz = sizeof(inode->i_block);
+		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix, sz,
+			(char *)inode->i_block);
+	}
+out:
+	if (retval)
+		com_err(__func__, retval, "while dumping link destination");
 }
 
 void internal_dump_inode(FILE *out, const char *prefix,
@@ -783,10 +822,8 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	}
 
 	if (LINUX_S_ISLNK(inode->i_mode) &&
-	    ext2fs_inode_data_blocks(current_fs,inode) == 0 &&
-	    !(inode->i_flags & EXT4_INLINE_DATA_FL))
-		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
-			(int) inode->i_size, (char *)inode->i_block);
+	    ext2fs_inode_data_blocks(current_fs, inode) == 0)
+		dump_fast_link(out, inode_num, inode, prefix);
 	else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
 		int major, minor;
 		const char *devnote;
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index f2d7128..1c19b2f 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -45,9 +45,12 @@ static int dump_attr(char *name, char *value, size_t value_len, void *data)
 
 	fprintf(out, "  ");
 	dump_xattr_string(out, name, strlen(name));
-	fprintf(out, " = \"");
-	dump_xattr_string(out, value, value_len);
-	fprintf(out, "\" (%zu)\n", value_len);
+	if (strcmp(name, "system.data") != 0) {
+		fprintf(out, " = \"");
+		dump_xattr_string(out, value, value_len);
+		fprintf(out, "\"");
+	}
+	fprintf(out, " (%zu)\n", value_len);
 
 	return 0;
 }
diff --git a/tests/d_inline_dump/expect b/tests/d_inline_dump/expect
new file mode 100644
index 0000000..ead47f9
--- /dev/null
+++ b/tests/d_inline_dump/expect
@@ -0,0 +1,101 @@
+*** long file
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 13   Type: regular    Mode:  0644   Flags: 0x10000000
+Generation: 3289262644    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 80
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec6b4:c72e3c00 -- Tue Jul 22 20:16:52 2014
+ atime: 0x53cec3c8:4a3fd000 -- Tue Jul 22 20:04:24 2014
+ mtime: 0x53cec3c8:4c281800 -- Tue Jul 22 20:04:24 2014
+crtime: 0x53cec3c8:4a3fd000 -- Tue Jul 22 20:04:24 2014
+Size of extra inode fields: 28
+Extended attributes:
+  system.data (20)
+  user.a = "b" (1)
+Size of inline data: 80
+*** short file
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 18   Type: regular    Mode:  0644   Flags: 0x10000000
+Generation: 3842229473    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 20
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec6b4:cafecc00 -- Tue Jul 22 20:16:52 2014
+ atime: 0x53cec443:bda4d400 -- Tue Jul 22 20:06:27 2014
+ mtime: 0x53cec443:bf8d1c00 -- Tue Jul 22 20:06:27 2014
+crtime: 0x53cec443:bda4d400 -- Tue Jul 22 20:06:27 2014
+Size of extra inode fields: 28
+Extended attributes:
+  system.data (0)
+  user.a = "b" (1)
+Size of inline data: 60
+
+*** long dir
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 16   Type: directory    Mode:  0755   Flags: 0x10000000
+Generation: 3842229469    Version: 0x00000000:00000004
+User:     0   Group:     0   Size: 132
+File ACL: 7    Directory ACL: 0
+Links: 2   Blockcount: 8
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec6e3:27eac000 -- Tue Jul 22 20:17:39 2014
+ atime: 0x53cec410:ed53dc00 -- Tue Jul 22 20:05:36 2014
+ mtime: 0x53cec42b:241a3000 -- Tue Jul 22 20:06:03 2014
+crtime: 0x53cec3fe:c8226000 -- Tue Jul 22 20:05:18 2014
+Size of extra inode fields: 28
+Extended attributes:
+  system.data (72)
+  user.a = "b" (1)
+Size of inline data: 132
+*** short dir
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 20   Type: directory    Mode:  0755   Flags: 0x10000000
+Generation: 3710818931    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 60
+File ACL: 0    Directory ACL: 0
+Links: 2   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec6b4:ca0aa800 -- Tue Jul 22 20:16:52 2014
+ atime: 0x53cec477:9a5ba000 -- Tue Jul 22 20:07:19 2014
+ mtime: 0x53cec477:9a5ba000 -- Tue Jul 22 20:07:19 2014
+crtime: 0x53cec477:9a5ba000 -- Tue Jul 22 20:07:19 2014
+Size of extra inode fields: 28
+Extended attributes:
+  system.data (0)
+  user.a = "b" (1)
+Size of inline data: 60
+
+*** long link
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 12   Type: symlink    Mode:  0777   Flags: 0x10000000
+Generation: 3289262643    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 80
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec47f:724db800 -- Tue Jul 22 20:07:27 2014
+ atime: 0x53cec665:27eac000 -- Tue Jul 22 20:15:33 2014
+ mtime: 0x53cec3b6:82841c00 -- Tue Jul 22 20:04:06 2014
+crtime: 0x53cec3b6:82841c00 -- Tue Jul 22 20:04:06 2014
+Size of extra inode fields: 28
+Extended attributes:
+  system.data (20)
+Fast link dest: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
+*** short link
+debugfs 1.43-WIP (09-Jul-2014)
+Inode: 19   Type: symlink    Mode:  0777   Flags: 0x0
+Generation: 3842229474    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 20
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
+ atime: 0x53cec44d:11fb8400 -- Tue Jul 22 20:06:37 2014
+ mtime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
+crtime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
+Size of extra inode fields: 28
+Fast link dest: "xxxxxxxxxxxxxxxxxxxx"
+*** end test
diff --git a/tests/d_inline_dump/image.gz b/tests/d_inline_dump/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..598a495aa25f7412d8f94150b1b78d5630e17906
GIT binary patch
literal 2988
zcmeH_`%ja16vkg*3v38T5O8wyhK#_lWCgic8WkiA9fN|iz-&ew-4aR%MHnr$ZWO0r
z?HnSPa&=rLw{oXU=!-Jjg{~0BMXs%YP^D08n^IZZ_q*~REX#iE^UKM}dGef`PmV{C
z6|^Q8!<k!bEnU2okl+fvp-4}cXP{;H?vApETR$DYc>atZbD#HdbYVaGS9@&Nm5*y3
zb|M~K5Y<L-l0A7Hr10?1Y<5xhA0$rsak`iXQO@mWGeTs1U1p`^&sRZrgOTehhHR0h
zs8S=^)j>*?*G*{g(N0rooRwCv!u4e)cJkxH`A?AZ{?xpBYM|gDD(niTrhu0lL`|!o
z*W>ZAe%?+q&sHAi9~pEL<!kELj14JTFJ85yqx&>f>SC#IgsZWWY$i+T$kcC+Ej2@L
zm)plBT)JkZ2|v64!Gl922X&bbMj11cLJt<;{4fxd{yo|-6e<|aLkLBbNfk`$Mg3iP
z>>UV#`eEhWOx{$sh0em*0orRVh(32|!-lnO?rYN!M<%a^4ldPo$Ggmi@=|5Pa>D{H
zsW6j9$^k7o0UL8;OTBI-m$}Tozjl^raX5tjgQ6p7L8lt7e$sO$neQcN?%-hvrR0*G
zs0nx7E2*QFrDLLIr(;L^qkN1DZv=N<EtG+m<9<R*W9xLM@SL$g)xgX+TS)rG*Wi)h
z-B-W|J*jgIdV(2xLFbAx8hCAK6stYwztH8w0^#EmAMM>|&4SI0$^TU^sIHj6IFg|1
zzIMQCHQJNuCX8%`ohQD=9|%!(9Sitz%o_h;%<Rdci9kz(w!U<^)3PF?$&K-1W{z=~
zg>^~11MvQcSn_j}XfA$LT0ee-`0l#!+X~Q13IIL@j?eU7J!PPNASSnc9gCBIhE7fu
zc)Ps6+M2a1rD^VMI6Da7v!2ruo*6rg*BVAb2<dYU)SI@Ay95cN*?G5g;gqabk)qq8
z=hM5zz0<VN%-Vb4_UyJyd9afA-Yzx}hsbHLozEq*E%vnXf`sAQB*KaUztGrn*KVY7
zPJoxlcM49%HN-8qP5pF}t0ioZh)rU^h9fz#Q3kGi-c`N=q#`XTu((XFk0g#VMusQF
zf9PT~xp|1oC(gM;%FX`9>tE@8*0Cj-`~y$B^oDF=Tl+8V54Xflp9=L0L@JU*lQzGh
zXcpJ93~-O?_Yyhm|30}Q3!EH(evL@(MRC+Ms&qke4ImIhfVcLj3c=Ccxd7dl)_O_+
zvotfSQkJVsnmP)m){5(7`Q#CHB!5iDUMo>EG&?Nic7fa-G#+x8lo3W5(VICG`(mOT
z#{$pi$IHuA9{j8zc3qK3y_dQTG@Xl|R|2|&0^F9t13l?Z^i9kZjXJMqXIJm5NyFSf
ox{aNdz1Hvjk4Yv1CITh`CITh`CIbII0pBbD!CwZML(pO9AFO32{{R30

literal 0
HcmV?d00001

diff --git a/tests/d_inline_dump/name b/tests/d_inline_dump/name
new file mode 100644
index 0000000..dfc1a9c
--- /dev/null
+++ b/tests/d_inline_dump/name
@@ -0,0 +1 @@
+debugfs dump inline data test
diff --git a/tests/d_inline_dump/script b/tests/d_inline_dump/script
new file mode 100644
index 0000000..96aaf2f
--- /dev/null
+++ b/tests/d_inline_dump/script
@@ -0,0 +1,43 @@
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+	exit 0
+fi
+
+OUT=$test_name.log
+EXP=$test_dir/expect
+VERIFY_FSCK_OPT=-yf
+
+ZIMAGE=$test_name/image.gz
+gzip -d < $ZIMAGE > $TMPFILE
+
+echo "*** long file" > $OUT
+$DEBUGFS -R 'stat /file' $TMPFILE >> $OUT 2>&1
+echo "*** short file" >> $OUT
+$DEBUGFS -R 'stat /shortfile' $TMPFILE >> $OUT 2>&1
+echo >> $OUT
+
+echo "*** long dir" >> $OUT
+$DEBUGFS -R 'stat /dir' $TMPFILE >> $OUT 2>&1
+echo "*** short dir" >> $OUT
+$DEBUGFS -R 'stat /shortdir' $TMPFILE >> $OUT 2>&1
+echo >> $OUT
+
+echo "*** long link" >> $OUT
+$DEBUGFS -R 'stat /link' $TMPFILE >> $OUT 2>&1
+echo "*** short link" >> $OUT
+$DEBUGFS -R 'stat /shortlink' $TMPFILE >> $OUT 2>&1
+
+echo "*** end test" >> $OUT
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
+unset VERIFY_FSCK_OPT NATIVE_FSCK_OPT OUT EXP TEST_DATA VERIFY_DATA
diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
index 2b2dbfa..f729b0f 100644
--- a/tests/d_special_files/expect
+++ b/tests/d_special_files/expect
@@ -11,7 +11,7 @@ Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
-Fast_link_dest: bar
+Fast link dest: "bar"
 Exit status is 0
 debugfs -R ''stat foo2'' -w test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
