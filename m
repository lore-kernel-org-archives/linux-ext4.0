From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libext2fs: change getpagesize to sysconf
Date: Wed,  7 Dec 2011 11:16:08 -0500
Message-ID: <1323274568-13551-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49750 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab1LGQQF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Dec 2011 11:16:05 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id C93EA1B4024
	for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2011 16:16:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Newer versions of glibc no longer export the getpagesize() prototype when
using recent versions of POSIX (_XOPEN_SOURCE).  So building tdb.c gives
use implicit function declaration warnings.  Fix the issue by using the
portable sysconf() function which returns the same answer.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/ext2fs/tdb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
index 83c834e..61e30ed 100644
--- a/lib/ext2fs/tdb.c
+++ b/lib/ext2fs/tdb.c
@@ -114,10 +114,6 @@ static TDB_DATA tdb_null;
 #define u32 unsigned
 #endif
 
-#ifndef HAVE_GETPAGESIZE
-#define getpagesize() 0x2000
-#endif
