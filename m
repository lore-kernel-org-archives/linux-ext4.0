From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: If resize2fs fails, tell the user to run e2fsck
Date: Fri, 10 Jul 2009 14:07:47 -0400
Message-ID: <1247249267-25715-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47211 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZGJSHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 14:07:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the resize operation fails in the middle of the operation, mark the
filesystem as needing to be checked, and tell the user that they
should run e2fsck -fy on the device.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 2dae161..990a967 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -455,7 +455,12 @@ int main (int argc, char ** argv)
 	if (retval) {
 		com_err(program_name, retval, _("while trying to resize %s"),
 			device_name);
-		ext2fs_close (fs);
+		fprintf(stderr,
+			_("Please run 'e2fsck -fy %s' to fix the filesystem\n"
+			  "after the aborted resize operation"), device_name);
+		fs->super->s_state |= EXT2_ERROR_FS;
+		ext2fs_mark_super_dirty(fs);
+		ext2fs_close(fs);
 		exit(1);
 	}
 	printf(_("The filesystem on %s is now %u blocks long.\n\n"),
-- 
1.6.3.2.1.gb9f7d.dirty

