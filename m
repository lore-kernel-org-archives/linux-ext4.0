From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: explicit mount options parsing cleanup
Date: Fri,  9 Oct 2015 13:09:58 +0400
Message-ID: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34083 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbbJIJyw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Oct 2015 05:54:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently MOPT_EXPLICIT treated as EXPLICIT_DELALLOC which may be changed
in future. Let's fix it now.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7ef3fa5..e91f6d4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1503,8 +1503,12 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return -1;
 	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
 		return -1;
-	if (m->flags & MOPT_EXPLICIT)
-		set_opt2(sb, EXPLICIT_DELALLOC);
+	if (m->flags & MOPT_EXPLICIT) {
+		if (m->mount_opt & EXT4_MOUNT_DELALLOC) {
+			set_opt2(sb, EXPLICIT_DELALLOC);
+		} else
+			return -1;
+	}
 	if (m->flags & MOPT_CLEAR_ERR)
 		clear_opt(sb, ERRORS_MASK);
 	if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-- 
1.7.1

