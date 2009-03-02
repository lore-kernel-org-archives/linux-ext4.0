From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs] Allow tune2fs -I if only one group per flex
Date: Mon,  2 Mar 2009 16:29:20 +0800
Message-ID: <1235982560-7725-1-git-send-email-bergwolf@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:14055 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCBI33 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 03:29:29 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2756646tib.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2009 00:29:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This can be caused by tune2fs -O flex_bg.
And tune2fs -I should work okay for such partitions.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/tune2fs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 887a702..ee982e5 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1715,7 +1715,8 @@ retry_open:
 			exit(1);
 		}
 		if (fs->super->s_feature_incompat &
-		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		    EXT4_FEATURE_INCOMPAT_FLEX_BG &&
+		    fs->super->s_log_groups_per_flex) {
 			fputs(_("Changing the inode size not supported for "
 				"filesystems with the flex_bg\n"
 				"feature enabled.\n"),
-- 
1.6.1.3

