From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2image: ignore checksum errors
Date: Tue, 19 Apr 2016 12:20:30 -0700
Message-ID: <20160419192030.GA16270@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16673 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbcDSTUi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2016 15:20:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since e2image is used to capture broken fs images for debugging,
ignore checksum errors when creating the image.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2image.c                   |    5 +++--
 tests/filter.sed                 |    1 +
 tests/m_corrupt_e2image/expect   |   11 +++++++++++
 tests/m_corrupt_e2image/image.gz |  Bin
 tests/m_corrupt_e2image/name     |    1 +
 tests/m_corrupt_e2image/script   |   26 ++++++++++++++++++++++++++
 6 files changed, 42 insertions(+), 2 deletions(-)
 create mode 100644 tests/m_corrupt_e2image/expect
 create mode 100644 tests/m_corrupt_e2image/image.gz
 create mode 100644 tests/m_corrupt_e2image/name
 create mode 100644 tests/m_corrupt_e2image/script

diff --git a/misc/e2image.c b/misc/e2image.c
index 690ad2c..e0c3188 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1374,7 +1374,8 @@ static void install_image(char *device, char *image_fn, int type)
 {
 	errcode_t retval;
 	ext2_filsys fs;
-	int open_flag = EXT2_FLAG_IMAGE_FILE | EXT2_FLAG_64BITS;
+	int open_flag = EXT2_FLAG_IMAGE_FILE | EXT2_FLAG_64BITS |
+			EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	int fd = 0;
 	io_manager	io_ptr;
 	io_channel	io;
@@ -1451,7 +1452,7 @@ int main (int argc, char ** argv)
 	ext2_filsys fs;
 	char *image_fn, offset_opt[64];
 	struct ext2_qcow2_hdr *header = NULL;
-	int open_flag = EXT2_FLAG_64BITS;
+	int open_flag = EXT2_FLAG_64BITS | EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	int img_type = 0;
 	int flags = 0;
 	int mount_flags = 0;
diff --git a/tests/filter.sed b/tests/filter.sed
index 4a630bf..bec899c 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -4,6 +4,7 @@
 /^mke2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
 /^resize2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
 /^tune2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^e2image [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
 s/\\015//g
 /automatically checked/d
 /^Directory Hash Seed:/d
diff --git a/tests/m_corrupt_e2image/expect b/tests/m_corrupt_e2image/expect
new file mode 100644
index 0000000..eeb967f
--- /dev/null
+++ b/tests/m_corrupt_e2image/expect
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 passes checks, but checksum does not match inode.  Fix? no
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys.bin: ********** WARNING: Filesystem still has errors **********
+
+test_filesys.bin: 12/128 files (0.0% non-contiguous), 19/512 blocks
diff --git a/tests/m_corrupt_e2image/image.gz b/tests/m_corrupt_e2image/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e17e9216deac289cf5c13a33be87b1810640a66d
GIT binary patch
literal 2606
zcmb2|=3wyobSapL`Ry(14B<o>h7a#A{ZQZy>*8x|QnKm@V3(D-?OG_n)#_yJ!7jME
zccFxPCX1kBt6$TLWsAF;`vY|rJyPTFYwCAAxQJ1dedE2Sil)~bqkGT(t$SEM{r$V5
z^84lefA)JjF<e?ThsQ|q%aO%5HClpdtCq=KWj(d^V#U*s0h)apXU_8O?RMHzA<=uf
zx777(Vfx+;+L7*iCMn+(*tTZBLGiB(^L{U9TlbZ}?oIvWJ@U7?-M#B~ud{9gI$`~{
zxf=I(#nr{Fdot<o+4QW>&#ou0{Bmr4M&rwy6_4VU%juSV`?OqhEd#^L$xHU%EzDW<
z?ElgobJqIRTYdVPt0{6lLy>`jA>!Y&Pd7g-O%|Nb4&?o-KKcItPl425PH*=!{G4#|
z%h#*_4)4}`VkCStd1)?t_wjx?k7unP7OYm*66uzk1JrTANZ|X^`FE>t1i#FA^?(1n
zRbT%zGB7lJd+|SCBD&hV^8Z5bYM?TQ-QWIe?>@c^EbH)J9w?O2|IZ#sfxw16qFqPl
zgh4nsNrku1cFj5kly<oNk%a}PGJ+Bf_YI>eZLW0GZ$0}^eC_)0ZyanQqF4V<vCS&B
zI`rz7QQ+1sU*vpSFG$bhS${9;gxW<5zD&#Ke)-<tP0b7S?tZ;rVtn^&{r{a`e+Sq}
z^1u6{U+}+w-~IppLehgRv$V?J`@E}{SDUrJ{Zi2%^ZQ=kf7bt~+4Z`<dfC_C1?ng3
ze~F*^Z<P3W&(ldyQe0)UA4hC;xm~x@e&@gZIhjwt)_+Y2S$q45|Ihd@&i|%IA2HLr
zyU*zF>dL)|HA^P`SDl!%e<C*%K_8AP7!85Z5Eu=C(GVC7fzc2kF9bgP-p6Po@Th@-
HL4g4PrH?{0

literal 0
HcmV?d00001

diff --git a/tests/m_corrupt_e2image/name b/tests/m_corrupt_e2image/name
new file mode 100644
index 0000000..1da3935
--- /dev/null
+++ b/tests/m_corrupt_e2image/name
@@ -0,0 +1 @@
+e2image corrupt fs
diff --git a/tests/m_corrupt_e2image/script b/tests/m_corrupt_e2image/script
new file mode 100644
index 0000000..4c38cf4
--- /dev/null
+++ b/tests/m_corrupt_e2image/script
@@ -0,0 +1,26 @@
+test_description="e2image corrupt fs"
+
+IMAGE=$test_dir/image.gz
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gzip -d < $IMAGE > $TMPFILE
+$E2IMAGE -r $TMPFILE $TMPFILE.bin >> $OUT 2>&1
+$FSCK -fn $TMPFILE.bin >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test_filesys;" $OUT > $OUT.new
+mv $OUT.new $OUT
+
+cmp -s $OUT $EXP
+status=$?
+if [ "$status" = 0 ] ; then
+        echo "$test_name: $test_description: ok"
+        touch $test_name.ok
+else
+        echo "$test_name: $test_description: failed"
+        diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+        rm -f $test_name.tmp
+fi
+
+rm -rf $OUT $TMPFILE $TMPFILE.bin $TMPFILE.test
+unset IMAGE FSCK_OPT OUT EXP
