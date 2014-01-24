From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] e2fsprogs: Disallow tune2fs enabling sparse_super with ext4
 meta_bg enabled
Date: Fri, 24 Jan 2014 02:55:57 +0000
Message-ID: <28989C0C9F1C0A428470D967B5FCED3727189D@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:39548 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaAXDBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2014 22:01:31 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id s0O31UOO018057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 12:01:30 +0900 (JST)
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When meta_bg feature is enabled, group descriptor block is allocated
every 128 block group (or every 64 block group if 64bit feature is enabled).

In such situation, files in block group more than #128 will be removed
if sparse_super feature is enabled with tune2fs and
afterwards necessary e2fsck running.

Because tune2fs does not reallocate group descriptor blocks
but just set sparse_super feature.
If ext4 has sparse_super, ext2fs_descriptor_block_loc2() called
by e2fsck thinks the block group (e.g. #128) that it has group descriptor block
at the head offset. But that offset is used as backup super block before.
So e2fsck fixes ext4 based on invalid group descriptor blocks and this
cause data lost.

The patch avoids this problem simply by disallow tune2fs enabling
sparse_super if meta_bg is enabled.

Steps to reproduce:

1. Create ext4 which has meta_bg, ^sparse_super and 129+ block groups.
# mke2fs -t ext4 -O meta_bg,^resize_inode,^sparse_super DEV 17G
# mount DEV /MP

2. Create direcotry and files which use block group #128's metadata.
# echo $((8192*128+1)) > /sys/fs/ext4/DEV/inode_goal
# mkdir /MP/DIR
# for i in $(seq 1 100); do dd if=/dev/urandom of=/MP/DIR/file$i bs=1024 count=10; done

3. Enable sparse_super with tune2fs then execute e2fsck.
   Data in block group #128 will be lost!!
# umount DEV
# tune2fs -O sparse_super DEV
# e2fsck/e2fsck -yf DEV


Signed-off-by: Akira Fujita <a-fujita@rs.jp.ne.cocm>
---
misc/tune2fs.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0eddf6d..51a4478 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -919,6 +919,19 @@ static int update_feature_set(ext2_filsys fs, char *features)
 				return 1;
 		}
 	}
+
+	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
+		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
+		if (sb->s_feature_incompat &
+			EXT2_FEATURE_INCOMPAT_META_BG) {
+			fputs(_("Setting filesystem feature 'sparse_super' "
+				"not supported\nfor filesystems with "
+				"the meta_bg feature enabled.\n"),
+				stderr);
+			return 1;
+		}
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
 		int error;
 
@@ -2568,10 +2581,18 @@ retry_open:
 	}
 	if (s_flag == 1) {
 		if (sb->s_feature_ro_compat &
-		    EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)
+		    EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) {
 			fputs(_("\nThe filesystem already has sparse "
 				"superblocks.\n"), stderr);
-		else {
+		} else if (sb->s_feature_incompat &
+			EXT2_FEATURE_INCOMPAT_META_BG) {
+			fputs(_("\nSetting the sparse super flag not "
+				"supported\nfor filesystems with "
+				"the meta_bg feature enabled.\n"),
+				stderr);
+			rc = 1;
+			goto closefs;
+		} else {
 			sb->s_feature_ro_compat |=
 				EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
 			sb->s_state &= ~EXT2_VALID_FS;
@@ -2581,7 +2602,7 @@ retry_open:
 		}
 	}
 	if (s_flag == 0) {
-		fputs(_("\nClearing the sparse superflag not supported.\n"),
+		fputs(_("\nClearing the sparse super flag not supported.\n"),
 		      stderr);
 		rc = 1;
 		goto closefs;

