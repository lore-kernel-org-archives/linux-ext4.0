From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/5] mke2fs: add inline data descripton in man page
Date: Sun, 18 Dec 2011 22:44:41 +0800
Message-ID: <1324219484-22443-3-git-send-email-wenqing.lz@taobao.com>
References: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1LROoU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:44:20 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so7092185iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 06:44:20 -0800 (PST)
In-Reply-To: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add inline data description in man page

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 8e78249..1beefb0 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -542,6 +542,9 @@ option).
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
 .TP
+.B inline_data
+Allow small files to be stored in the inode
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
-- 
1.7.4.1

