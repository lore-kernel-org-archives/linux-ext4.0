From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V2 1/3] mke2fs: correct help text for option -G of mke2fs
Date: Wed,  4 Jan 2012 19:02:10 +0800
Message-ID: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2ADOwx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 09:52:53 -0500
Received: by iaeh11 with SMTP id h11so32657015iae.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2012 06:52:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The option '-G' is used to pass number of groups in a flex_bg, the
previous help text - 'meta-group-size' - could confuse users with
meta_bg.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 misc/mke2fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..f01d05c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -116,7 +116,7 @@ static void usage(void)
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
 	"[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
 	"[-J journal-options]\n"
-	"\t[-G meta group size] [-N number-of-inodes]\n"
+	"\t[-G flex-group-size] [-N number-of-inodes]\n"
 	"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
 	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
-- 
1.7.5.1

