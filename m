From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext2fs: don't use O_DIRECT if not available
Date: Fri, 10 Jun 2011 01:15:30 -0600
Message-ID: <1307690130-12227-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60099 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1FJHPb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 03:15:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

O_DIRECT is not defined on OSX.  Since direct IO is only a new
optimization and not needed for correct functionality, disable
it if O_DIRECT is unavailable.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/unix_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 6e480b7..dddaf6f 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -474,8 +474,10 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
 	if (flags & IO_FLAG_EXCLUSIVE)
 		open_flags |= O_EXCL;
+#ifdef O_DIRECT
 	if (flags & IO_FLAG_DIRECT_IO)
 		open_flags |= O_DIRECT;
+#endif
 	data->flags = flags;
 
 #ifdef HAVE_OPEN64
-- 
1.7.3.4

