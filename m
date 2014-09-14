From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: Explicitly inform user about orphan list cleanup.
Date: Sun, 14 Sep 2014 16:38:57 +0400
Message-ID: <1410698337-27454-2-git-send-email-dmonakhov@openvz.org>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27250 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaINMjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2014 08:39:10 -0400
In-Reply-To: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Production fs likely compiled/mounted w/o jbd debugging, so orphan list clearing
will be silent.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2632017..028935f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2191,7 +2191,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		/* don't clear list on RO mount w/ errors */
 		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
-			jbd_debug(1, "Errors on filesystem, "
+			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
 				  "clearing orphan list.\n");
 			es->s_last_orphan = 0;
 		}
-- 
1.7.1

