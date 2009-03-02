From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs] Allow clearing flex_bg if only one group per flex
Date: Mon,  2 Mar 2009 16:28:44 +0800
Message-ID: <1235982524-7673-1-git-send-email-bergwolf@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:14055 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZCBI3E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 03:29:04 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2756646tib.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2009 00:29:01 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This can be caused by tune2fs -O flex_bg. And clearing flex_bg on such
partitions is harmless.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/tune2fs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 887a702..f7373af 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -407,7 +407,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			uuid_generate((unsigned char *) sb->s_hash_seed);
 	}
 
-	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+			    sb->s_log_groups_per_flex) {
 		if (ext2fs_check_desc(fs)) {
 			fputs(_("Clearing the flex_bg flag would "
 				"cause the the filesystem to be\n"
-- 
1.6.1.3

