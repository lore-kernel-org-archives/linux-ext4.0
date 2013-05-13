From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 2/2] ext4: do not left pages locked in ext4_writepage()
Date: Mon, 13 May 2013 23:08:13 +0400
Message-ID: <1368472093-16997-3-git-send-email-khoroshilov@ispras.ru>
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
ext4_writepage() calls redirty_page_for_writepage() but left the page locked.
That leads to a deadlock since it is expected the page is unlocked after writepage().

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aeca439..c6bc999 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2250,6 +2250,7 @@ static int ext4_writepage(struct page *page,
 	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
 	if (!io_submit.io_end) {
 		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
 		return -ENOMEM;
 	}
 	ret = ext4_bio_write_page(&io_submit, page, len, wbc);
-- 
1.7.9.5
