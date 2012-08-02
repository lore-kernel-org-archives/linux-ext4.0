From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] ext4: Replace plain integer with NULL in super.c file
Date: Thu,  2 Aug 2012 15:59:35 +0530
Message-ID: <1343903375-27506-1-git-send-email-sachin.kamat@linaro.org>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, sachin.kamat@linaro.org,
	patches@linaro.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42994 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2HBKau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2012 06:30:50 -0400
Received: by yenl2 with SMTP id l2so8500522yen.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2012 03:30:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes the following sparse warning:
fs/ext4/super.c:1672:45: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d76ec82..1b000a6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1669,7 +1669,7 @@ static int parse_options(char *options, struct super_block *sb,
 		 * Initialize args struct so we know whether arg was
 		 * found; some options take optional arguments.
 		 */
-		args[0].to = args[0].from = 0;
+		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		if (handle_mount_opt(sb, p, token, args, journal_devnum,
 				     journal_ioprio, is_remount) < 0)
-- 
1.7.4.1

