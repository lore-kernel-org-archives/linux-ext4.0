From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] fs: Do not clear uptodate flag on write IO error
Date: Thu,  5 Jan 2012 15:40:06 +0100
Message-ID: <1325774407-28531-3-git-send-email-jack@suse.cz>
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

It is semantically wrong to clear uptodate flag of buffers where the write has
failed since the data in the buffer is still correct despite the write failing.
This also causes spurious warnings when IO error happens, we decide to write
the buffer again and call mark_buffer_dirty() which warns us about non-uptodate
buffer.

Sadly, historically buffer_uptodate() check has been the way we detected IO
errors and quite some code still uses this check. Eventually we'd like to
convert all users to use buffer_write_io_error() test instead but that requires
audit of all filesystems. So for now just provide an opt-in flag in
file_system_type by which filesystem can say it detects write IO errors by
checking buffer_write_io_error() and thus we don't have to clear uptodate flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c        |    8 ++++++--
 include/linux/fs.h |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3469d53..96cbb4c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -156,7 +156,9 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 				       bdevname(bh->b_bdev, b));
 		}
 		set_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
+		if (!(bh->b_bdev->bd_super->s_type->fs_flags &
+						FS_HANDLE_WRITE_ERROR))
+			clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
 	put_bh(bh);
@@ -389,7 +391,9 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 		}
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
+		if (!(bh->b_bdev->bd_super->s_type->fs_flags &
+						FS_HANDLE_WRITE_ERROR))
+			clear_buffer_uptodate(bh);
 		SetPageError(page);
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0bc4ff..f69e5f3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -181,6 +181,9 @@ struct inodes_stat_t {
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
 					 */
+#define FS_HANDLE_WRITE_ERROR	65536	/* Don't clear uptodate flag on buffers
+					 * when write IO error happens
+					 */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
-- 
1.7.1
