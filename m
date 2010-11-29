From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 11/15] mke2fs: fix determination of size_type
Date: Mon, 29 Nov 2010 17:55:13 +0900
Message-ID: <1291020917-8671-12-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43225 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0K2Izt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:49 -0500
Received: by mail-gx0-f174.google.com with SMTP id 22so1868483gxk.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:48 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In original code, 'huge' type could not be selected because it
always be caught for 'big' type. Change the ordering.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 90cc206..b88decf 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -947,10 +947,10 @@ static char **parse_fs_type(const char *fs_type,
 		size_type = "floppy";
 	else if (fs_blocks_count < 512 * meg)
 		size_type = "small";
-	else if (fs_blocks_count >= 4 * 1024 * 1024 * meg)
-		size_type = "big";
 	else if (fs_blocks_count >= 16 * 1024 * 1024 * meg)
 		size_type = "huge";
+	else if (fs_blocks_count >= 4 * 1024 * 1024 * meg)
+		size_type = "big";
 	else
 		size_type = "default";
 
-- 
1.7.0.4

