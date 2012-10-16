From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 04/10] ext4: extents: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:42:59 +0530
Message-ID: <1350414785-7848-4-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/extents.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/extents.c b/linux-3.7-rc1/fs/ext4/extents.c
index 1c94cca..599ce00 100644
--- a/linux-3.7-rc1/fs/ext4/extents.c
+++ b/linux-3.7-rc1/fs/ext4/extents.c
@@ -3367,7 +3367,7 @@ static void unmap_underlying_metadata_blocks(struct block_device *bdev,
 {
 	int i;
 	for (i = 0; i < count; i++)
-                unmap_underlying_metadata(bdev, block + i);
+		unmap_underlying_metadata(bdev, block + i);
 }
 
 /*
@@ -4096,7 +4096,7 @@ got_allocated_blocks:
 	ext4_ext_store_pblock(&newex, newblock + offset);
 	newex.ee_len = cpu_to_le16(ar.len);
 	/* Mark uninitialized */
-	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
+	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT) {
 		ext4_ext_mark_uninitialized(&newex);
 		/*
 		 * io_end structure was created for every IO write to an
@@ -4527,7 +4527,7 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
-		if (ret <= 0 || ret2 )
+		if (ret <= 0 || ret2)
 			break;
 	}
 	return ret > 0 ? ret2 : ret;
-- 
1.7.7.3
