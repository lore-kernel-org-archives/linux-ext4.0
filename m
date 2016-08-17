From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] ext4: allow DAX writeback for hole punch
Date: Wed, 17 Aug 2016 10:11:02 -0600
Message-ID: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-nvdimm@lists.01.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
This is because the logic around filemap_write_and_wait_range() in
ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
not for dirty DAX exceptional entries.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---

I found this while testing my PMD patches
(https://lkml.org/lkml/2016/8/15/613), but this fix applies equally to the
4k-only case.  I'm sending this separately from that series because I think
that this should probably be merged for v4.8 as it corrects an existing bug
and should have very low risk.

Regarding the other two supported DAX filesystems, XFS already properly
does this writeback and ext2 doesn't support hole punch so it doesn't have
to worry about this issue.

---
 fs/ext4/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3131747..8550416 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3890,7 +3890,7 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 }
 
 /*
- * ext4_punch_hole: punches a hole in a file by releaseing the blocks
+ * ext4_punch_hole: punches a hole in a file by releasing the blocks
  * associated with the given offset and length
  *
  * @inode:  File inode
@@ -3919,7 +3919,9 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
 	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+	    ((!dax_mapping(mapping) && mapping->nrpages) ||
+	     (dax_mapping(mapping) && mapping->nrexceptional))) {
 		ret = filemap_write_and_wait_range(mapping, offset,
 						   offset + length - 1);
 		if (ret)
-- 
2.9.0
