From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/25] e2fsck: handle null fs in print_pathname()
Date: Fri, 16 Sep 2011 15:49:22 -0500
Message-ID: <1316206180-6375-8-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46737 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

testing fs for NULL in expand_percent_expression():

	e2fsck_ctx = fs ? (e2fsck_t) fs->priv_data : NULL;

implies that fs could be NULL, but it's passed to print_pathname()
which defererences it without further testing.

So make this safe by returning "???" for a nul fs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/message.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 565c3cd..f178321 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -203,8 +203,9 @@ static void print_pathname(ext2_filsys fs, ext2_ino_t dir, ext2_ino_t ino)
 		return;
 	}
 
-	retval = ext2fs_get_pathname(fs, dir, ino, &path);
-	if (retval)
+	if (fs)
+		retval = ext2fs_get_pathname(fs, dir, ino, &path);
+	if (!fs || retval)
 		fputs("???", stdout);
 	else {
 		safe_print(path, -1);
-- 
1.7.4.1

