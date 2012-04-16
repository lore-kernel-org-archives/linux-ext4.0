From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 03/32] libext2fs: add inline_data feature
Date: Mon, 16 Apr 2012 19:39:38 +0800
Message-ID: <1334576407-4007-4-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DPLd5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:33:57 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:33:57 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag into feautre list.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/e2p/feature.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 19e6f0c..aadc03e 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -87,6 +87,8 @@ static struct feature feature_list[] = {
 			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
 			"flex_bg"},
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INLINE_DATA,
+			"inline_data"},
 	{	0, 0, 0 },
 };
 
-- 
1.7.4.1

