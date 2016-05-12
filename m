From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/7] dax: Define DAX lock bit for radix tree exceptional entry
Date: Thu, 12 May 2016 18:29:16 +0200
Message-ID: <1463070560-1979-4-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We will use lowest available bit in the radix tree exceptional entry for
locking of the entry. Define it. Also clean up definitions of DAX entry
type bits in DAX exceptional entries to use defined constants instead of
hardcoding numbers and cleanup checking of these bits to not rely on how
other bits in the entry are set.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 17 +++++++++++------
 include/linux/dax.h |  3 +++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ef44ee2af7af..20b39588ceff 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,14 +32,19 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
-#define RADIX_DAX_MASK	0xf
-#define RADIX_DAX_SHIFT	4
-#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+/*
+ * We use lowest available bit in exceptional entry for locking, other two
+ * bits to determine entry type. In total 3 special bits.
+ */
+#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
+#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
+#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
+#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
 #define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
 #define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
-		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
+		RADIX_TREE_EXCEPTIONAL_ENTRY))
 
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 3be567e3ae9c..d0883daa66d9 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,6 +5,9 @@
 #include <linux/mm.h>
 #include <asm/pgtable.h>
 
+/* We use lowest available exceptional entry bit for locking */
+#define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
+
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
 int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
-- 
2.6.6

