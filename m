From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix off-by-in in loop termination in ext4_find_unwritten_pgoff()
Date: Wed, 17 May 2017 14:07:39 +0200
Message-ID: <20170517120739.2529-3-jack@suse.cz>
References: <20170517120739.2529-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33757 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753426AbdEQMHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 May 2017 08:07:48 -0400
In-Reply-To: <20170517120739.2529-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an off-by-one error in loop termination conditions in
ext4_find_unwritten_pgoff(). It doesn't have any visible effects but
still it is good to fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bbea2dccd584..a80f42d189e3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -502,7 +502,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 				goto out;
 			}
 
-			if (page->index > end)
+			if (page->index >= end)
 				goto out;
 
 			lock_page(page);
@@ -550,7 +550,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 
 		index = pvec.pages[i - 1]->index + 1;
 		pagevec_release(&pvec);
-	} while (index <= end);
+	} while (index < end);
 
 	if (whence == SEEK_HOLE && lastoff < endoff) {
 		found = 1;
-- 
2.12.0
