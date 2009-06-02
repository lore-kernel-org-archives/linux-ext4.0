From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs] filefrag: accept positive ioctl return value
Date: Tue,  2 Jun 2009 20:12:41 +0800
Message-ID: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:54097 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZFBMNB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2009 08:13:01 -0400
Received: by pzk7 with SMTP id 7so6608940pzk.33
        for <linux-ext4@vger.kernel.org>; Tue, 02 Jun 2009 05:13:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some ioctl() returns non-negative value on success. filefrag_fiemap should
treat positive ioctl() return values as success.
This can be triggered by running filefrag on btrfs partitions.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/filefrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 80ac05c..3dc966a 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -208,7 +208,7 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 				fiemap_incompat_printed = 1;
 			}
 		}
-		if (rc)
+		if (rc < 0)
 			return rc;
 
 		if (!verbose) {
-- 
1.6.2.GIT

