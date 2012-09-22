From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 21/21 v5] mke2fs: enable inline_data feature on ext4dev filesystem
Date: Sat, 22 Sep 2012 12:01:09 +0800
Message-ID: <1348286469-31690-22-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2IVDvi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:38 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

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

