From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] resize2fs: allow resizing flex_bg && !resize_inode file systems
Date: Sat, 29 Dec 2012 03:55:27 -0500
Message-ID: <1356771328-18196-6-git-send-email-tytso@mit.edu>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40813 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2L2I5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:57:01 -0500
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the bug fixes from the last two commits, resize2fs can now fully
support off-line resizing of file systems with flex_bg even if the
resize_inode feature is not present; so we no longer need to disallow
this combination.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 876dbaa..711e375 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -438,28 +438,6 @@ int main (int argc, char ** argv)
 				device_name);
 			exit(1);
 		}
-		/*
-		 * XXXX The combination of flex_bg and !resize_inode
-		 * causes major problems for resize2fs, since when the
-		 * group descriptors grow in size this can potentially
-		 * require multiple inode tables to be moved aside to
-		 * make room, and resize2fs chokes rather badly in
-		 * this scenario.  It's a rare combination, except
-		 * when a filesystem is expanded more than a certain
-		 * size, so for now, we'll just prohibit that
-		 * combination.  This is something we should fix
-		 * eventually, though.
-		 */
-		if ((fs->super->s_feature_incompat &
-		     EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
-		    !(fs->super->s_feature_compat &
-		      EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
-			com_err(program_name, 0, _("%s: The combination of "
-				"flex_bg and\n\t!resize_inode features "
-				"is not supported by resize2fs.\n"),
-				device_name);
-			exit(1);
-		}
 		printf(_("Resizing the filesystem on "
 			 "%s to %llu (%dk) blocks.\n"),
 		       device_name, new_size, fs->blocksize / 1024);
-- 
1.7.12.rc0.22.gcdd159b

