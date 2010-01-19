From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] e4defrag : Open the source file for e4defrag in read write
	mode to avoid failures from EXT4_IOC_EXT_MOVE
Date: Tue, 19 Jan 2010 09:51:08 +0530
Message-ID: <ea11fea31001182021m66f82afei1750a9e92b53e047@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:51769 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0ASEV3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 23:21:29 -0500
Received: by iwn35 with SMTP id 35so2593670iwn.4
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 20:21:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Akira,

I am consistently getting -EBADF while trying out e4defrag and it
fails with below error.

/home/mkatiyar/e2fs-git/e2fsprogs/misc> ./e4defrag -v /tmp/ohsm/mntdir/f1
ext4 defragmentation for /tmp/ohsm/mntdir/f1
[1/1]/tmp/ohsm/mntdir/f1:	  0%
	Failed to defrag:Bad file descriptor	[ NG ]
 Success:			[0/1]

Below patch fixes the issue for me, though I am not sure if this is
the right fix to open the source file in readwrite mode or fix the
ext4 ioctl part.


Open the source file in read write mode to avoid failures from EXT4_IOC_EXT_MOVE

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 misc/e4defrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..424e0ca 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const
struct stat64 *buf,
 		return 0;
 	}

-	fd = open64(file, O_RDONLY);
+	fd = open64(file, O_RDWR);
 	if (fd < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
-- 
1.6.3.3


-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
