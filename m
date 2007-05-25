From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Sat, 26 May 2007 03:06:19 +0530
Message-ID: <1180128981.3916.13.camel@garfield>
References: <1179777153.3910.13.camel@garfield>
	 <20070525143957.GA12669@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-t1uFmX4mLZcdAsgXJy22"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43997 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbXEYVdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2007 17:33:04 -0400
In-Reply-To: <20070525143957.GA12669@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-t1uFmX4mLZcdAsgXJy22
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Ted,

On Fri, 2007-05-25 at 10:39 -0400, Theodore Tso wrote:
> Hi Kalpak,
> 
> On Tue, May 22, 2007 at 01:22:32AM +0530, Kalpak Shah wrote:
> > It will also protect against running e2fsck on a mounted filesystem
> > by adding similar logic to ext2fs_open().
> 
> Your patch didn't add this logic to ext2fs_open(); it just reserved
> the space in the superblock.

Yeah the earlier patch for just reserving the fields. 

> 
> I don't mind reserving the space so we don't have to worry about
> conflicting superblock uses, but I'm still on the fence about actually
> adding this functionality (a) into e2fsprogs, and (b) into the ext4
> kernel code.  I guess it depends on how complicated/icky the
> implementation code is, I guess.

I am attaching the kernel and e2fsrogs patches so that you can suggest
any short-comings in the implementation. These patches are still a WIP.

>   The question as before is whether
> the complexity is worth it, given that someone who is actually going
> to be subject to accidentally mounting an ext3/4 filesystem on
> multiple systems needs to be using an HA system anyway.  So basically
> this is just to protect against (a) a bug/failure in the HA subsystem,
> and (b) the idiotic user that failed to realized he/she needed to set
> up an HA subsystem in the first place.  Granted, the universe is going
> to create idiots at a faster rate that we can deal with it, but that's
> why I'm still not 100% convinced the complexity is worth it.

Given the amount of damage that multiple mounts can cause to the
filesystem, it would be desirable to make doubly sure. Also the MMP
feature is quite uncomplicated and absolutely tunable.

Thanks for your views.

- Kalpak.
> 
> To be fair, if I was on a L3 support team having to deal with these
> idiots, I'd probably feel differently.  :-)
> 
> 							- Ted
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-t1uFmX4mLZcdAsgXJy22
Content-Disposition: attachment; filename=mmp.patch
Content-Type: text/x-patch; name=mmp.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.19/fs/ext4/super.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/super.c
+++ linux-2.6.19/fs/ext4/super.c
@@ -35,6 +35,8 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/kthread.h>
+#include <linux/utsname.h>
 
 #include <asm/uaccess.h>
 
@@ -481,6 +483,9 @@ static void ext4_put_super (struct super
 		invalidate_bdev(sbi->journal_bdev, 0);
 		ext4_blkdev_remove(sbi);
 	}
+	if (sbi->s_mmp_tsk)
+		kthread_stop(sbi->s_mmp_tsk);
+
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	return;
@@ -1441,6 +1446,223 @@ static ext4_fsblk_t descriptor_loc(struc
 	return (has_super + ext4_group_first_block_no(sb, bg));
 }
 
