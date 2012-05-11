From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 2/3] implement uid and gid mount options for ext3
Date: Fri, 11 May 2012 13:10:07 +0200
Message-ID: <1336734608-15157-3-git-send-email-ludwig.nussel@suse.de>
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
 Documentation/filesystems/ext3.txt |    9 ++++++
 fs/ext3/ext3.h                     |    8 +++++
 fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---------
 fs/ext3/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
 4 files changed, 109 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index b100adc..b2407a7 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -124,6 +124,15 @@ resgid=n		The group ID which may use the reserved blocks.
 
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
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index b6515fd..c7c4578 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -245,6 +245,10 @@ struct ext3_mount_options {
 	unsigned long s_mount_opt;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;
+	uid_t s_diskuid;
+	gid_t s_gid;
+	gid_t s_diskgid;
 	unsigned long s_commit_interval;
 #ifdef CONFIG_QUOTA
 	int s_jquota_fmt;
@@ -639,6 +643,10 @@ struct ext3_sb_info {
 	ext3_fsblk_t s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;          /* make all files appear to belong to this uid */
+	uid_t s_diskuid;      /* write this uid to disk (if s_uid != 0) */
+	gid_t s_gid;          /* make all files appear to belong to this gid */
+	gid_t s_diskgid;      /* write this gid to disk (if s_gid != 0) */
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 10d7812..095bd31 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2913,6 +2913,10 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT3_SB(sb)->s_uid)
+		inode->i_uid = EXT3_SB(sb)->s_uid;
+	if (EXT3_SB(sb)->s_gid)
+		inode->i_gid = EXT3_SB(sb)->s_gid;
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -3066,8 +3070,14 @@ static int ext3_do_update_inode(handle_t *handle,
 {
 	struct ext3_inode *raw_inode = ext3_raw_inode(iloc);
 	struct ext3_inode_info *ei = EXT3_I(inode);
+	uid_t uid = inode->i_uid;
+	gid_t gid = inode->i_gid;
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	__le16 uid_low;
+	__le16 gid_low;
+	__le16 uid_high;
+	__le16 gid_high;
 
 again:
 	/* we can't allow multiple procs in here at once, its a bit racey */
@@ -3080,30 +3090,42 @@ again:
 
 	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	if (EXT3_SB(inode->i_sb)->s_uid)
+		uid = EXT3_SB(inode->i_sb)->s_diskuid;
+	if (EXT3_SB(inode->i_sb)->s_gid)
+		gid = EXT3_SB(inode->i_sb)->s_diskgid;
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
-		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
-		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
+		uid_low = cpu_to_le16(low_16_bits(uid));
+		gid_low = cpu_to_le16(low_16_bits(gid));
 /*
  * Fix up interoperability with old kernels. Otherwise, old inodes get
  * re-used with the upper 16 bits of the uid/gid intact
  */
 		if(!ei->i_dtime) {
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
+	if (!EXT3_SB(inode->i_sb)->s_uid ||
+			ext3_test_inode_state(inode, EXT3_STATE_NEW)) {
+		raw_inode->i_uid_high = uid_high;
+		raw_inode->i_uid_low = uid_low;
+	}
+	if (!EXT3_SB(inode->i_sb)->s_gid ||
+			ext3_test_inode_state(inode, EXT3_STATE_NEW)) {
+		raw_inode->i_gid_high = gid_high;
+		raw_inode->i_gid_low = gid_low;
+	}
+
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf0b592..4dcce09 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -625,6 +625,20 @@ static int ext3_show_options(struct seq_file *seq, struct dentry *root)
 	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
+	if (sbi->s_uid) {
+		if (sbi->s_uid != sbi->s_diskuid)
+			seq_printf(seq, ",uid=%u:%u",
+				sbi->s_uid, sbi->s_diskuid);
+		else
+			seq_printf(seq, ",uid=%u", sbi->s_uid);
+	}
+	if (sbi->s_gid) {
+		if (sbi->s_gid != sbi->s_diskgid)
+			seq_printf(seq, ",gid=%u:%u",
+				sbi->s_gid, sbi->s_diskgid);
+		else
+			seq_printf(seq, ",gid=%u", sbi->s_gid);
+	}
 	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
 
@@ -820,7 +834,8 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_resize, Opt_usrquota, Opt_grpquota
+	Opt_resize, Opt_usrquota, Opt_grpquota,
+	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid
 };
 
 static const match_table_t tokens = {
@@ -877,6 +892,10 @@ static const match_table_t tokens = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_resize, "resize"},
+	{Opt_uid, "uid=%u"},
+	{Opt_diskuid, "uid=%u:%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_diskgid, "gid=%u:%u"},
 	{Opt_err, NULL},
 };
 
@@ -1267,6 +1286,34 @@ set_qf_format:
 			ext3_msg(sb, KERN_WARNING,
 				"warning: ignoring deprecated bh option");
 			break;
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = sbi->s_diskuid = option;
+			break;
+		case Opt_diskuid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = option;
+
+			if (match_int(&args[1], &option))
+				return 0;
+			sbi->s_diskuid = option;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_gid = sbi->s_diskgid = option;
+			break;
+		case Opt_diskgid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_gid = option;
+
+			if (match_int(&args[1], &option))
+				return 0;
+			sbi->s_diskgid = option;
+			break;
 		default:
 			ext3_msg(sb, KERN_ERR,
 				"error: unrecognized mount option \"%s\" "
@@ -2590,6 +2637,10 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	old_opts.s_mount_opt = sbi->s_mount_opt;
 	old_opts.s_resuid = sbi->s_resuid;
 	old_opts.s_resgid = sbi->s_resgid;
+	old_opts.s_uid = sbi->s_uid;
+	old_opts.s_diskuid = sbi->s_diskuid;
+	old_opts.s_gid = sbi->s_gid;
+	old_opts.s_diskgid = sbi->s_diskgid;
 	old_opts.s_commit_interval = sbi->s_commit_interval;
 #ifdef CONFIG_QUOTA
 	old_opts.s_jquota_fmt = sbi->s_jquota_fmt;
@@ -2701,6 +2752,10 @@ restore_opts:
 	sbi->s_mount_opt = old_opts.s_mount_opt;
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
+	sbi->s_uid = old_opts.s_uid;
+	sbi->s_diskuid = old_opts.s_diskuid;
+	sbi->s_gid = old_opts.s_gid;
+	sbi->s_diskgid = old_opts.s_diskgid;
 	sbi->s_commit_interval = old_opts.s_commit_interval;
 #ifdef CONFIG_QUOTA
 	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
-- 
1.7.7
