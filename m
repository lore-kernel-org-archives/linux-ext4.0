From: hao.bigrat@gmail.com
Subject: [PATCH 2/3] dumpe2fs: add '-s' flags for manual
Date: Sun, 30 Jan 2011 14:28:06 +0800
Message-ID: <1296368886-14046-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@google.com>, Coly Li <bosong.ly@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38265 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1A3G2X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 01:28:23 -0500
Received: by iyj18 with SMTP id 18so3863212iyj.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 22:28:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robing Dong <sanbai@taobao.com>
---
 misc/dumpe2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index c1dfcbd..cf611c9 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -55,6 +55,9 @@ can cause some of dumpe2fs's display to be suspect).
 only display the superblock information and not any of the block
 group descriptor detail information.
 .TP
+.B \-s
+display the statistical information of file system blocks usage.
+.TP
 .B \-i
 display the filesystem data from an image file created by 
 .BR e2image ,
-- 
1.7.3.5