+static inline
+int write_mmp_block(struct super_block *sb, struct buffer_head *bh,
+		    const char *bdev_name)
+{
+	int retval;
+
+	mark_buffer_dirty(bh);
+	retval = sync_dirty_buffer(bh);
+	if (retval)
+		ext4_error(sb, "write_mmp_block",
+			   "Error writing to MMP block.");
+
+	return retval;
+}
+
+static inline
+int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
+		   ext4_fsblk_t mmp_block)
+{
+	if (*bh)
+		clear_buffer_uptodate(*bh);
+
+	*bh = sb_bread(sb, mmp_block);
+	if (!*bh) {
+		ext4_warning(sb, "read_mmp_block",
+			     "Error while reading MMP block %llu", mmp_block);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * kmmpd will update the MMP sequence every s_mmp_interval seconds
+ */
+static int kmmpd(void *data)
+{
+	struct super_block *sb = (struct super_block *) data;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct buffer_head *bh = NULL;
+	struct mmp_struct *mmp;
+	ext4_fsblk_t mmp_block;
+	u32 seq = 0;
+	unsigned long failed_writes = 0;
+	int retval;
+	int mmp_interval = cpu_to_le16(es->s_mmp_interval);
+
+	mmp_block = le32_to_cpu(es->s_mmp_block);
+	retval = read_mmp_block(sb, &bh, mmp_block);
+	if (retval)
+		goto failed;
+
+	mmp = (struct mmp_struct *)(bh->b_data);
+	mmp->mmp_magic = cpu_to_le32(EXT4_MMP_MAGIC);
+	mmp->mmp_time = cpu_to_le64(get_seconds());
+	mmp->mmp_interval = mmp_interval;
+	bdevname(bh->b_bdev, mmp->mmp_bdevname);
+
+	down_read(&uts_sem);
+	memcpy(mmp->mmp_nodename, init_uts_ns.name.nodename, 64);
+	up_read(&uts_sem);
+
+	while (!kthread_should_stop()) {
+		if (++seq >= EXT4_MMP_FSCK_ON)
+			seq = 1;
+
+		mmp->mmp_seq = cpu_to_le32(seq);
+		mmp->mmp_time = cpu_to_le64(get_seconds());
+
+		retval = write_mmp_block(sb, bh, mmp->mmp_bdevname);
+		/*
+		 * Don't spew too many error messages. Print one every
+		 * (s_mmp_interval * 60) seconds.
+		 */
+		if (retval && (failed_writes % 60) == 0) {
+				ext4_warning(sb, "kmmpd",
+					     "Error writing to MMP block");
+				failed_writes++;
+		}
+
+		if (!(le32_to_cpu(es->s_feature_incompat) &
+		    EXT4_FEATURE_INCOMPAT_MMP)) {
+			ext4_warning(sb, "kmmpd", "kmmpd being stopped "
+				     "since MMP feature has been "
+				     "disabled.");
+			goto failed;
+		}
+
+		if (sb->s_flags & MS_RDONLY) {
+			ext4_warning(sb, "kmmpd", "kmmpd being stopped since "
+				     "filesystem has been remounted as readonly.");
+			goto failed;
+		}
+
+		schedule_timeout_interruptible(mmp_interval * HZ);
+	}
+
+	/* Unmount seems to be clean */
+	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_CLEAN);
+	mmp->mmp_time = cpu_to_le64(get_seconds());
+
+	retval = write_mmp_block(sb, bh, mmp->mmp_bdevname);
+
+failed:
+	brelse(bh);
+	return 0;
+}
+
+void dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
+		  const char *function, const char *msg)
+{
+	ext4_warning(sb, function, msg);
+	ext4_warning(sb, function, "Dumping MMP information:\n"
+		     "Time last updated: %llu\n"
+		     "Last node which updated MMP: %s\n"
+		     "Last block device which updated MMP: %s\n",
+		     le64_to_cpu(mmp->mmp_time), mmp->mmp_nodename,
+		     mmp->mmp_bdevname);
+}
+
+/*
+ * Protect the filesystem from being mounted more than once.
+ */
+static int ext4_multi_mount_protect(struct super_block *sb,
+				    ext4_fsblk_t mmp_block)
+{
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct buffer_head *bh = NULL;
+	struct mmp_struct *mmp = NULL;
+	u32 seq;
+	unsigned int wait_interval = 2 * le32_to_cpu(es->s_mmp_interval);
+	int retval;
+
+	if (mmp_block < le32_to_cpu(es->s_first_data_block) ||
+	    mmp_block > ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+		ext4_warning(sb, "ext4_multi_mount_protect",
+			     "Invalid MMP block in superblock");
+		goto failed;
+	}
+
+	retval = read_mmp_block(sb, &bh, mmp_block);
+	if (retval)
+		goto failed;
+
+	mmp = (struct mmp_struct *)(bh->b_data);
+	if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC) {
+		ext4_error(sb, "ext4_multi_mount_protect",
+			   "Invalid magic number in MMP block");
+		goto failed;
+	}
+
+	if (le32_to_cpu(es->s_mmp_interval) == 0)
+		es->s_mmp_interval = cpu_to_le32(EXT4_MMP_DEF_INTERVAL);
+
+	seq = le32_to_cpu(mmp->mmp_seq);
+	if (seq == EXT4_MMP_CLEAN)
+		goto skip;
+
+	if (seq == EXT4_MMP_FSCK_ON) {
+		dump_mmp_msg(sb, mmp, "ext4_multi_mount_protect",
+			     "fsck is running on the filesystem");
+		goto failed;
+	}
+
+	/* wait for MMP interval and check seq again */
+	schedule_timeout_uninterruptible(HZ * wait_interval);
+
+	retval = read_mmp_block(sb, &bh, mmp_block);
+	if (retval)
+		goto failed;
+	mmp = (struct mmp_struct *)(bh->b_data);
+	if (seq != le32_to_cpu(mmp->mmp_seq)) {
+		dump_mmp_msg(sb, mmp, "ext4_multi_mount_protect",
+			     "Device is already active on another node.");
+		goto failed;
+	}
+
+skip:
+	/* write a new random sequence number */
+	get_random_bytes(&seq, sizeof(u32));
+	mmp->mmp_seq = cpu_to_le32(seq);
+	retval = write_mmp_block(sb, bh, sb->s_id);
+	if (retval)
+		goto failed;
+
+	/* wait for MMP interval and check seq again */
+	schedule_timeout_uninterruptible(HZ * wait_interval);
+
+	retval = read_mmp_block(sb, &bh, mmp_block);
+	if (retval)
+		goto failed;
+	mmp = (struct mmp_struct *)(bh->b_data);
+	if (seq != le32_to_cpu(mmp->mmp_seq)) {
+		dump_mmp_msg(sb, mmp, "ext4_multi_mount_protect",
+			     "Device is already active on another node.");
+		goto failed;
+	}
+
+	/* Start a kernel thread to update the MMP block periodically */
+	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%02x:%02x",
+					     MAJOR(sb->s_dev), MINOR(sb->s_dev));
+	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
+		EXT4_SB(sb)->s_mmp_tsk = 0;
+		ext4_warning(sb, "ext4_multi_mount_protect",
+		       "Unable to create kmmpd thread for %s.", sb->s_id);
+		goto failed;
+	}
+
+	brelse(bh);
+	return 0;
+
+failed:
+	brelse(bh);
+
+	return 1;
+}
+
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 {
@@ -1770,6 +1992,10 @@ static int ext4_fill_super (struct super
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
 				    EXT4_FEATURE_INCOMPAT_RECOVER));
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_MMP))
+		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
+			goto failed_mount2;
+
 	/*
 	 * The first inode we look at is the journal inode.  Don't try
 	 * root first: it may be modified in the journal!
Index: linux-2.6.19/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext4_fs_sb.h
+++ linux-2.6.19/include/linux/ext4_fs_sb.h
@@ -90,6 +90,8 @@ struct ext4_sb_info {
 	unsigned long s_ext_extents;
 #endif
 	unsigned int  s_want_extra_isize;	       /* New inodes should reserve # bytes */
