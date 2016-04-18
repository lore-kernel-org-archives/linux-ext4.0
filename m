From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/18] dax: Make huge page handling depend of CONFIG_BROKEN
Date: Mon, 18 Apr 2016 23:35:36 +0200
Message-ID: <1461015341-20153-14-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbcDRVfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Apr 2016 17:35:55 -0400
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the handling of huge pages for DAX is racy. For example the
following can happen:

CPU0 (THP write fault)			CPU1 (normal read fault)

__dax_pmd_fault()			__dax_fault()
  get_block(inode, block, &bh, 0) -> not mapped
					get_block(inode, block, &bh, 0)
					  -> not mapped
  if (!buffer_mapped(&bh) && write)
    get_block(inode, block, &bh, 1) -> allocates blocks
  truncate_pagecache_range(inode, lstart, lend);
					dax_load_hole();

This results in data corruption since process on CPU1 won't see changes
into the file done by CPU0.

The race can happen even if two normal faults race however with THP the
situation is even worse because the two faults don't operate on the same
entries in the radix tree and we want to use these entries for
serialization. So make THP support in DAX code depend on CONFIG_BROKEN
for now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 2 +-
 include/linux/dax.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d7addfab2094..388327f56fa8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -707,7 +707,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 EXPORT_SYMBOL_GPL(dax_fault);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_BROKEN)
 /*
  * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
  * more often than one might expect in the below function.
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 7c45ac7ea1d1..0591f4853228 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -23,7 +23,7 @@ static inline struct page *read_dax_sector(struct block_device *bdev,
 }
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_BROKEN)
 int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
 				unsigned int flags, get_block_t);
 int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
-- 
2.6.6

