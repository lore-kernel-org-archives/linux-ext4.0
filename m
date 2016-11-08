From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/11] dax: Introduce IOMAP_FAULT flag
Date: Tue,  8 Nov 2016 12:08:13 +0100
Message-ID: <1478603297-11793-8-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Introduce a flag telling iomap operations whether they are handling a
fault or other IO. That may influence behavior wrt inode size and
similar things.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c              | 4 ++--
 fs/iomap.c            | 5 +++--
 include/linux/iomap.h | 1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 281e91a63367..28af41b9da3a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1266,7 +1266,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	sector_t sector;
 	struct iomap iomap = { 0 };
-	unsigned flags = 0;
+	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
 	int locked_status = 0;
 	void *entry;
@@ -1467,7 +1467,7 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = flags & FAULT_FLAG_WRITE;
-	unsigned int iomap_flags = write ? IOMAP_WRITE : 0;
+	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
 	struct inode *inode = mapping->host;
 	int result = VM_FAULT_FALLBACK;
 	struct iomap iomap = { 0 };
diff --git a/fs/iomap.c b/fs/iomap.c
index a8ee8c33ca78..13dd413b2b9c 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -467,8 +467,9 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	offset = page_offset(page);
 	while (length > 0) {
-		ret = iomap_apply(inode, offset, length, IOMAP_WRITE,
-				ops, page, iomap_page_mkwrite_actor);
+		ret = iomap_apply(inode, offset, length,
+				IOMAP_WRITE | IOMAP_FAULT, ops, page,
+				iomap_page_mkwrite_actor);
 		if (unlikely(ret <= 0))
 			goto out_unlock;
 		offset += ret;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7892f55a1866..f185156de74d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -49,6 +49,7 @@ struct iomap {
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
+#define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
 
 struct iomap_ops {
 	/*
-- 
2.6.6

