From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/47] libext2fs: file IO routines should handle uninit
 blocks
Date: Fri, 07 Nov 2014 13:51:38 -0800
Message-ID: <20141107215138.883.38987.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45150 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:45 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The file IO routines do not handle uninit blocks at all.  The read
method should check for the uninit flag and return a buffer of zeroes,
and the write routine should convert unwritten extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c         |   24 ++++++++++++++++++++++--
 tests/f_uninit_cat/expect   |  Bin
 tests/f_uninit_cat/image.gz |  Bin
 tests/f_uninit_cat/name     |    1 +
 tests/f_uninit_cat/script   |   37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 2 deletions(-)
 create mode 100644 tests/f_uninit_cat/expect
 create mode 100644 tests/f_uninit_cat/image.gz
 create mode 100644 tests/f_uninit_cat/name
 create mode 100755 tests/f_uninit_cat/script


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1d5032a..d0a05d6 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -123,6 +123,8 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 {
 	errcode_t	retval;
 	ext2_filsys fs;
+	int		ret_flags;
+	blk64_t		dontcare;
 
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 	fs = file->fs;
@@ -131,6 +133,22 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
 	    !(file->flags & EXT2_FILE_BUF_DIRTY))
 		return 0;
 
+	/* Is this an uninit block? */
+	if (file->physblock && file->inode.i_flags & EXT4_EXTENTS_FL) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode, BMAP_BUFFER,
+				      0, file->blockno, &ret_flags, &dontcare);
+		if (retval)
+			return retval;
+		if (ret_flags & BMAP_RET_UNINIT) {
+			retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+					      BMAP_BUFFER, BMAP_SET,
+					      file->blockno, 0,
+					      &file->physblock);
+			if (retval)
+				return retval;
+		}
+	}
+
 	/*
 	 * OK, the physical block hasn't been allocated yet.
 	 * Allocate it.
@@ -185,15 +203,17 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 {
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
+	int		ret_flags;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno, 0,
+				     BMAP_BUFFER, 0, file->blockno, &ret_flags,
 				     &file->physblock);
 		if (retval)
 			return retval;
 		if (!dontfill) {
-			if (file->physblock) {
+			if (file->physblock &&
+			    !(ret_flags & BMAP_RET_UNINIT)) {
 				retval = io_channel_read_blk64(fs->io,
 							       file->physblock,
 							       1, file->buf);
diff --git a/tests/f_uninit_cat/expect b/tests/f_uninit_cat/expect
new file mode 100644
index 0000000000000000000000000000000000000000..0c0a5cf84cc58483ca33e257259607e4ca54ebbe
GIT binary patch
literal 3623
zcmeH{v2KGf5Qa1J6t`4rrKVs4QNvoLQ-&;^E5{tf3b8An9fdx94LB%6-ypu_bol%I
zbN}EyCjwT%#}UOzsurZuHPR~_IxSAVb5#S$U!-I|p!pqIOM}8{(*s%KgmnfdX!S27
zv{Igz7is&6EABXh4H{GeL1?FJuq*F~)@b(w<j!aAEv0I-IddzuN-UE7Ze)klQw1zf
z*9D9tJZEp&6DX~g-rdU9X-6-wP?Ral@**smY_HP#9k_J_k|0ZJJh-+Y5Zr=OQu*WI
zzT5W-@CqqUc6h-Kw#pib1XJyFD+TYSVSnstoOY;MdxX!9x0FDZLgoRM0<1<bgJtNx
zmG9H!`&bOV#$T9q`K)6>#|E(61l{JQn-!~Bkq1RSFzev!`&hG6*uNSB@QW^D#ROsk
a51YU>R!kr!@URIy?86rqj|s#C7RevINPdd|

literal 0
HcmV?d00001

diff --git a/tests/f_uninit_cat/image.gz b/tests/f_uninit_cat/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d2ae66cb35f93dd4022e85f8667365487a7b24ea
GIT binary patch
literal 1553
zcmb2|=3wBo77AfvetUOgws4>X!-w+e5!ulJUCtMqn*6x7X0!`+M-&JY2D}M!S)+8+
zDVJ6IMapY?1&f!@9@sy4qUHCltf(-cFi@sM<Z<;*mRk{C3zur%doRAP`s7{J>E%1$
zf6YFjs>qO9YUaC2aZcCS-(DQb8_$NVE7;Mo<=)q*|3~ghM6S5L{?7@i*S^PYuMLg<
z{yO)bMDN+#HZAQNWmni(e$ISz=k4?0&B2S~=hf!a%c;LRqnoqOeE0R(Td}i${(5!v
zN9*zV=lkXUet4HAR(*B4`0223$*Xyed2c)RXUFctq3v?k4*osNhJB`=>Q$cfF5YY)
zq&Ig<I|BqHJYRiXzO>c;>t5Mgf0ATh%=q$g`@RWJoj2;Pd;ar6z(>h_e;2CHpSyp1
zK~2@ae|Oey(P??=HSMlJ&Y}8++jalfhj#s8_ga)C-tdS0iM_&q#-IEr>K*<uf0Cc@
zA1uVcut9k1xj*G<CR6-R{q_2++YoEG%ju)G)m_7H5^{`CS3sx*%4*qvh1Y5X@893w
ze(dD=mG_O$YD^1}+TT9sT+6vfTb`$HdzF3Z(w=*|H~uB`<f~6#9=s)v-CcQutl0EN
zDLbP6mj5|_XrHg$w}ZTW^>6Fj_h@afy|?67dd1pb`uxmif2pqt{Qt!?S^L#|zi0nX
zFI}X(^4;uQx9mT!qeB0OhF!1kR=hH+G@<KquWi^F`Rv=r-e*s4zxMk7(bMbaFY_=>
zsFGV7C4lT;jqS<~nYIjGr#U#DKDAdsmKtS`hQMeD44Duxd!&D1J4-kNg8%~n1^y`^

literal 0
HcmV?d00001

diff --git a/tests/f_uninit_cat/name b/tests/f_uninit_cat/name
new file mode 100644
index 0000000..f6b5674
--- /dev/null
+++ b/tests/f_uninit_cat/name
@@ -0,0 +1 @@
+cat a file with uninit blocks
diff --git a/tests/f_uninit_cat/script b/tests/f_uninit_cat/script
new file mode 100755
index 0000000..1655bb0
--- /dev/null
+++ b/tests/f_uninit_cat/script
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+if test -x $DEBUGFS_EXE; then
+FSCK_OPT=-fy
+IMAGE=$test_dir/image.gz
+
+gzip -d < $IMAGE > $TMPFILE
+#e2label $TMPFILE test_filesys
+
+# Run fsck to fix things?
+EXP=$test_dir/expect
+OUT=$test_name.log
+rm -rf $test_name.failed $test_name.ok
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
+echo "Exit status is $?" >> $OUT
+
+echo "debugfs cat uninit file" >> $OUT
+echo "ex /a" > $TMPFILE.cmd
+echo "cat /a" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE >> $OUT.new 2>&1
+echo >> $OUT.new
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new $TMPFILE
+
+# Figure out what happened
+if cmp -s $EXP $OUT; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $OUT >> $test_name.failed
+fi
+unset EXP OUT FSCK_OPT IMAGE
+else #if test -a -x $DEBUGFS_EXE; then
+        echo "$test_name: $test_description: skipped"
+fi 

