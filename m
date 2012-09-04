From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] ext3: Replace 0 with NULL for pointer in super.c file
Date: Tue,  4 Sep 2012 13:42:00 +0530
Message-ID: <1346746320-32582-1-git-send-email-sachin.kamat@linaro.org>
Cc: jack@suse.cz, akpm@linux-foundation.org, sachin.kamat@linaro.org,
	patches@linaro.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56080 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2IDIO6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 04:14:58 -0400
Received: by pbbrr13 with SMTP id rr13so9110442pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 01:14:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes the following sparse warning:
fs/ext3/super.c:983:45: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/ext3/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf1fb17..0e17142 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -980,7 +980,7 @@ static int parse_options (char *options, struct super_block *sb,
 		 * Initialize args struct so we know whether arg was
 		 * found; some options take optional arguments.
 		 */
-		args[0].to = args[0].from = 0;
+		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
-- 
1.7.4.1

