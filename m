From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 4/5] ext4: Use ext4_get_block_write() for DAX
Date: Mon, 29 Jun 2015 16:02:31 -0400
Message-ID: <1435608152-6982-5-git-send-email-matthew.r.wilcox@intel.com>
References: <1435608152-6982-1-git-send-email-matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1435608152-6982-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

DAX relies on the get_block function either zeroing newly allocated blocks
before they're findable by subsequent calls to get_block, or marking newly
allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
extents, but ext4_get_block_write() can.

Reported-by: Andy Rudoff <andy.rudoff@intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/ext4/file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ac517f1..f66f3da 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -194,13 +194,12 @@ out:
 #ifdef CONFIG_FS_DAX
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block);
-					/* Is this the right get_block? */
+	return dax_fault(vma, vmf, ext4_get_block_write);
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block);
+	return dax_mkwrite(vma, vmf, ext4_get_block_write);
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
-- 
2.1.4

