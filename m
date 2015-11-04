From: yalin wang <yalin.wang2010@gmail.com>
Subject: [RFC] ext4: remove unused page_idx
Date: Wed,  4 Nov 2015 16:03:39 +0800
Message-ID: <1446624219-27190-1-git-send-email-yalin.wang2010@gmail.com>
Cc: yalin wang <yalin.wang2010@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
---
 fs/ext4/readpage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

ignore my previous patch

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 5dc5e95..2cc2760 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -135,7 +135,6 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			 unsigned nr_pages)
 {
 	struct bio *bio = NULL;
-	unsigned page_idx;
 	sector_t last_block_in_bio = 0;
 
 	struct inode *inode = mapping->host;
@@ -157,7 +156,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 	map.m_len = 0;
 	map.m_flags = 0;
 
-	for (page_idx = 0; nr_pages; page_idx++, nr_pages--) {
+	for (; nr_pages; nr_pages--) {
 		int fully_mapped = 1;
 		unsigned first_hole = blocks_per_page;
 
-- 
1.9.1
