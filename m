From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] fs: Convert checks for write IO errors from !buffer_uptodate to buffer_write_io_error
Date: Thu,  5 Jan 2012 15:40:05 +0100
Message-ID: <1325774407-28531-2-git-send-email-jack@suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1325774407-28531-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert a few remaining checks for write IO error in VFS using !buffer_uptodate
test to using buffer_write_io_error.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 19d8eb7..3469d53 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -550,7 +550,7 @@ repeat:
 			get_bh(bh);
 			spin_unlock(lock);
 			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
+			if (buffer_write_io_error(bh))
 				err = -EIO;
 			brelse(bh);
 			spin_lock(lock);
@@ -810,7 +810,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 		}
 		spin_unlock(lock);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 		brelse(bh);
 		spin_lock(lock);
@@ -3039,7 +3039,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, int rw)
 		bh->b_end_io = end_buffer_write_sync;
 		ret = submit_bh(rw, bh);
 		wait_on_buffer(bh);
-		if (!ret && !buffer_uptodate(bh))
+		if (!ret && buffer_write_io_error(bh))
 			ret = -EIO;
 	} else {
 		unlock_buffer(bh);
-- 
1.7.1
