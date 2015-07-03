From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v2 3/6] ext4: Use ext4_get_block_write() for DAX
Date: Fri,  3 Jul 2015 10:40:40 -0400
Message-ID: <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com>
References: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

DAX relies on the get_block function either zeroing newly allocated blocks
before they're findable by subsequent calls to get_block, or marking newly
allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
extents, but ext4_get_block_write() can.

Reported-by: Andy Rudoff <andy.rudoff@intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/ext4/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bc313ac..e5bdcb7 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -195,7 +195,7 @@ out:
 static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
 {
 	struct inode *inode = bh->b_assoc_map->host;
-	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
+	/* XXX: breaks on 32-bit > 16TB. Is that even supported? */
 	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
 	int err;
 	if (!uptodate)
@@ -206,13 +206,13 @@ static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
-					/* Is this the right get_block? */
+	return dax_fault(vma, vmf, ext4_get_block_write, ext4_end_io_unwritten);
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
+	return dax_mkwrite(vma, vmf, ext4_get_block_write,
+				ext4_end_io_unwritten);
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
-- 
2.1.4
