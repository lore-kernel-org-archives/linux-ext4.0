From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2] add '-s' flags for dumpe2fs manual
Date: Tue, 25 Jan 2011 14:02:48 +0800
Message-ID: <1295935368-2516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1AYGC4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jan 2011 01:02:56 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so4744320iyj.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 22:02:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Singed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/dumpe2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index c1dfcbd..c48acc0 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -55,6 +55,9 @@ can cause some of dumpe2fs's display to be suspect).
 only display the superblock information and not any of the block
 group descriptor detail information.
 .TP
+.B \-s
+display the block usage information.
+.TP
 .B \-i
 display the filesystem data from an image file created by 
 .BR e2image ,
-- 
1.7.3.5

