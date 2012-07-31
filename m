From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 03/36 v4] mke2fs: add inline_data feature in mke2fs's manpage
Date: Tue, 31 Jul 2012 19:47:56 +0800
Message-ID: <1343735309-30579-4-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLjx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:53 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:52 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Update mke2fs's manpage.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 6d443a2..bfe6c94 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -551,6 +551,9 @@ option).
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
 .TP
+.B inline_data
+Allow data to be stored in inode
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
-- 
1.7.4.1

