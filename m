From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 4/5] ext2: Move ext2_write_super() out of ext2_setup_super()
Date: Mon, 12 Apr 2010 22:41:44 +0200
Message-ID: <1271104905-8804-5-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Move ext2_write_super() out of ext2_setup_super() as a preparation for the
next patch that adds a new lock for superblock fields.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 40fc8d5..b01c491 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -606,7 +606,6 @@ static int ext2_setup_super (struct super_block * sb,
 	if (!le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
-	ext2_write_super(sb);
 	if (test_opt (sb, DEBUG))
 		ext2_msg(sb, KERN_INFO, "%s, %s, bs=%lu, fs=%lu, gc=%lu, "
 			"bpg=%lu, ipg=%lu, mo=%04lx]",
@@ -1079,7 +1078,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_msg(sb, KERN_WARNING,
 			"warning: mounting ext3 filesystem as ext2");
-	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+	if (ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags != MS_RDONLY;
+	ext2_write_super(sb);
 	return 0;
 
 cantfind_ext2:
@@ -1249,6 +1250,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		 */
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 		es->s_mtime = cpu_to_le32(get_seconds());
+		ext2_sync_super(sb, es);
 	} else {
 		__le32 ret = EXT2_HAS_RO_COMPAT_FEATURE(sb,
 					       ~EXT2_FEATURE_RO_COMPAT_SUPP);
@@ -1268,8 +1270,8 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		sbi->s_mount_state = le16_to_cpu(es->s_state);
 		if (!ext2_setup_super (sb, es, 0))
 			sb->s_flags &= ~MS_RDONLY;
+		ext2_write_super(sb);
 	}
-	ext2_sync_super(sb, es);
 	unlock_kernel();
 	return 0;
 restore_opts:
-- 
1.6.4.2
