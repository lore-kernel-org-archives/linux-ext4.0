From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] ext4: remove unused macro MB_DEFAULT_MAX_GROUPS_TO_SCAN
Date: Fri, 13 Apr 2012 14:30:56 +0800
Message-ID: <1334298657-20408-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38066 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2DMGbI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 02:31:08 -0400
Received: by dake40 with SMTP id e40so3481925dak.11
        for <linux-ext4@vger.kernel.org>; Thu, 12 Apr 2012 23:31:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

remove unused macro MB_DEFAULT_MAX_GROUPS_TO_SCAN

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/mballoc.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index c070618..3ccd889 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -65,11 +65,6 @@ extern u8 mb_enable_debug;
 #define MB_DEFAULT_MIN_TO_SCAN		10
 
 /*
- * How many groups mballoc will scan looking for the best chunk
- */
-#define MB_DEFAULT_MAX_GROUPS_TO_SCAN	5
