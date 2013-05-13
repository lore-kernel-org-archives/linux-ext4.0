From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 1/2] ext4: do not left pages locked in mpage_da_submit_io()
Date: Mon, 13 May 2013 23:08:12 +0400
Message-ID: <1368472093-16997-2-git-send-email-khoroshilov@ispras.ru>
References: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	spruce-project@linuxtesting.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If call to ext4_init_io_end() is failed under memory pressure,
mpage_da_submit_io() just returns -ENOMEM and left all pages
from the extent locked. That leads to a deadlock as soon as
callers of mpage_da_submit_io() expect it unlocks all the pages.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/ext4/inode.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 793d44b..aeca439 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1489,8 +1489,9 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 	BUG_ON(mpd->next_page <= mpd->first_page);
 	ext4_io_submit_init(&io_submit, mpd->wbc);
 	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
+	/* In case of error we still have to unlock pages */
 	if (!io_submit.io_end)
-		return -ENOMEM;
+		ret = -ENOMEM;
 	/*
 	 * We need to start from the first_page to the next_page - 1
 	 * to make sure we also write the mapped dirty buffer_heads.
@@ -1512,6 +1513,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 			index = page->index;
 			if (index > end)
 				break;
+			if (!io_submit.io_end) {
+				unlock_page(page);
+				index++;
+				continue;
+			}
 
 			if (index == size >> PAGE_CACHE_SHIFT)
 				len = size & ~PAGE_CACHE_MASK;
@@ -1577,9 +1583,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 		}
 		pagevec_release(&pvec);
 	}
-	ext4_io_submit(&io_submit);
-	/* Drop io_end reference we got from init */
-	ext4_put_io_end_defer(io_submit.io_end);
+	if (io_submit.io_end) {
+		ext4_io_submit(&io_submit);
+		/* Drop io_end reference we got from init */
+		ext4_put_io_end_defer(io_submit.io_end);
+	}
 	return ret;
 }
 
-- 
1.7.9.5
