From: Lin Feng <linf@chinanetcenter.com>
Subject: [PATCH] ext4: mballoc.h typo fix: correct wrong comments about MB_DEFAULT_STREAM_THRESHOLD
Date: Tue,  7 Jun 2016 14:47:35 +0800
Message-ID: <1465282055-29042-1-git-send-email-linf@chinanetcenter.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lin Feng <linf@chinanetcenter.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

According to ext4_mb_group_or_file it's obviously that files larger
than s_mb_stream_request use stream allocator and smaller ones use
locality group allocator.

The original intention for stream allocator had been broken since
commit 4ba74d00a202 ("ext4: Fix bugs in mballoc's stream allocation mode")
and the comments for MB_DEFAULT_STREAM_THRESHOLD became stale.

Signed-off-by: Lin Feng <linf@chinanetcenter.com>
---
 fs/ext4/mballoc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 3ef1df6..2e64c0e 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -59,10 +59,10 @@ extern ushort ext4_mballoc_debug;
 #define MB_DEFAULT_STATS		0
 
 /*
- * files smaller than MB_DEFAULT_STREAM_THRESHOLD are served
+ * files larger than MB_DEFAULT_STREAM_THRESHOLD are served
  * by the stream allocator, which purpose is to pack requests
  * as close each to other as possible to produce smooth I/O traffic
- * We use locality group prealloc space for stream request.
+ * We use locality group prealloc space for non stream request.
  * We can tune the same via /proc/fs/ext4/<parition>/stream_req
  */
 #define MB_DEFAULT_STREAM_THRESHOLD	16	/* 64K */
-- 
1.9.3
