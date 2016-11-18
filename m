From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext4: fix in-superblock mount options processing
Date: Thu, 17 Nov 2016 23:26:09 -0500
Message-ID: <20161118042610.13464-2-tytso@mit.edu>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
Cc: kernel@kyup.com, bp@alien8.de, Theodore Ts'o <tytso@mit.edu>,
        stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161118042610.13464-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix a large number of problems with how we handle mount options in the
superblock.  For one, if the string in the superblock is long enough
that it is not null terminated, we could run off the end of the string
and try to interpret superblocks fields as characters.  It's unlikely
this will cause a security problem, but it could result in an invalid
parse.  Also, parse_options is destructive to the string, so in some
cases if there is a comma-separated string, it would be modified in
the superblock.  (Fortunately it only happens on file systems with a
1k block size.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 12f50ef56fe1..3009c03220d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3303,7 +3303,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
-	struct ext4_sb_info *sbi;
+	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logical_sb_block;
@@ -3321,17 +3321,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err = 0;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+	char *s_mount_opts = kzalloc(sizeof(sbi->s_es->s_mount_opts)+1,
+				   GFP_KERNEL);
 
-	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
-		goto out_free_orig;
+	if ((data && !orig_data) || !s_mount_opts || !sbi)
+		goto out_free_base;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
-	if (!sbi->s_blockgroup_lock) {
-		kfree(sbi);
-		goto out_free_orig;
-	}
+	if (!sbi->s_blockgroup_lock)
+		goto out_free_base;
+
 	sb->s_fs_info = sbi;
 	sbi->s_sb = sb;
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
@@ -3477,11 +3477,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
-	if (!parse_options((char *) sbi->s_es->s_mount_opts, sb,
-			   &journal_devnum, &journal_ioprio, 0)) {
-		ext4_msg(sb, KERN_WARNING,
-			 "failed to parse options in superblock: %s",
-			 sbi->s_es->s_mount_opts);
+	if (sbi->s_es->s_mount_opts[0]) {
+		strncpy(s_mount_opts, sbi->s_es->s_mount_opts,
+			sizeof(sbi->s_es->s_mount_opts));
+		if (!parse_options(s_mount_opts, sb, &journal_devnum,
+				   &journal_ioprio, 0)) {
+			ext4_msg(sb, KERN_WARNING,
+				 "failed to parse options in superblock: %s",
+				 s_mount_opts);
+		}
 	}
 	sbi->s_def_mount_opt = sbi->s_mount_opt;
 	if (!parse_options((char *) data, sb, &journal_devnum,
@@ -4162,7 +4166,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs mount"))
 		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-			 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+			 "Opts: %.*s%s%s", descr,
+			 sizeof(sbi->s_es->s_mount_opts),
+			 sbi->s_es->s_mount_opts,
 			 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
@@ -4241,9 +4247,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
+out_free_base:
 	kfree(sbi);
-out_free_orig:
 	kfree(orig_data);
+	kfree(s_mount_opts);
 	return err ? err : ret;
 }
 
-- 
2.11.0.rc0.7.gbe5a750
