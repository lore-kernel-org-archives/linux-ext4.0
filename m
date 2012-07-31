From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 34/36 v4] mke2fs: enable inline_data feature on ext4dev filesystem
Date: Tue, 31 Jul 2012 19:48:27 +0800
Message-ID: <1343735309-30579-35-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54597 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2GaLku (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:50 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so5889814ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:49 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now inline_data feature gets stable.  So we enable it on ext4dev filesystem.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.conf.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 178733f..4c5dba7 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -16,7 +16,7 @@
 		inode_size = 256
 	}
 	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,metadata_csum,inline_data,64bit,dir_nlink,extra_isize
 		inode_size = 256
 		options = test_fs=1
 	}
-- 
1.7.4.1

