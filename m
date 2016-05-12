From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] dax: Allow DAX code to replace exceptional entries
Date: Thu, 12 May 2016 18:29:17 +0200
Message-ID: <1463070560-1979-5-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbcELQ3d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2016 12:29:33 -0400
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we forbid page_cache_tree_insert() to replace exceptional radix
tree entries for DAX inodes. However to make DAX faults race free we will
lock radix tree entries and when hole is created, we need to replace
such locked radix tree entry with a hole page. So modify
page_cache_tree_insert() to allow that.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/dax.h |  1 +
 mm/filemap.c        | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index d0883daa66d9..8558d3770a30 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/radix-tree.h>
 #include <asm/pgtable.h>
 
 /* We use lowest available exceptional entry bit for locking */
diff --git a/mm/filemap.c b/mm/filemap.c
index f2479af09da9..dfe55c2cfb34 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -597,14 +597,21 @@ static int page_cache_tree_insert(struct address_space *mapping,
 		if (!radix_tree_exceptional_entry(p))
 			return -EEXIST;
 
-		if (WARN_ON(dax_mapping(mapping)))
-			return -EINVAL;
-
-		if (shadowp)
-			*shadowp = p;
 		mapping->nrexceptional--;
-		if (node)
-			workingset_node_shadows_dec(node);
+		if (!dax_mapping(mapping)) {
+			if (shadowp)
+				*shadowp = p;
+			if (node)
+				workingset_node_shadows_dec(node);
+		} else {
+			/* DAX can replace empty locked entry with a hole */
+			WARN_ON_ONCE(p !=
+				(void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
+					 RADIX_DAX_ENTRY_LOCK));
+			/* DAX accounts exceptional entries as normal pages */
+			if (node)
+				workingset_node_pages_dec(node);
+		}
 	}
 	radix_tree_replace_slot(slot, page);
 	mapping->nrpages++;
-- 
2.6.6

