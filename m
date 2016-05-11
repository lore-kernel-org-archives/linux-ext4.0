From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] DAX: move RADIX_DAX_ definitions to dax.c
Date: Wed, 11 May 2016 11:58:47 +0200
Message-ID: <1462960733-29634-2-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, NeilBrown <neilb@suse.com>,
	Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbcEKJ7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 05:59:22 -0400
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: NeilBrown <neilb@suse.com>

These don't belong in radix-tree.c any more than PAGECACHE_TAG_* do.
Let's try to maintain the idea that radix-tree simply implements an
abstract data type.

Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                   | 9 +++++++++
 include/linux/radix-tree.h | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 75ba46d82a76..08799a510b4d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,6 +32,15 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
+#define RADIX_DAX_MASK	0xf
+#define RADIX_DAX_SHIFT	4
+#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
+#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct request_queue *q = bdev->bd_queue;
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 51a97ac8bfbf..d08d6ec3bf53 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -52,15 +52,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-#define RADIX_DAX_MASK	0xf
-#define RADIX_DAX_SHIFT	4
-#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
-#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
-#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
-		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
