From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] fs/ext4: use list_last_entry instead of list_entry
Date: Wed, 25 Nov 2015 21:59:47 +0800
Message-ID: <00a35da75dd347ea574b4d0e6c30da6f0eae0c30.1448459920.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To make the intention clearer, use list_last_entry instead of list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/ext4/readpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 5dc5e95..ea97d5979 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -163,7 +163,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 
 		prefetchw(&page->flags);
 		if (pages) {
-			page = list_entry(pages->prev, struct page, lru);
+			page = list_last_entry(pages, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping, page->index,
 				  mapping_gfp_constraint(mapping, GFP_KERNEL)))
-- 
2.5.0
