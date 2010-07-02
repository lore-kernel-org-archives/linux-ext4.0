From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 16/16] ext4: Add temporary richacl mount option for ext4.
Date: Sat,  3 Jul 2010 00:13:47 +0530
Message-ID: <1278096227-16784-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This helps in easy testing of the patchset. The mount
option will be later removed in favour of a feature flag.

***Should be folded before merging***

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   54 ++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 966d0cb..d54cd0c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -888,6 +888,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
+#define EXT4_MOUNT_RICHACL		0x80000000 /* Temp richacl enable */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 520ab44..c5861c9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -932,6 +932,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!(sb->s_flags & MS_POSIXACL) && (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	if (sb->s_flags & MS_RICHACL)
+		seq_puts(seq, ",richacl");
+#endif
 	if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
@@ -1170,7 +1174,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_richacl,
 };
 
 static const match_table_t tokens = {
@@ -1241,6 +1245,7 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_richacl, "richacl"},
 	{Opt_err, NULL},
 };
 
@@ -1267,6 +1272,35 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+static void enable_acl(struct super_block *sb)
+{
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL)
+	ext4_msg(sb, KERN_ERR, "acl options not supported");
+	return;
+#endif
+	sb->s_flags |= MS_POSIXACL;
+}
+
+static void disable_acl(struct super_block *sb)
+{
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL)
+	ext4_msg(sb, KERN_ERR, "acl options not supported");
+	return;
+#endif
+	sb->s_flags &= ~MS_POSIXACL;
+	return;
+}
+
+static void enable_richacl(struct super_block *sb)
+{
+#if !defined(CONFIG_EXT4_FS_RICHACL)
+	ext4_msg(sb, KERN_ERR, "richacl options not supported");
+	return;
+#endif
+	sb->s_flags |= MS_RICHACL;
+	return;
+}
+
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
 static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
 	"Contact linux-ext4@vger.kernel.org if you think we should keep it.\n";
@@ -1431,19 +1465,12 @@ static int parse_options(char *options, struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "(no)user_xattr options not supported");
 			break;
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
 		case Opt_acl:
-			sb->s_flags |= MS_POSIXACL;
+			enable_acl(sb);
 			break;
 		case Opt_noacl:
-			sb->s_flags &= ~MS_POSIXACL;
+			disable_acl(sb);
 			break;
-#else
-		case Opt_acl:
-		case Opt_noacl:
-			ext4_msg(sb, KERN_ERR, "(no)acl options not supported");
-			break;
-#endif
 		case Opt_journal_update:
 			/* @@@ FIXME */
 			/* Eventually we will want to be able to create
@@ -1709,6 +1736,9 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+		case Opt_richacl:
+			enable_richacl(sb);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -2539,9 +2569,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#if defined(CONFIG_EXT4_FS_POSIX_ACL)
 	if (def_mount_opts & EXT4_DEFM_ACL)
-		sb->s_flags |= MS_POSIXACL;
+		enable_acl(sb);
 #endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sbi->s_mount_opt, JOURNAL_DATA);
-- 
1.7.2.rc1

