From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libext2fs: check for fallocate symbol before using it
Date: Mon,  5 Mar 2012 00:36:35 -0500
Message-ID: <1330925795-12358-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:51246 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2CEFgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 00:36:33 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 6D87F1B4014
	for <linux-ext4@vger.kernel.org>; Mon,  5 Mar 2012 05:36:32 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have newer kernel headers which define FALLOC_FL_PUNCH_HOLE, but we
are on an older glibc which lacks fallocate, we end up trying to use the
func anyways.  Check the ifdef that autoconf already set up for us.

Reported-by: Ortwin Glueck <odi@odi.ch>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/ext2fs/unix_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 9f0613a..da3f8fd 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -905,7 +905,7 @@ static errcode_t unix_discard(io_channel channel, unsigned long long block,
 		goto unimplemented;
 #endif
 	} else {
-#ifdef FALLOC_FL_PUNCH_HOLE
+#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE)
 		/*
 		 * If we are not on block device, try to use punch hole
 		 * to reclaim free space.
-- 
1.7.8.4

