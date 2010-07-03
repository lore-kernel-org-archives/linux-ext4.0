From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 16/16] ext4: Add temporary richacl mount option for ext4.
Date: Sat, 03 Jul 2010 16:23:09 +0530
Message-ID: <87aaq825wq.fsf@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278096227-16784-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57140 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab0GCKx0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jul 2010 06:53:26 -0400
In-Reply-To: <1278096227-16784-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  3 Jul 2010 00:13:47 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> This helps in easy testing of the patchset. The mount
> option will be later removed in favour of a feature flag.
> 
> ***Should be folded before merging***
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The feature flag patch is below. I am not sure whether it should be an
incompat feature or a compat feature. The patch mark it as an incompat
feature.

commit 5e5c5b80787bb9d9dec685321d221a8fe252a04e
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Jul 2 00:07:25 2010 +0530

    ext4: Add Ext4 incompat richacl feature flag
    
    This feature flag can be used to enable richacl on
    the file system. Once enabled the "acl" mount option
    will enable richacl instead of posix acl. The patch also
    removes the richacl mount option.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d54cd0c..7009a05 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -888,7 +888,6 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
-#define EXT4_MOUNT_RICHACL		0x80000000 /* Temp richacl enable */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
@@ -1281,6 +1280,7 @@ EXT4_INODE_BIT_FNS(state, state_flags)
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
+#define EXT4_FEATURE_INCOMPAT_RICHACL		0x2000
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1288,7 +1288,8 @@ EXT4_INODE_BIT_FNS(state, state_flags)
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_RICHACL)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c5861c9..6317f00 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -926,16 +926,14 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
-	if ((sb->s_flags & MS_POSIXACL) && !(def_mount_opts & EXT4_DEFM_ACL))
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
+	if ((sb->s_flags & (MS_POSIXACL|MS_RICHACL)) &&
+	    !(def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",acl");
-	if (!(sb->s_flags & MS_POSIXACL) && (def_mount_opts & EXT4_DEFM_ACL))
+	if (!(sb->s_flags & (MS_POSIXACL|MS_RICHACL)) &&
+	    (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
 #endif
-#ifdef CONFIG_EXT4_FS_RICHACL
-	if (sb->s_flags & MS_RICHACL)
-		seq_puts(seq, ",richacl");
-#endif
 	if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
@@ -1174,7 +1172,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard, Opt_richacl,
+	Opt_discard, Opt_nodiscard,
 };
 
 static const match_table_t tokens = {
@@ -1245,7 +1243,6 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
-	{Opt_richacl, "richacl"},
 	{Opt_err, NULL},
 };
 
@@ -1274,30 +1271,24 @@ static ext4_fsblk_t get_sb_block(void **data)
 
 static void enable_acl(struct super_block *sb)
 {
-#if !defined(CONFIG_EXT4_FS_POSIX_ACL)
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL) && !defined(CONFIG_EXT4_FS_RICHACL)
 	ext4_msg(sb, KERN_ERR, "acl options not supported");
 	return;
 #endif
-	sb->s_flags |= MS_POSIXACL;
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RICHACL))
+		sb->s_flags |= MS_RICHACL;
+	else
+		sb->s_flags |= MS_POSIXACL;
+	return;
 }
 
 static void disable_acl(struct super_block *sb)
 {
-#if !defined(CONFIG_EXT4_FS_POSIX_ACL)
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL) && !defined(CONFIG_EXT4_FS_RICHACL)
 	ext4_msg(sb, KERN_ERR, "acl options not supported");
 	return;
 #endif
-	sb->s_flags &= ~MS_POSIXACL;
-	return;
-}
-
-static void enable_richacl(struct super_block *sb)
-{
-#if !defined(CONFIG_EXT4_FS_RICHACL)
-	ext4_msg(sb, KERN_ERR, "richacl options not supported");
-	return;
-#endif
-	sb->s_flags |= MS_RICHACL;
+	sb->s_flags &= ~(MS_POSIXACL | MS_RICHACL);
 	return;
 }
 
@@ -1736,9 +1727,6 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
-		case Opt_richacl:
-			enable_richacl(sb);
-			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -2569,7 +2557,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
 #endif
-#if defined(CONFIG_EXT4_FS_POSIX_ACL)
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
 	if (def_mount_opts & EXT4_DEFM_ACL)
 		enable_acl(sb);
 #endif
