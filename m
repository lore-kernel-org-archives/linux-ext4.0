From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH resend] ext2/3/4: convert byte order of constant instead of
	variable
Date: Sun, 10 Feb 2008 11:10:15 +0100
Message-ID: <20080210101010.GB6737@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:55331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbYBJKKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Feb 2008 05:10:43 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3438178fga.17
        for <linux-ext4@vger.kernel.org>; Sun, 10 Feb 2008 02:10:41 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

convert byte order of constant instead of variable
which can be done at compile time (vs run time)
ext3/4 bits are #if 0'ed, but someone might copy this code into other places

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/ext2/super.c |    8 +++-----
 fs/ext3/super.c |    2 +-
 fs/ext4/super.c |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 088b011..108f739 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -51,8 +51,7 @@ void ext2_error (struct super_block * sb, const char * function,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		sbi->s_mount_state |= EXT2_ERROR_FS;
-		es->s_state =
-			cpu_to_le16(le16_to_cpu(es->s_state) | EXT2_ERROR_FS);
+		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
 		ext2_sync_super(sb, es);
 	}
 
@@ -1126,10 +1125,9 @@ void ext2_write_super (struct super_block * sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		es = EXT2_SB(sb)->s_es;
 
-		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS) {
+		if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 			ext2_debug ("setting valid to 0\n");
-			es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) &
-						  ~EXT2_VALID_FS);
+			es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
 			es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 			es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 			es->s_mtime = cpu_to_le32(get_seconds());
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 8e02cbf..6c84e6b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1218,7 +1218,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
                    inconsistencies, to force a fsck at reboot.  But for
                    a plain journaled filesystem we can keep it set as
                    valid forever! :) */
-	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT3_VALID_FS);
+	es->s_state &= cpu_to_le16(~EXT3_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 93beb86..5ceeb90 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1387,7 +1387,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 		 * a plain journaled filesystem we can keep it set as
 		 * valid forever! :)
 		 */
-	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT4_VALID_FS);
+	es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
-- 
1.5.3.7