+
+	struct task_struct * s_mmp_tsk;		/* Kernel thread for multiple mount protection */
 };
 
 #endif	/* _LINUX_EXT4_FS_SB */
Index: linux-2.6.19/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext4_fs.h
+++ linux-2.6.19/include/linux/ext4_fs.h
@@ -578,10 +578,11 @@ struct ext4_super_block {
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
 	__le16  s_min_extra_isize;	/* All inodes have at least # bytes */
 	__le16  s_want_extra_isize;	/* New inodes should reserve # bytes */
-	__le32	s_flags;		/* Miscellaneous flags */
+/*160*/ __le32	s_flags;		/* Miscellaneous flags */
 	__le16	s_raid_stride;	  	/* RAID stride */
-	__le16	s_pad;		  	/* Padding */
-	__le32	s_reserved[166];	/* Padding to the end of the block */
+	__le16	s_mmp_interval;		/* Wait for # seconds in MMP checking */
+	__le64	s_mmp_block;		/* Block for multi-mount protection */
+	__u32	s_reserved[164];	/* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -680,13 +681,15 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT| \
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
@@ -850,6 +853,30 @@ void ext4_get_group_no_and_offset(struct
 			unsigned long *blockgrpp, ext4_grpblk_t *offsetp);
 
 /*
+ * This structure will be used for multiple mount protection. It will be
+ * written into the block number saved in the s_mmp_block field in the
+ * superblock.
+ */
+#define EXT4_MMP_MAGIC	   0x004D4D50 /* ASCII of MMP */
+#define EXT4_MMP_CLEAN	   0xFF4D4D50 /* Value of mmp_seq for clean unmount */
+#define EXT4_MMP_FSCK_ON   0xE24D4D50 /* Value of mmp_seq when being fscked */
+struct mmp_struct {
+	__le32	mmp_magic;
+	__le32	mmp_seq;
+	__le64	mmp_time;
+	char	mmp_nodename[64];
+	char	mmp_bdevname[BDEVNAME_SIZE];
+	__le16	mmp_interval;
+	__le16	mmp_pad1;
+	__le32	mmp_pad2;
+};
+
+/*
+ * Interval in number of seconds to update the MMP sequence number.
+ */
+#define EXT4_MMP_DEF_INTERVAL   5
+
+/*
  * Function prototypes
  */
 

--=-t1uFmX4mLZcdAsgXJy22
Content-Disposition: attachment; filename=e2fsprogs-mmp.patch
Content-Type: text/x-patch; name=e2fsprogs-mmp.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: e2fsprogs-1.39/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/feature.c
+++ e2fsprogs-1.39/lib/e2p/feature.c
@@ -67,6 +67,8 @@ static struct feature feature_list[] = {
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
+			"mmp" },
 	{	0, 0, 0 },
 };
 
