From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext3: don't clear orphan list on ro mount with errors
Date: Mon, 27 Aug 2012 14:30:40 -0500
Message-ID: <503BCAE0.7010900@redhat.com>
References: <503BC685.7090707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2H0Tan (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Aug 2012 15:30:43 -0400
In-Reply-To: <503BC685.7090707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we have a filesystem with an orphan inode list *and* in error
state, things behave differently if:

1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
   happily (barring other significant problems)

vs.

2) mount is done first, then e2fsck -p: due to the orphan inode
   list removal, more errors are found and e2fsck exits with
   UNEXPECTED INCONSISTENCY.

The 2nd case above, on the root filesystem, has the tendency to halt
the boot process, which is unfortunate.

The situation can be improved by not clearing the orphan
inode list when the fs is mounted readonly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index ff9bcdc..485b4fa 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1490,10 +1490,12 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 	}
 
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
-		if (es->s_last_orphan)
+		/* don't clear list on RO mount w/ errors */
+		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
 			jbd_debug(1, "Errors on filesystem, "
 				  "clearing orphan list.\n");
-		es->s_last_orphan = 0;
+			es->s_last_orphan = 0;
+		}
 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
 		return;
 	}

