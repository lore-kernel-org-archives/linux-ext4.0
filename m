From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/10] ext4: Use pagevec_lookup_range() in ext4_find_unwritten_pgoff()
Date: Wed, 26 Jul 2017 13:46:59 +0200
Message-ID: <20170726114704.7626-6-jack@suse.cz>
References: <20170726114704.7626-1-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: <linux-mm@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751495AbdGZLr1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Jul 2017 07:47:27 -0400
In-Reply-To: <20170726114704.7626-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use pagevec_lookup_range() in ext4_find_unwritten_pgoff() since we are
interested only in pages in the given range. Simplify the logic as a
result of not getting pages out of range and index getting automatically
advanced.

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ab09cb6fcce3..ac39a6a1ea5d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -494,12 +494,11 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 
 	pagevec_init(&pvec, 0);
 	do {
-		int i, num;
+		int i;
 		unsigned long nr_pages;
 
-		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
-					  (pgoff_t)num);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+					&index, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
@@ -518,9 +517,6 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 				goto out;
 			}
 
-			if (page->index > end)
-				goto out;
