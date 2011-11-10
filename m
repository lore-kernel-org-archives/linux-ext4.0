From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 1/8] vfs: Add a new flag and related functions in buffer to count io types
Date: Thu, 10 Nov 2011 18:34:47 +0800
Message-ID: <1320921294-30321-2-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

'Issue' flag is added into buffer_head to indicate that a request is issued
to the disk. When an io doesn't hit page cache, 'Issue' flag will be set in
submit_bh(). Filesystem can understand request is sent to the disk according
to whether or not this flag is set. This flag will be cleared after filesystem
tests it. If filesystem doesn't want to count the io type, it can ignore this
flag.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/buffer.c                 |    3 +++
 include/linux/buffer_head.h |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 70a1974..f681caa 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2920,6 +2920,9 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(buffer_delay(bh));
 	BUG_ON(buffer_unwritten(bh));
 
+	/* set issue flag for indicating a request is issued to the disk */
+	set_buffer_issue(bh);
+
 	/*
 	 * Only clear out a write error when rewriting
 	 */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..2bccdb4 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -38,6 +38,10 @@ enum bh_state_bits {
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
 			 */
+
+	BH_Issue,	/* Issue a request to the disk when this request
+			 * doesn't hit cache
+			 */
 };
 
 #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
@@ -124,6 +128,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Issue, issue)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
-- 
1.7.4.1

