From: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: [PATCH] ext4: remove alignment padding from ext4_inode_info on 64
 bit builds
Date: Wed, 18 Aug 2010 16:08:08 +0100
Message-ID: <1282144088.2068.16.camel@castor.rsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reorder structure ext4_inode_info to remove 16 bytes of alignment
padding on 64 bit builds. This shrinks its size from 904 to 888 bytes
with (CONFIG_EXT4_S_XATTR=y && CONFIG_QUOTA=n).
    
This will allow this structure to use one fewer cache lines.

Also change type of i_delalloc_reserved_flag to bool to better reflect
its usage.

compiled & tested on x86_64
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.36-rc1

Early testing shows more consistent results ( i.e. smaller standard
deviations) on my AMD X2 setup, but I shall re-run these tests to check
if this is repeatable.

regards
Richard


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..b63a8e3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -750,10 +750,11 @@ struct ext4_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	ext4_group_t	i_block_group;
-	unsigned long	i_state_flags;		/* Dynamic state flags */
-	unsigned long	i_flags;
 
 	ext4_lblk_t		i_dir_start_lookup;
+
+	unsigned long	i_state_flags;		/* Dynamic state flags */
+	unsigned long	i_flags;
 #ifdef CONFIG_EXT4_FS_XATTR
 	/*
 	 * Extended attributes can be read independently of the main file
@@ -816,13 +817,14 @@ struct ext4_inode_info {
 	unsigned int i_reserved_data_blocks;
 	unsigned int i_reserved_meta_blocks;
 	unsigned int i_allocated_meta_blocks;
-	unsigned short i_delalloc_reserved_flag;
-	sector_t i_da_metadata_calc_last_lblock;
-	int i_da_metadata_calc_len;
+	bool i_delalloc_reserved_flag;
 
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
+	sector_t i_da_metadata_calc_last_lblock;
+	int i_da_metadata_calc_len;
+
 	spinlock_t i_block_reservation_lock;
 #ifdef CONFIG_QUOTA
 	/* quota space reservation, managed internally by quota code */
