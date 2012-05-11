From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 3/3] implement uid and gid mount options for ext4
Date: Fri, 11 May 2012 13:10:08 +0200
Message-ID: <1336734608-15157-4-git-send-email-ludwig.nussel@suse.de>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.d>
 <1336734608-15157-1-git-send-email-ludwig.nussel@suse.de>
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
	Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
	Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
	Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
	"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1336734608-15157-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 Documentation/filesystems/ext4.txt |    9 ++++++
 fs/ext4/ext4.h                     |    4 +++
 fs/ext4/inode.c                    |   50 ++++++++++++++++++++++++++----------
 fs/ext4/super.c                    |   49 ++++++++++++++++++++++++++++++++++-
 4 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 1b7f9ac..b388ab5 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -245,6 +245,15 @@ resgid=n		The group ID which may use the reserved blocks.
 
 resuid=n		The user ID which may use the reserved blocks.
 
+uid=n[:m]		Make all files appear to belong to uid n.
+			Useful for e.g. removable media with fstab
+			options 'user,uid=useruid'. The optional second
+			uid m is actually written to the file system.
+
+gid=n[:m]		Make all files appear to belong to gid n.
+			The optional second gid m is actually written to
+			the file system.
+
 sb=n			Use alternate superblock at this location.
 
 quota			These options are ignored by the filesystem. They
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0e01e90..7155b2d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1155,6 +1155,10 @@ struct ext4_sb_info {
 	ext4_fsblk_t s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;          /* make all files appear to belong to this uid */
+	uid_t s_diskuid;      /* write this uid to disk (if s_uid != 0) */
+	gid_t s_gid;          /* make all files appear to belong to this gid */
+	gid_t s_diskgid;      /* write this gid to disk (if s_gid != 0) */
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c77b0bd..86ce928 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3651,6 +3651,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT4_SB(sb)->s_uid)
+		inode->i_uid = EXT4_SB(sb)->s_uid;
+	if (EXT4_SB(sb)->s_gid)
+		inode->i_gid = EXT4_SB(sb)->s_gid;
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
@@ -3868,8 +3872,14 @@ static int ext4_do_update_inode(handle_t *handle,
 {
 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	uid_t uid = inode->i_uid;
+	gid_t gid = inode->i_gid;
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	__le16 uid_low;
+	__le16 gid_low;
+	__le16 uid_high;
+	__le16 gid_high;
 
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
@@ -3878,30 +3888,42 @@ static int ext4_do_update_inode(handle_t *handle,
 
 	ext4_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	if (EXT4_SB(inode->i_sb)->s_uid)
+		uid = EXT4_SB(inode->i_sb)->s_diskuid;
+	if (EXT4_SB(inode->i_sb)->s_gid)
+		gid = EXT4_SB(inode->i_sb)->s_diskgid;
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
-		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
-		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
+		uid_low = cpu_to_le16(low_16_bits(uid));
+		gid_low = cpu_to_le16(low_16_bits(gid));
 /*
  * Fix up interoperability with old kernels. Otherwise, old inodes get
  * re-used with the upper 16 bits of the uid/gid intact
  */
 		if (!ei->i_dtime) {
-			raw_inode->i_uid_high =
-				cpu_to_le16(high_16_bits(inode->i_uid));
-			raw_inode->i_gid_high =
-				cpu_to_le16(high_16_bits(inode->i_gid));
+			uid_high = cpu_to_le16(high_16_bits(uid));
+			gid_high = cpu_to_le16(high_16_bits(gid));
 		} else {
-			raw_inode->i_uid_high = 0;
-			raw_inode->i_gid_high = 0;
+			uid_high = 0;
+			gid_high = 0;
 		}
 	} else {
-		raw_inode->i_uid_low =
-			cpu_to_le16(fs_high2lowuid(inode->i_uid));
-		raw_inode->i_gid_low =
-			cpu_to_le16(fs_high2lowgid(inode->i_gid));
-		raw_inode->i_uid_high = 0;
-		raw_inode->i_gid_high = 0;
+		uid_low = cpu_to_le16(fs_high2lowuid(uid));
+		gid_low = cpu_to_le16(fs_high2lowgid(gid));
+		uid_high = 0;
+		gid_high = 0;
 	}
+	/* don't mangle uid/gid of existing files if override is active */
+	if (!EXT4_SB(inode->i_sb)->s_uid ||
+			ext4_test_inode_state(inode, EXT4_STATE_NEW)) {
+		raw_inode->i_uid_high = uid_high;
+		raw_inode->i_uid_low = uid_low;
+	}
+	if (!EXT4_SB(inode->i_sb)->s_gid ||
+			ext4_test_inode_state(inode, EXT4_STATE_NEW)) {
+		raw_inode->i_gid_high = gid_high;
+		raw_inode->i_gid_low = gid_low;
+	}
+
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e1fb1d5..5f121f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1186,6 +1186,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid,
 };
 
 static const match_table_t tokens = {
@@ -1264,6 +1265,10 @@ static const match_table_t tokens = {
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
 	{Opt_removed, "noreservation"}, /* mount option from ext2/3 */
 	{Opt_removed, "journal=%u"},	/* mount option from ext2/3 */
+	{Opt_uid, "uid=%u"},
+	{Opt_diskuid, "uid=%u:%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_diskgid, "gid=%u:%u"},
 	{Opt_err, NULL},
 };
 
@@ -1498,6 +1503,24 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			return -1;
 		*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
 		return 1;
+	case Opt_uid:
+		sbi->s_uid = sbi->s_diskuid = arg;
+		return 1;
+	case Opt_diskuid:
+		sbi->s_uid = arg;
+		if (match_int(&args[1], &arg))
+			return -1;
+		sbi->s_diskuid = arg;
+		return 1;
+	case Opt_gid:
+		sbi->s_gid = sbi->s_diskgid = arg;
+		return 1;
+	case Opt_diskgid:
+		sbi->s_gid = arg;
+		if (match_int(&args[1], &arg))
+			return -1;
+		sbi->s_diskgid = arg;
+		return 1;
 	}
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
@@ -1713,7 +1736,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	char sep = nodefs ? '\n' : ',';
 
 #define SEQ_OPTS_PUTS(str) seq_printf(seq, "%c" str, sep)
-#define SEQ_OPTS_PRINT(str, arg) seq_printf(seq, "%c" str, sep, arg)
+#define SEQ_OPTS_PRINT(str, args...) seq_printf(seq, "%c" str, sep, ##args)
 
 	if (sbi->s_sb_block != 1)
 		SEQ_OPTS_PRINT("sb=%llu", sbi->s_sb_block);
@@ -1738,6 +1761,18 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	if (nodefs || sbi->s_resgid != EXT4_DEF_RESGID ||
 	    le16_to_cpu(es->s_def_resgid) != EXT4_DEF_RESGID)
 		SEQ_OPTS_PRINT("resgid=%u", sbi->s_resgid);
+	if (sbi->s_uid) {
+		if (sbi->s_uid != sbi->s_diskuid)
+			SEQ_OPTS_PRINT("uid=%u:%u", sbi->s_uid, sbi->s_diskuid);
+		else
+			SEQ_OPTS_PRINT("uid=%u", sbi->s_uid);
+	}
+	if (sbi->s_gid) {
+		if (sbi->s_gid != sbi->s_diskgid)
+			SEQ_OPTS_PRINT("gid=%u:%u", sbi->s_gid, sbi->s_diskgid);
+		else
+			SEQ_OPTS_PRINT("gid=%u", sbi->s_gid);
+	}
 	def_errors = nodefs ? -1 : le16_to_cpu(es->s_errors);
 	if (test_opt(sb, ERRORS_RO) && def_errors != EXT4_ERRORS_RO)
 		SEQ_OPTS_PUTS("errors=remount-ro");
@@ -4215,6 +4250,10 @@ struct ext4_mount_options {
 	unsigned long s_mount_opt2;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;
+	uid_t s_diskuid;
+	gid_t s_gid;
+	gid_t s_diskgid;
 	unsigned long s_commit_interval;
 	u32 s_min_batch_time, s_max_batch_time;
 #ifdef CONFIG_QUOTA
@@ -4245,6 +4284,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	old_opts.s_mount_opt2 = sbi->s_mount_opt2;
 	old_opts.s_resuid = sbi->s_resuid;
 	old_opts.s_resgid = sbi->s_resgid;
+	old_opts.s_uid = sbi->s_uid;
+	old_opts.s_diskuid = sbi->s_diskuid;
+	old_opts.s_gid = sbi->s_gid;
+	old_opts.s_diskgid = sbi->s_diskgid;
 	old_opts.s_commit_interval = sbi->s_commit_interval;
 	old_opts.s_min_batch_time = sbi->s_min_batch_time;
 	old_opts.s_max_batch_time = sbi->s_max_batch_time;
@@ -4402,6 +4445,10 @@ restore_opts:
 	sbi->s_mount_opt2 = old_opts.s_mount_opt2;
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
+	sbi->s_uid = old_opts.s_uid;
+	sbi->s_diskuid = old_opts.s_diskuid;
+	sbi->s_gid = old_opts.s_gid;
+	sbi->s_diskgid = old_opts.s_diskgid;
 	sbi->s_commit_interval = old_opts.s_commit_interval;
 	sbi->s_min_batch_time = old_opts.s_min_batch_time;
 	sbi->s_max_batch_time = old_opts.s_max_batch_time;
-- 
1.7.7
