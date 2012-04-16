From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] debugfs: cleanup in do_show_debugfs_params
Date: Mon, 16 Apr 2012 21:41:26 +0800
Message-ID: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54921 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2DPNfD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 09:35:03 -0400
Received: by dake40 with SMTP id e40so6930244dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 06:35:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove 'out' variable and replace fprintf with printf.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 590468d..99281ac 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1973,12 +1973,10 @@ void do_rmdir(int argc, char *argv[])
 void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
 			    char *argv[] EXT2FS_ATTR((unused)))
 {
-	FILE *out = stdout;
