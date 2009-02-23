From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] * lib/ext2fs/dosio.c (dos_open): don't leak strdup'd dev name upon error
Date: Mon, 23 Feb 2009 17:47:30 +0100
Message-ID: <874oyldrrx.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36392 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbZBWQrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 11:47:40 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3426B94013C
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:47:33 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 2E9BD940126
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:47:31 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Jim Meyering <meyering@redhat.com>
---
Spotted by inspection.
For all I know, this is dead code ;-)

 lib/ext2fs/dosio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/dosio.c b/lib/ext2fs/dosio.c
index 97ceef5..a7968cd 100644
--- a/lib/ext2fs/dosio.c
+++ b/lib/ext2fs/dosio.c
@@ -278,6 +278,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   if(!HW_OK())
   {
     _dio_error = ERR_HARDWARE;
+    free(part->dev);
     free(part);
     return EFAULT;
   }
@@ -297,6 +298,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   if(!HW_OK())
   {
     _dio_error = ERR_HARDWARE;
+    free(part->dev);
     free(part);
     return EFAULT;
   }
@@ -308,6 +310,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   {
     _dio_error = part->pno == 0xFE ? ERR_EMPTYPART :
                  part->pno == 0xFD ? ERR_LINUXSWAP : ERR_NOTEXT2FS;
+    free(part->dev);
     free(part);
     return ENODEV;
   }
--
1.6.2.rc1.266.g4bdf
