From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/9 linux-next] ext2: remove dir_pages() declaration
Date: Sun, 24 May 2015 17:19:45 +0200
Message-ID: <1432480791-31396-6-git-send-email-fabf@skynet.be>
References: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

dir_pages() is now declared in pagemap.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext2/dir.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 796b491..0c6638b 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -70,11 +70,6 @@ static inline void ext2_put_page(struct page *page)
 	page_cache_release(page);
 }
 
-static inline unsigned long dir_pages(struct inode *inode)
-{
-	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
-- 
2.4.1
