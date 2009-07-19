From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 1/5] e4defrag: return more specific error message on ioctl failure
Date: Mon, 20 Jul 2009 01:47:48 +0800
Message-ID: <1248025668-25901-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:63625 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZGSRsG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 13:48:06 -0400
Received: by pxi31 with SMTP id 31so55109pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 10:48:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently e4defrag relies on the EXT4_IOC_MOVE_EXT ioctl to perform online
defragmentation. However, this iotcl kernel patch is not available before
2.6.30-rc1. e4defrag shall fail without obvious reasons on systems running
older kernels. The patch adds more detailed error message addressing this
issue and prompts users with the minimal kernel version that is needed to
run e4defrag.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/e4defrag.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c25514a..f1c3008 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1553,7 +1553,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 			if (mode_flag & DETAIL) {
 				printf("\n");
 				PRINT_ERR_MSG_WITH_ERRNO(
-						"Failed to defrag");
+					"Failed to defrag with "
+					"EXT4_IOC_MOVE_EXT ioctl");
+				if (errno == ENOTTY)
+					printf("\tAt least 2.6.31-rc1 of"
+						" vallina kernel is required\n");
 			} else {
 				printf("\t[ NG ]\n");
 			}
-- 
1.6.2.GIT

