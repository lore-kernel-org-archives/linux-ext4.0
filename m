From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext2fs: check fsync error code
Date: Wed,  7 Dec 2016 18:55:18 +0400
Message-ID: <1481122518-19021-2-git-send-email-dmonakhov@openvz.org>
References: <1481122518-19021-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:23243 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbcLGOza (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 09:55:30 -0500
In-Reply-To: <1481122518-19021-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

testcase: f_mke2fs_baddisk
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 lib/ext2fs/unix_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 429ea24..6c54cbe 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1030,7 +1030,10 @@ static errcode_t unix_flush(io_channel channel)
 #ifndef NO_IO_CACHE
 	retval = flush_cached_blocks(channel, data, 0);
 #endif
-	fsync(data->dev);
+	if(fsync(data->dev)) {
+		if (!retval)
+			retval = errno;
+	}
 	return retval;
 }
 
-- 
2.7.4

