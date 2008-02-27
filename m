From: akpm@linux-foundation.org
Subject: - ext4-convert-byte-order-of-constant-instead-of-variable.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:10 -0800
Message-ID: <200802272217.m1RMHAQe000791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: marcin.slusarz@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: convert byte order of constant instead of variable
has been removed from the -mm tree.  Its filename was
     ext4-convert-byte-order-of-constant-instead-of-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: convert byte order of constant instead of variable
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/super.c~ext4-convert-byte-order-of-constant-instead-of-variable fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/ext4/super.c
@@ -1399,7 +1399,7 @@ static int ext4_setup_super(struct super
 		 * a plain journaled filesystem we can keep it set as
 		 * valid forever! :)
 		 */
-	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT4_VALID_FS);
+	es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

video-limit-stack-usage-of-ir-kbd-i2cc.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
git-ocfs2.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
