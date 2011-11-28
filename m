From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 2/8] ext4: add wrapper functions for buffer layer
Date: Mon, 28 Nov 2011 20:20:22 +0800
Message-ID: <1322482828-5529-2-git-send-email-wenqing.lz@taobao.com>
References: <1322482392-5346-1-git-send-email-wenqing.lz@taobao.com>
 <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42861 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1K1MSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:18:30 -0500
In-Reply-To: <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Wrapper functions are defined to account the result of IO type.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h  |   21 +++++++++++++++
 fs/ext4/super.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cd9c7f9..6b90493 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1963,6 +1963,27 @@ static inline void ext4_ios_read(struct super_block *sb, int type,
 	__ext4_io_stat(sb, READ, type, count);
 }
 
+extern void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh,
+				       struct super_block *sb, int type,
+				       unsigned long count);
+extern int ext4_submit_bh_read(int rw, struct buffer_head *bh,
+			       struct super_block *sb, int type,
+			       unsigned long count);
+extern void ext4_submit_bh_write_nowait(int rw, struct buffer_head *bh,
+					struct super_block *sb, int type,
+					unsigned long count);
+extern struct buffer_head *ext4_sb_bread(struct super_block *sb, sector_t block,
+					 int type, unsigned long count);
+extern void ext4_sb_breadahead(struct super_block *sb,
+			       sector_t block, int type);
+
+static inline int ext4_bh_submit_read(struct buffer_head *bh,
+				      struct super_block *sb,
+				      int type, unsigned long count)
+{
+	return ext4_submit_bh_read(READ, bh, sb, type, count);
+}
+
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ef3e03b..b10b5ed 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5000,6 +5000,84 @@ count:
 	__ext4_io_stat(sb, WRITE, type, count);
 }
 
+void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh,
+				struct super_block *sb, int type,
+				unsigned long count)
+{
+	BUG_ON(rw & WRITE);
+	BUG_ON(!buffer_locked(bh));
+
+	/* IO type accouting */
+	ext4_ios_read(sb, type, count);
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(rw, bh);
+}
+
+int ext4_submit_bh_read(int rw, struct buffer_head *bh, struct super_block *sb,
+			int type, unsigned long count)
+{
+	BUG_ON(rw & WRITE);
+	BUG_ON(!buffer_locked(bh));
+
+	if (buffer_uptodate(bh)) {
+		unlock_buffer(bh);
+		return 0;
+	}
+
+	ext4_submit_bh_read_nowait(rw, bh, sb, type, count);
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		return 0;
+	return -EIO;
+}
+
+void ext4_submit_bh_write_nowait(int rw, struct buffer_head *bh,
+				 struct super_block *sb, int type,
+				 unsigned long count)
+{
+	BUG_ON(!(rw & WRITE));
+	BUG_ON(!buffer_locked(bh));
+
+	/* IO type accouting */
+	ext4_ios_write(sb, NULL, NULL, type, count);
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_write_sync;
+	submit_bh(rw, bh);
+}
+
+struct buffer_head *ext4_sb_bread(struct super_block *sb, sector_t block,
+				  int type, unsigned long count)
+{
+	struct buffer_head *bh = __getblk(sb->s_bdev, block, sb->s_blocksize);
+
+	if (likely(bh) && !buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		if (ext4_submit_bh_read(READ, bh, sb, type, count)) {
+			brelse(bh);
+			bh = NULL;
+		}
+	}
+	return bh;
+}
+
+void ext4_sb_breadahead(struct super_block *sb, sector_t block, int type)
+{
+	struct buffer_head *bh = __getblk(sb->s_bdev, block, sb->s_blocksize);
+	if (likely(bh)) {
+		if (trylock_buffer(bh)) {
+			if (buffer_uptodate(bh))
+				ext4_submit_bh_read_nowait(READ, bh, sb,
+							   type, 1);
+			else
+				unlock_buffer(bh);
+		}
+		brelse(bh);
+	}
+}
+
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data)
 {
-- 
1.7.4.1