Index: e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
@@ -570,8 +570,9 @@ struct ext2_super_block {
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
 	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_pad;			/* Padding */
-	__u32   s_reserved[166];	/* Padding to the end of the block */
+	__u16   s_mmp_interval;		/* Wait for # seconds in MMP checking */
+	__u64   s_mmp_block;		/* Block for multi-mount protection */
+	__u32   s_reserved[164];	/* Padding to the end of the block */
 };
 
 /*
@@ -633,10 +634,12 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -712,4 +715,28 @@ struct ext2_dir_entry_2 {
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
 
+/*
+ * This structure will be used for multiple mount protection. It will be
+ * written into the block number saved in the s_mmp_block field in the
+ * superblock.
+ */
+#define	EXT2_MMP_MAGIC    0x004D4D50 /* ASCII for MMP */
+#define	EXT2_MMP_CLEAN    0xFF4D4D50 /* Value of mmp_seq for clean unmount */
+#define	EXT2_MMP_FSCK_ON  0xE24D4D50 /* Value of mmp_seq when being fscked */
+struct mmp_struct {
+	__u32	mmp_magic;
+	__u32	mmp_seq;
+	__u64	mmp_time;
+	char	mmp_nodename[64];
+	char	mmp_bdevname[32];
+	__u16	mmp_interval;
+	__u16	mmp_pad1;
+	__u32	mmp_pad2;
+};
+
+/*
+ * Interval in number of seconds to update the MMP sequence number.
+ */
+#define EXT2_MMP_DEF_INTERVAL	5
+
 #endif	/* _LINUX_EXT2_FS_H */
Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h
@@ -190,6 +190,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_IMAGE_FILE		0x2000
 #define EXT2_FLAG_EXCLUSIVE		0x4000
 #define EXT2_FLAG_SOFTSUPP_FEATURES	0x8000
+#define EXT2_FLAG_SKIP_MMP		0x18000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -462,7 +463,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT3_FEATURE_INCOMPAT_EXTENTS)
+					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
@@ -991,6 +993,7 @@ extern void ext2fs_swap_inode(ext2_filsy
 extern void ext2fs_swap_extent_header(struct ext3_extent_header *eh);
 extern void ext2fs_swap_extent_index(struct ext3_extent_idx *ix);
 extern void ext2fs_swap_extent(struct ext3_extent *ex);
+extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
Index: e2fsprogs-1.39/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/tune2fs.c
+++ e2fsprogs-1.39/misc/tune2fs.c
@@ -60,7 +60,7 @@ char * device_name;
 char * new_label, *new_last_mounted, *new_UUID;
 char * io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
-static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag, p_flag;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -71,6 +71,7 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static unsigned long mmp_interval;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -86,7 +87,8 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options]\n"
 		  "\t[-l] [-s sparse_flag] [-m reserved_blocks_percent]\n"
-		  "\t[-o [^]mount_options[,...]] [-r reserved_blocks_count]\n"
+		  "\t[-o [^]mount_options[,...]] [-p]"
+		  "[-r reserved_blocks_count]\n"
 		  "\t[-u user] [-C mount_count] [-L volume_label] "
 		  "[-M last_mounted_dir]\n"
 		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]"
