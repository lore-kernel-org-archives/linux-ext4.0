From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] libext2fs: correctly subtract xattr blocks on bigalloc filesystems
Date: Sat, 20 May 2017 23:23:03 -0700
Message-ID: <20170521062303.32296-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34703 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbdEUGYS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 May 2017 02:24:18 -0400
Received: by mail-pf0-f194.google.com with SMTP id w69so13893196pfk.1
        for <linux-ext4@vger.kernel.org>; Sat, 20 May 2017 23:24:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

ext2fs_inode_data_blocks2() calculates an inode's data block count by
subtracting the external xattr block, if any, from the total blocks.
But on bigalloc filesystems, the xattr "block" is actually a whole
cluster, so ext2fs_inode_data_blocks2() would return a too-large value.

It seems this could have caused several different problems, but the one
I encountered was that xfstest generic/399 failed in the "bigalloc"
config because e2fsck incorrectly considered a symlink on the filesystem
to be corrupted at the end of the test.  This happened because e2fsck
incorrectly calculated a nonzero data block count for a "fast" symlink
with an external xattr block and therefore treated it as a "slow"
symlink, which failed validation.

Fix this by updating ext2fs_inode_data_blocks2() to subtract the cluster
size rather than the block size.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/ext2fs/blknum.c                          |   2 +-
 tests/f_bigalloc_symlink_with_xattr/expect.1 |   7 +++++++
 tests/f_bigalloc_symlink_with_xattr/image.gz | Bin 0 -> 663 bytes
 tests/f_bigalloc_symlink_with_xattr/name     |   1 +
 tests/f_bigalloc_symlink_with_xattr/script   |   2 ++
 5 files changed, 11 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_bigalloc_symlink_with_xattr/expect.1
 create mode 100644 tests/f_bigalloc_symlink_with_xattr/image.gz
 create mode 100644 tests/f_bigalloc_symlink_with_xattr/name
 create mode 100644 tests/f_bigalloc_symlink_with_xattr/script

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index ac808490..aa0e9118 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -71,7 +71,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
 	return (inode->i_blocks |
 		(ext2fs_has_feature_huge_file(fs->super) ?
 		 (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
-		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
+		(inode->i_file_acl ? EXT2_CLUSTER_SIZE(fs->super) >> 9 : 0);
 }
 
 /*
diff --git a/tests/f_bigalloc_symlink_with_xattr/expect.1 b/tests/f_bigalloc_symlink_with_xattr/expect.1
new file mode 100644
index 00000000..0e6c199f
--- /dev/null
+++ b/tests/f_bigalloc_symlink_with_xattr/expect.1
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 112/128 blocks
+Exit status is 0
diff --git a/tests/f_bigalloc_symlink_with_xattr/image.gz b/tests/f_bigalloc_symlink_with_xattr/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..cbd125dc25a59e6795363e4228c5c5a24e49eeb2
GIT binary patch
literal 663
zcmb2|=3oE;CgvoGjR_(>O@RswM|d61u%&K3pz<I`jg5`9<4$npQ4fK%lpp`?f7mKB
zD~Iqbn<wa1?0j|$!y{*hw>KRQpDqo#XVdZZrqT3=(Xr31@3AsJ44-P=E@a^wbLINi
z`(}08^*)m)9&Bu6S7H3j&dZ=IW+=8GL1aN~b;H5eeTx~Y<kOUA<lerQq%$w~c3IAu
zZ(`XRO;L_#7i@cctIU4x=bU@>KfIF<y0Y7T37Pt2gNnMUX3+98T$AnOzGTkTZc7nn
zEBXER4ukI7yGI?CbAdesCoY(X$#0Q(5x@u+0W)TuYkBOqqxR~AyH7qDp6rpHbVYi1
z-PFgM&)n0T^u~I<$6V7cmFMZlV@eaGUTt2Pxx!d{*}`S-rnl|-eD=xS?~~`mUzh$@
z@7j01Z>Q<(@~rbFR|?ISEj(80?QCnT@v_c&(r5E)|E8?IJwIp3-<$R)zuq(~=kXS+
zpZ{iNO7Z{riBFdPj<5LgaQdcLvH5?Gp7_0KVe~ogZX_2j@Yz(~_36&l&#9H~cAl*B
z<U7CbY4G`dKQ2Y~+x-4y%&&WU+Lv|TZoNKweSY1mkLmM#vYEd5A1jmmeDOZIM~~IL
zzWU#PUD%cX&eg&H?LX~U7q5QukJg36C;yih&##I3=lGBDC;Jom3H1&L#zNMU_DIfw
zF*it03GP;Lo%Fv--g3+7H}%U?bbnvFyjsOF=jpfW@9JMJ6@ORz?B8;Ez6(xqRS%zv
l$5;JWSR9`6W9skuRgoQNE`u2gr4w?!8Fp-~GX^F`1^_GgBJThI

literal 0
HcmV?d00001

diff --git a/tests/f_bigalloc_symlink_with_xattr/name b/tests/f_bigalloc_symlink_with_xattr/name
new file mode 100644
index 00000000..f612796f
--- /dev/null
+++ b/tests/f_bigalloc_symlink_with_xattr/name
@@ -0,0 +1 @@
+fast symlink with external xattr block on bigalloc filesystem
diff --git a/tests/f_bigalloc_symlink_with_xattr/script b/tests/f_bigalloc_symlink_with_xattr/script
new file mode 100644
index 00000000..8ab2b9c6
--- /dev/null
+++ b/tests/f_bigalloc_symlink_with_xattr/script
@@ -0,0 +1,2 @@
+ONE_PASS_ONLY="true"
+. $cmd_dir/run_e2fsck
-- 
2.13.0
