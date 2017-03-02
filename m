From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] ext4: create an ioctl report fs geometry
Date: Wed, 1 Mar 2017 20:09:22 -0800
Message-ID: <20170302040922.GF5266@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:26442 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdCBEL1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2017 23:11:27 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v224ATCN011590
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Thu, 2 Mar 2017 04:10:29 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add an ioctl to report the geometry of a mounted filesystem.  The
structure is designed to be close enough to XFS's that we'll be able to
leverage the new GETFSMAP functionality in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h  |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2163c1e..9e93aba 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -614,6 +614,38 @@ enum {
 #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
 #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
 
+/* ext4 fs geometry. */
+struct ext4_fsop_geom {
+	__u32		efg_blocksize;	/* filesystem (data) block size */
+	__u32		efg_bgblocks;	/* fsblocks in a block group	*/
+	__u32		efg_bgcount;	/* number of block groups	*/
+	__u32		efg_logblocks;	/* fsblocks in the log		*/
+	__u32		efg_resvblocks;	/* number of reserved blocks	*/
+	__u32		efg_inodesize;	/* inode size in bytes		*/
+	__u32		efg_bg_iblocks;	/* inode blocks per block group	*/
+	__u32		efg_flags;	/* superblock feature flags	*/
+	__u64		efg_inodecount;	/* inode count			*/
+	__u64		efg_blockcount;	/* fsblocks in filesystem	*/
+	unsigned char	efg_uuid[16];	/* unique id of the filesystem	*/
+	__u32		efg_sunit;	/* stripe unit, fsblocks	*/
+	__u32		efg_swidth;	/* stripe width, fsblocks	*/
+	__u32		efg_clustersize;/* fs cluster size		*/
+	__u32		efg_flexbgsize;	/* number of bg's in a flexbg	*/
+	__u64		efg_resv[6];
+};
+
+#define EXT4_FSOP_GEOM_FLAGS_ATTR	0x00001	/* extended attrs in use */
+#define EXT4_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	 */
+#define EXT4_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	 */
+#define EXT4_FSOP_GEOM_FLAGS_PROJQ	0x00008	/* project quotas	 */
+#define EXT4_FSOP_GEOM_FLAGS_META_CSUM	0x00010	/* metadata checksums	 */
+#define EXT4_FSOP_GEOM_FLAGS_FTYPE	0x00020	/* inode directory types */
+#define EXT4_FSOP_GEOM_FLAGS_64BIT	0x00040	/* 64-bit support	 */
+#define EXT4_FSOP_GEOM_FLAGS_INLINEDATA	0x00080	/* inline data		 */
+#define EXT4_FSOP_GEOM_FLAGS_ENCRYPT	0x00100	/* encrypted files	 */
+#define EXT4_FSOP_GEOM_FLAGS_LARGEDIR	0x00200	/* large directories	 */
+#define EXT4_FSOP_GEOM_FLAGS_EXTENTS	0x00400	/* extents		 */
+
 /*
  * ioctl commands
  */
@@ -638,6 +670,7 @@ enum {
 #define EXT4_IOC_SET_ENCRYPTION_POLICY	FS_IOC_SET_ENCRYPTION_POLICY
 #define EXT4_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
 #define EXT4_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
+#define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct ext4_fsop_geom)
 
 #ifndef FS_IOC_FSGETXATTR
 /* Until the uapi changes get merged for project quota... */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 886e1e8..7155d65 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -528,6 +528,57 @@ static int ext4_ioc_getfsmap(struct super_block *sb, void __user *arg)
 	return 0;
 }
 
+static int ext4_ioc_fsgeometry(struct super_block *sb, void __user *arg)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	journal_t *journal = sbi->s_journal;
+	struct ext4_fsop_geom geom = {0};
+
+	geom.efg_blocksize = EXT4_BLOCK_SIZE(sb);
+	geom.efg_inodecount = le32_to_cpu(sbi->s_es->s_inodes_count);
+	geom.efg_bgblocks = EXT4_BLOCKS_PER_GROUP(sb);
+	geom.efg_bgcount = sbi->s_groups_count;
+	geom.efg_logblocks = journal ? journal->j_maxlen : 0;
+	geom.efg_resvblocks = ext4_r_blocks_count(sbi->s_es);
+	geom.efg_inodesize = EXT4_INODE_SIZE(sb);
+	geom.efg_bg_iblocks = sbi->s_itb_per_group;
+	geom.efg_blockcount = ext4_blocks_count(sbi->s_es);
+	memcpy(geom.efg_uuid, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	geom.efg_sunit = le16_to_cpu(sbi->s_es->s_raid_stride);
+	geom.efg_swidth = le16_to_cpu(sbi->s_es->s_raid_stripe_width);
+	geom.efg_flags = 0;
+	if (ext4_has_feature_xattr(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_ATTR;
+	if (ext4_has_feature_dir_nlink(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_NLINK;
+	if (ext4_has_feature_quota(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_QUOTA;
+	if (ext4_has_feature_project(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_PROJQ;
+	if (ext4_has_metadata_csum(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_META_CSUM;
+	if (ext4_has_feature_filetype(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_FTYPE;
+	if (ext4_has_feature_64bit(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_64BIT;
+	if (ext4_has_feature_inline_data(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_INLINEDATA;
+	if (ext4_has_feature_encrypt(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_ENCRYPT;
+	if (ext4_has_feature_largedir(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_LARGEDIR;
+	if (ext4_has_feature_extents(sb))
+		geom.efg_flags |= EXT4_FSOP_GEOM_FLAGS_EXTENTS;
+	if (ext4_has_feature_bigalloc(sb))
+		geom.efg_clustersize = EXT4_C2B(sbi, 1);
+	if (ext4_has_feature_flex_bg(sb))
+		geom.efg_flexbgsize = ext4_flex_bg_size(sbi);
+
+	if (copy_to_user(arg, &geom, sizeof(geom)))
+		return -EFAULT;
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -538,6 +589,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case EXT4_IOC_FSGEOMETRY:
+		return ext4_ioc_fsgeometry(sb, (void __user *)arg);
 	case FS_IOC_GETFSMAP:
 		return ext4_ioc_getfsmap(sb, (void __user *)arg);
 	case EXT4_IOC_GETFLAGS:
