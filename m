From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [RFC][PATCH] Multiple mount protection
Date: Tue, 22 May 2007 01:22:32 +0530
Message-ID: <1179777153.3910.13.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54011 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935423AbXEUTtO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 15:49:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

There have been reported instances of a filesystem having been mounted at 2 places at the same time causing a lot of damage to the filesystem. This patch reserves superblock fields and an INCOMPAT flag for adding multiple mount protection(MMP) support within the ext4 filesystem itself. The superblock will have a block number (s_mmp_block) which will hold a MMP structure which has a sequence number which will be periodically updated every 5 seconds by a mounted filesystem. Whenever a filesystem will be mounted it will wait for s_mmp_interval seconds to make sure that the MMP sequence does not change. To further make sure, we write a random sequence number into the MMP block and wait for another s_mmp_interval secs. If the sequence no. doesn't change then the mount will succeed. In case of failure, the nodename, bdevname and the time at which the MMP block was last updated will be displaye
 d. tune2fs can be used to set s_mmp_interval as desired.

It will also protect against running e2fsck on a mounted filesystem by adding similar logic to ext2fs_open().

Any comments or views are welcome!

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
@@ -568,8 +568,9 @@ struct ext2_super_block {
        __u16   s_want_extra_isize;     /* New inodes should reserve # bytes */
        __u32   s_flags;                /* Miscellaneous flags */
        __u16   s_raid_stride;          /* RAID stride */
-       __u16   s_pad;                  /* Padding */
-       __u32   s_reserved[166];        /* Padding to the end of the block */
+       __u16   s_mmp_interval;         /* Wait for # seconds in MMP checking */
+       __u64   s_mmp_block;            /* Block for multi-mount protection */
+       __u32   s_reserved[164];        /* Padding to the end of the block */
 };

 /*
@@ -631,10 +632,12 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_META_BG          0x0010
 #define EXT3_FEATURE_INCOMPAT_EXTENTS          0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT            0x0080
+#define EXT4_FEATURE_INCOMPAT_MMP              0x0100


 #define EXT2_FEATURE_COMPAT_SUPP       0
-#define EXT2_FEATURE_INCOMPAT_SUPP     (EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP     (EXT2_FEATURE_INCOMPAT_FILETYPE| \
+                                        EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP    (EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
                                         EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
                                         EXT2_FEATURE_RO_COMPAT_BTREE_DIR)


Thanks,
Kalpak.
