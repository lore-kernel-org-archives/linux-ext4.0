From: Jan Kara <jack@suse.cz>
Subject: [PATCH 15/18] dax: Allow DAX code to replace exceptional entries
Date: Mon, 18 Apr 2016 23:35:38 +0200
Message-ID: <1461015341-20153-16-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbcDRVf4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Apr 2016 17:35:56 -0400
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we forbid page_cache_tree_insert() to replace exceptional radix
tree entries for DAX inodes. However to make DAX faults race free we will
lock radix tree entries and when hole is created, we need to replace
such locked radix tree entry with a hole page. So modify
page_cache_tree_insert() to allow that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/dax.h |  1 +
 mm/filemap.c        | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index bef5c44f71b3..fd4aeae65ed7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/radix-tree.h>
 #include <asm/pgtable.h>
 
 /* We use lowest available exceptional entry bit for locking */
diff --git a/mm/filemap.c b/mm/filemap.c
index f2479af09da9..3effd5c8f2f6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -597,14 +597,18 @@ static int page_cache_tree_insert(struct address_space *mapping,
 		if (!radix_tree_exceptional_entry(p))
 			return -EEXIST;
 
-		if (WARN_ON(dax_mapping(mapping)))
-			return -EINVAL;