@@ -97,7 +99,8 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
-	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
+	EXT2_FEATURE_INCOMPAT_FILETYPE |	/* Incompat */
+		EXT4_FEATURE_INCOMPAT_MMP,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |	/* R/O compat */
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
@@ -286,8 +289,10 @@ static void update_feature_set(ext2_fils
 {
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir, uninit, old_uninit;
+	int mmp, old_mmp;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
+	int error;
 
 	old_compat = sb->s_feature_compat;
 	old_ro_compat = sb->s_feature_ro_compat;
@@ -303,6 +308,8 @@ static void update_feature_set(ext2_fils
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
 	old_uninit = sb->s_feature_ro_compat &
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+	old_mmp = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_MMP;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -319,6 +326,8 @@ static void update_feature_set(ext2_fils
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
 	uninit = sb->s_feature_ro_compat &
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+	mmp = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_MMP;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -359,6 +368,124 @@ static void update_feature_set(ext2_fils
 		if (uuid_is_null((unsigned char *) sb->s_hash_seed))
 			uuid_generate((unsigned char *) sb->s_hash_seed);
 	}
+	if (!old_mmp && mmp) {
+		blk_t mmp_block;
+		char *buf;
+		struct mmp_struct *mmp_s;
+
+		if ((mount_flags & EXT2_MF_MOUNTED) ||
+		    (mount_flags & EXT2_MF_READONLY)) {
+			fputs(_("The multiple mount protection feature cannot\n"
+				"be set if the filesystem is mounted or \n"
+				"read-only.\n"), stderr);
+			exit(1);
+		}
+
+		error = ext2fs_read_bitmaps(fs);
+		if (error) {
+			fputs(_("Error while reading bitmaps\n"), stderr);
+			exit(1);
+		}
+
+		error = ext2fs_new_block(fs, 0, 0, &mmp_block);
+		if (error) {
+			fputs(_("Error allocating block required for setting "
+				"MMP feature.\n"), stderr);
+			exit(1);
+		}
+		ext2fs_block_alloc_stats(fs, mmp_block, +1);
+		sb->s_mmp_block = mmp_block;
+
+		error = ext2fs_get_mem(fs->blocksize, &buf);
+		if (error) {
+			fputs(_("Error allocating memory.\n"), stderr);
+			exit(1);
+		}
+		error = io_channel_read_blk(fs->io, mmp_block, 1, buf);
+		if (error) {
+			fputs(_("Error reading MMP block.\n"), stderr);
+			exit(1);
+		}
+
+		mmp_s = (struct mmp_struct *) buf;
+		mmp_s->mmp_magic = EXT2_MMP_MAGIC;
+		mmp_s->mmp_seq = EXT2_MMP_CLEAN;
+		mmp_s->mmp_time = 0;
+		mmp_s->mmp_nodename[0] = '\0';
+		mmp_s->mmp_bdevname[0] = '\0';
+		mmp_s->mmp_interval = EXT2_MMP_DEF_INTERVAL;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+			ext2fs_swap_mmp(mmp_s);
+#endif
+		error = io_channel_write_blk(fs->io, mmp_block, 1, buf);
+		if (error) {
+			fputs(_("Error writing to MMP block.\n"), stderr);
+			exit(1);
+		}
+		if (buf)
+			ext2fs_free_mem(&buf);
+
+		sb->s_mmp_interval = EXT2_MMP_DEF_INTERVAL;
+	}
+
+	if (old_mmp && !mmp) {
+		blk_t mmp_block;
+		struct mmp_struct *mmp_s;
+		char *buf;
+
+		if ((mount_flags & EXT2_MF_MOUNTED) ||
+		    (mount_flags & EXT2_MF_READONLY)) {
+			fputs(_("The multiple mount protection feature cannot\n"
+				"be disabled if the filesystem is mounted or\n"
+				"read-only.\n"), stderr);
+			exit(1);
+		}
+
+		error = ext2fs_read_bitmaps(fs);
+		if (error) {
+			fputs(_("Error while reading bitmaps\n"), stderr);
+			exit(1);
+		}
+
+		mmp_block = sb->s_mmp_block;
+		if ((mmp_block < sb->s_first_data_block) ||
+		    (mmp_block >= sb->s_blocks_count)) {
+			fputs(_("MMP block number beyond filesystem range.\n"),
+			      stderr);
+			exit(1);
+		}
+
+		error = ext2fs_get_mem(fs->blocksize, &buf);
+		if (error) {
+			fputs(_("Error allocating memory.\n"), stderr);
+			exit(1);
+		}
+		error = io_channel_read_blk(fs->io, mmp_block, 1, buf);
+		if (error) {
+			fputs(_("Error reading MMP block.\n"), stderr);
+			exit(1);
+		}
+
+		mmp_s = (struct mmp_struct *) buf;
+#ifdef EXT2FS_ENABLE_SWAPFS
+		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+			ext2fs_swap_mmp(mmp_s);
+#endif
+		if (mmp_s->mmp_magic != EXT2_MMP_MAGIC) {
+			fputs(_("Magic number in MMP block does not match. MMP "
+				"block number in superblock may be corrupted.\n"),
+			      stderr);
+			exit(1);
+		}
+
+		ext2fs_unmark_block_bitmap(fs->block_map, mmp_block);
+		ext2fs_mark_bb_dirty(fs);
+
+		sb->s_mmp_block = 0;
+		sb->s_mmp_interval = 0;
+	}
 
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
@@ -515,7 +642,7 @@ static void parse_tune2fs_options(int ar
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:p:r:s:u:C:J:L:M:O:T:U:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -666,6 +793,20 @@ static void parse_tune2fs_options(int ar
 				features_cmd = optarg;
 				open_flag = EXT2_FLAG_RW;
 				break;
+			case 'p':
+				mmp_interval = strtol (optarg, &tmp, 0);
+				if (*tmp && mmp_interval != 0 &&
+				    mmp_interval < EXT2_MMP_DEF_INTERVAL) {
+					com_err (program_name, 0,
+						 _("multi-mount interval of %s"
+						   " seconds may negatively"
+						   "impact filesystem performance"),
+						 optarg);
+					usage();
+				}
+				p_flag = 1;
+				open_flag = EXT2_FLAG_RW;
+				break;
 			case 'r':
 				reserved_blocks = strtoul (optarg, &tmp, 0);
 				if (*tmp) {
@@ -780,6 +921,9 @@ int main (int argc, char ** argv)
 #else
 	io_ptr = unix_io_manager;
 #endif
+	if (open_flag == EXT2_FLAG_RW && f_flag)
+		open_flag |= EXT2_FLAG_SKIP_MMP;
+
 	retval = ext2fs_open2(device_name, io_options, open_flag, 
 			      0, 0, io_ptr, &fs);
         if (retval) {
@@ -840,6 +984,12 @@ int main (int argc, char ** argv)
 		printf (_("Setting reserved blocks percentage to %g%% (%u blocks)\n"),
 			reserved_ratio, sb->s_r_blocks_count);
 	}
+	if (p_flag) {
+		sb->s_mmp_interval = mmp_interval;
+		ext2fs_mark_super_dirty(fs);
+		printf (_("Setting multiple mount protection interval to %lu "
+			  "seconds\n"), mmp_interval);
+	}
 	if (r_flag) {
 		if (reserved_blocks >= sb->s_blocks_count/2) {
 			com_err (program_name, 0,
Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c
+++ e2fsprogs-1.39/e2fsck/pass1.c
@@ -466,6 +466,39 @@ extern void e2fsck_setup_tdb_icount(e2fs
 		*ret = 0;
 }
 
+/*
+ * Marks a block as in use, setting the dup_map if it's been set
+ * already.  Called by process_block and process_bad_block.
+ *
+ * WARNING: Assumes checks have already been done to make sure block
+ * is valid.  This is true in both process_block and process_bad_block.
+ */
+static void mark_block_used(e2fsck_t ctx, blk_t block)
+{
+	struct	  problem_context pctx;
+
+	clear_problem_context(&pctx);
+
+	if (ext2fs_fast_test_block_bitmap(ctx->block_found_map, block)) {
+		if (!ctx->block_dup_map) {
+			pctx.errcode = ext2fs_allocate_block_bitmap(ctx->fs,
+			      _("multiply claimed block map"),
+			      &ctx->block_dup_map);
+			if (pctx.errcode) {
+				pctx.num = 3;
+				fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR,
+					    &pctx);
+				/* Should never get here */
+				ctx->flags |= E2F_FLAG_ABORT;
+				return;
+			}
+		}
+		ext2fs_fast_mark_block_bitmap(ctx->block_dup_map, block);
+	} else {
+		ext2fs_fast_mark_block_bitmap(ctx->block_found_map, block);
+	}
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -1021,6 +1054,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->block_ea_map = 0;
 	}
 
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP)
+		mark_block_used(ctx, fs->super->s_mmp_block);
+
 	if (ctx->flags & E2F_FLAG_RESIZE_INODE) {
 		ext2fs_block_bitmap save_bmap;
 
@@ -1227,39 +1263,6 @@ static void alloc_imagic_map(e2fsck_t ct
 }
 
 /*
- * Marks a block as in use, setting the dup_map if it's been set
- * already.  Called by process_block and process_bad_block.
- *
- * WARNING: Assumes checks have already been done to make sure block
- * is valid.  This is true in both process_block and process_bad_block.
- */
-static _INLINE_ void mark_block_used(e2fsck_t ctx, blk_t block)
-{
-	struct		problem_context pctx;
-	
-	clear_problem_context(&pctx);
-	
-	if (ext2fs_fast_test_block_bitmap(ctx->block_found_map, block)) {
-		if (!ctx->block_dup_map) {
-			pctx.errcode = ext2fs_allocate_block_bitmap(ctx->fs,
-			      _("multiply claimed block map"),
-			      &ctx->block_dup_map);
-			if (pctx.errcode) {
-				pctx.num = 3;
-				fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, 
-					    &pctx);
-				/* Should never get here */
-				ctx->flags |= E2F_FLAG_ABORT;
-				return;
-			}
-		}
-		ext2fs_fast_mark_block_bitmap(ctx->block_dup_map, block);
-	} else {
-		ext2fs_fast_mark_block_bitmap(ctx->block_found_map, block);
-	}
-}
-
-/*
  * Adjust the extended attribute block's reference counts at the end
  * of pass 1, either by subtracting out references for EA blocks that
  * are still referenced in ctx->refcount, or by adding references for
Index: e2fsprogs-1.39/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/unix.c
+++ e2fsprogs-1.39/e2fsck/unix.c
@@ -1055,6 +1055,18 @@ restart:
 			       "to do a read-only\n"
 			       "check of the device.\n"));
 #endif
+		else if (retval == ERANGE) {
+			if (fix_problem(ctx, PR_0_MMP_INVALID_BLK, &pctx)) {
+				fs->super->s_mmp_block = 0;
+				ext2fs_mark_super_dirty(fs);
+			}
+		}
+		else if (retval == EXT2_ET_MMP_FAILED)
+			printf(_("Dump MMP info\n"));
+		else if (retval == EXT2_ET_MMP_FSCK_ON)
+			printf(_("If you are sure that e2fsck is not running "
+				 "then use \"tune2fs -O ^mmp device\" "
+				 "followed by \"tune2fs -O mmp device\""));
 		else
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
 		fatal_error(ctx, 0);
@@ -1331,6 +1343,43 @@ no_journal:
 	    !(ctx->options & E2F_OPT_READONLY))
 		ext2fs_set_gdt_csum(ctx->fs);
 
+	if ((flags & EXT2_FLAG_RW) &&
+	    (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP)) {
+		blk_t mmp_blk = fs->super->s_mmp_block;
+		char *buf;
+		struct mmp_struct *mmp_s;
+		int error;
+
+		error = ext2fs_get_mem(fs->blocksize, &buf);
+		if (error) {
+			printf(_("Error allocating memory.\n"));
+			goto mmp_error2;
+		}
+
+		error = io_channel_read_blk(fs->io, mmp_blk, 1, buf);
+		if (error) {
+			printf(_("Error reading MMP block.\n"));
+			goto mmp_error2;
+		}
+
+		mmp_s = (struct mmp_struct *) buf;
+		if (mmp_s->mmp_magic != EXT2_MMP_MAGIC) {
+			printf(_("Invalid magic number in MMP block.\n"));
+			goto mmp_error2;
+		}
+
+		mmp_s->mmp_seq = EXT2_MMP_CLEAN;
+		error = io_channel_write_blk(fs->io, mmp_blk, 1, buf);
+		if (error) {
+			printf(_("Error writing to MMP block.\n"));
+			goto mmp_error2;
+		}
+
+mmp_error2:
+		if (buf)
+			ext2fs_free_mem(&buf);
+	}
+
 	e2fsck_write_bitmaps(ctx);
 
 	ext2fs_close(fs);
Index: e2fsprogs-1.39/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.c
+++ e2fsprogs-1.39/e2fsck/problem.c
@@ -376,6 +376,11 @@ static struct e2fsck_problem problem_tab
 	  N_("last @g @b @B uninitialized.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
+	/* Resize_inode not enabled, but resize inode is non-zero */
+	{ PR_0_MMP_INVALID_BLK,
+	  N_("@S has invalid MMP block.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
Index: e2fsprogs-1.39/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.h
+++ e2fsprogs-1.39/e2fsck/problem.h
@@ -212,6 +212,9 @@ struct problem_context {
 /* Last group block bitmap is uninitialized. */
 #define PR_0_BB_UNINIT_LAST			0x000039
 
+/* The MMP block in the superblock is invalid. */
+#define PR_0_MMP_INVALID_BLK			0x00003A
+
 /*
  * Pass 1 errors
  */
Index: e2fsprogs-1.39/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.39/lib/ext2fs/swapfs.c
@@ -70,6 +70,8 @@ void ext2fs_swap_super(struct ext2_super
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_mmp_interval = ext2fs_swab16(sb->s_mmp_interval);
+	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
 	for (i=0; i < 17; i++)
@@ -274,4 +276,12 @@ void ext2fs_swap_inode(ext2_filsys fs, s
 				sizeof(struct ext2_inode));
 }
 
+void ext2fs_swap_mmp(struct mmp_struct *mmp)
+{
+	mmp->mmp_magic = ext2fs_swab32(mmp->mmp_magic);
+	mmp->mmp_seq = ext2fs_swab32(mmp->mmp_seq);
+	mmp->mmp_time = ext2fs_swab64(mmp->mmp_time);
+	mmp->mmp_interval = ext2fs_swab16(mmp->mmp_interval);
+}
+
 #endif
Index: e2fsprogs-1.39/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/openfs.c
+++ e2fsprogs-1.39/lib/ext2fs/openfs.c
@@ -22,6 +22,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
 
 #include "ext2_fs.h"
 
@@ -68,6 +71,107 @@ errcode_t ext2fs_open(const char *name, 
 }
 
 /*
+ * Make sure that the fs is not mounted or under fsck while opening the fs.
+ */
+int ext2fs_multiple_mount_protect(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	char *buf;
+	struct mmp_struct *mmp_s;
+	unsigned long seq;
+	int retval = 0;
+
+	if ((mmp_blk < fs->super->s_first_data_block) ||
+	    (mmp_blk >= fs->super->s_blocks_count)) {
+		return ERANGE;
+	}
+
+	retval = ext2fs_get_mem(fs->blocksize * 5, &buf);
+	if (retval)
+		goto mmp_error;
+
+	retval = io_channel_read_blk(fs->io, mmp_blk, 1, buf);
+	if (retval)
+		goto mmp_error;
+
+	mmp_s = (struct mmp_struct *) buf;
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	if (mmp_s->mmp_magic != EXT2_MMP_MAGIC) {
+		retval = EXT2_ET_MMP_MAGIC_INVALID;
+		goto mmp_error;
+	}
+
+	if (fs->super->s_mmp_interval == 0)
+		fs->super->s_mmp_interval = EXT2_MMP_DEF_INTERVAL;
+
+	seq = mmp_s->mmp_seq;
+	if (seq == EXT2_MMP_CLEAN)
+		goto clean_seq;
+
+	if (seq == EXT2_MMP_FSCK_ON) {
+		retval = EXT2_ET_MMP_FSCK_ON;
+		goto mmp_error;
+	}
+
+	sleep(2 * fs->super->s_mmp_interval);
+
+	/*
+	 * Make sure that we read direct from disk by reading only
+	 * sizeof(stuct mmp_struct) bytes.
+	 */
+	retval = io_channel_read_blk(fs->io, mmp_blk,
+				     -sizeof(struct mmp_struct), buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+clean_seq:
+	mmp_s->mmp_seq = seq = rand();
+	retval = io_channel_write_blk(fs->io, mmp_blk, 1, buf);
+	if (retval)
+		goto mmp_error;
+
+	io_channel_flush(fs->io);
+	sleep(2 * fs->super->s_mmp_interval);
+	retval = io_channel_read_blk(fs->io, mmp_blk,
+				     -sizeof(struct mmp_struct), buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+	mmp_s->mmp_seq = EXT2_MMP_FSCK_ON;
+	retval = io_channel_write_blk(fs->io, mmp_blk, 1, buf);
+	if (retval)
+		goto mmp_error;
+
+	if (buf)
+		ext2fs_free_mem(&buf);
+
+	return 0;
+
+mmp_error:
+	if (buf)
+		ext2fs_free_mem(&buf);
+
+	return retval;
+
+
+	return 0;
+}
+
+/*
  *  Note: if superblock is non-zero, block-size must also be non-zero.
  * 	Superblock and block_size can be zero to use the default size.
  *
@@ -77,6 +181,7 @@ errcode_t ext2fs_open(const char *name, 
  * 	EXT2_FLAG_FORCE - Open the filesystem even if some of the
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
+ *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
@@ -317,6 +422,13 @@ errcode_t ext2fs_open2(const char *name,
 
 	*ret_fs = fs;
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (flags & EXT2_FLAG_RW) && !(flags & EXT2_FLAG_SKIP_MMP)) {
+		retval = ext2fs_multiple_mount_protect(fs);
+		if (retval)
+			goto cleanup;
+	}
+
 	return 0;
 cleanup:
 	ext2fs_free(fs);
Index: e2fsprogs-1.39/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_err.et.in
+++ e2fsprogs-1.39/lib/ext2fs/ext2_err.et.in
@@ -338,5 +338,14 @@ ec	EXT2_ET_EXTENT_LEAF_BAD,
 ec	EXT2_ET_EXTENT_NO_SPACE,
 	"No free space in extent map"
 
+ec	EXT2_ET_MMP_MAGIC_INVALID,
+	"MMP: Invalid magic number in MMP block"
+
+ec	EXT2_ET_MMP_FAILED,
+	"MMP: Device already active on another node"
+
+ec	EXT2_ET_MMP_FSCK_ON,
+	"MMP: Seems as if fsck is already being run on the filesystem."
+
 	end
 
Index: e2fsprogs-1.39/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/closefs.c
+++ e2fsprogs-1.39/lib/ext2fs/closefs.c
@@ -359,12 +359,61 @@ errout:
 	return retval;
 }
 
+errcode_t write_mmp_clean(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	char *buf;
+	struct mmp_struct *mmp_s;
+	int error;
+
+	error = ext2fs_get_mem(fs->blocksize, &buf);
+	if (error)
+		goto mmp_error;
+
+	error = io_channel_read_blk(fs->io, mmp_blk, 1, buf);
+	if (error)
+		goto mmp_error;
+
+	mmp_s = (struct mmp_struct *) buf;
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		ext2fs_swap_mmp(mmp_s);
+#endif
+	if (mmp_s->mmp_magic != EXT2_MMP_MAGIC) {
+		error = EXT2_ET_MMP_MAGIC_INVALID;
+		goto mmp_error;
+	}
+
+	mmp_s->mmp_seq = EXT2_MMP_CLEAN;
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		ext2fs_swap_mmp(mmp_s);
+#endif
+	error = io_channel_write_blk(fs->io, mmp_blk, 1, buf);
+	if (error)
+		goto mmp_error;
+
+mmp_error:
+	if (buf)
+		ext2fs_free_mem(&buf);
+
+	return error;
+}
+
+
 errcode_t ext2fs_close(ext2_filsys fs)
 {
 	errcode_t	retval;
 	
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	if ((fs->flags & EXT2_FLAG_RW) &&
+	    (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP)) {
+		retval = write_mmp_clean(fs);
+		if (retval)
+			return retval;
+	}
+
 	if (fs->flags & EXT2_FLAG_DIRTY) {
 		retval = ext2fs_flush(fs);
 		if (retval)

--=-t1uFmX4mLZcdAsgXJy22--
