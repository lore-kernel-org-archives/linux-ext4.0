From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] i_dir_acl related cleanup
Date: Tue, 16 Oct 2007 13:09:25 +0530
Message-ID: <47146AAD.3010801@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:51611 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbXJPHkI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2007 03:40:08 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9G7e3vw017080
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 17:40:03 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9G7hRbN198372
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 17:43:27 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9G7daal003586
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 17:39:36 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I am wondering whether we can use i_size_high without looking at
file mode (why restrict only to regular files  ? )

-aneesh



>From a5796eb4af173d2a0a9b8f0f80a8af12bf3e2695 Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 12:25:18 +0530
Subject: [PATCH] ext4: code cleanup

rename ext4_inode.i_dir_acl to i_size_high
drop ext4_inode_info.i_dir_acl as it is not used

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c          |    1 -
 fs/ext4/inode.c           |   12 ++++--------
 include/linux/ext4_fs.h   |    5 ++---
 include/linux/ext4_fs_i.h |    1 -
 4 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 922c64d..f8d41b1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -711,7 +711,6 @@ got:
 	if (!S_ISDIR(mode))
 		ei->i_flags &= ~EXT4_DIRSYNC_FL;
 	ei->i_file_acl = 0;
-	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f5f64ff..1da3477 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2735,7 +2735,7 @@ void ext4_read_inode(struct inode * inode)
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
-	inode->i_size = le32_to_cpu(raw_inode->i_size);
+	inode->i_size = le32_to_cpu(raw_inode->i_size_lo);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2764,9 +2764,7 @@ void ext4_read_inode(struct inode * inode)
 	    cpu_to_le32(EXT4_OS_HURD))
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
-	if (!S_ISREG(inode->i_mode)) {
-		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
-	} else {
+	if (S_ISREG(inode->i_mode)) {
 		inode->i_size |=
 			((__u64)le32_to_cpu(raw_inode->i_size_high)) << 32;
 	}
@@ -2900,7 +2898,7 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_gid_high = 0;
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
-	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
+	raw_inode->i_size_lo = cpu_to_le32(ei->i_disksize);
 
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
 	EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
@@ -2915,9 +2913,7 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
 	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
-	if (!S_ISREG(inode->i_mode)) {
-		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
-	} else {
+	if (S_ISREG(inode->i_mode)) {
 		raw_inode->i_size_high =
 			cpu_to_le32(ei->i_disksize >> 32);
 		if (ei->i_disksize > 0x7fffffffULL) {
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index d7f15a4..bacafd9 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -303,7 +303,7 @@ struct ext4_mount_options {
 struct ext4_inode {
 	__le16	i_mode;		/* File mode */
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
-	__le32	i_size;		/* Size in bytes */
+	__le32	i_size_lo;	/* Size in bytes */
 	__le32	i_atime;	/* Access time */
 	__le32	i_ctime;	/* Inode Change time */
 	__le32	i_mtime;	/* Modification time */
@@ -326,7 +326,7 @@ struct ext4_inode {
 	__le32	i_block[EXT4_N_BLOCKS];/* Pointers to blocks */
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl_lo;	/* File ACL */
-	__le32	i_dir_acl;	/* Directory ACL */
+	__le32	i_size_high;
 	__le32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
 		struct {
@@ -359,7 +359,6 @@ struct ext4_inode {
 	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
 };
 
-#define i_size_high	i_dir_acl
 
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 94baea0..16249b9 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -85,7 +85,6 @@ struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
 	__u32	i_flags;
 	ext4_fsblk_t	i_file_acl;
-	__u32	i_dir_acl;
 	__u32	i_dtime;
 
 	/*
-- 
1.5.3.4.206.g58ba4-dirty
