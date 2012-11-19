From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h in super.c
Date: Mon, 19 Nov 2012 16:47:22 +0530
Message-ID: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, sachin.kamat@linaro.org,
	patches@linaro.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2KSLXa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 06:23:30 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so386379pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 03:23:30 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_extents.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ad6cd8a..c8a6138 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -50,7 +50,6 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
-#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
-- 
1.7.4.1

