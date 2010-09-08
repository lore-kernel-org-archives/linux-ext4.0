From: Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsck: Improve error message when device name misspelled
Date: Wed,  8 Sep 2010 16:12:08 +0200
Message-ID: <1283955128-6517-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0IHOM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Sep 2010 10:12:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a device name is misspelled, we output the full text about specifying
alternate superblock. This is slightly misleading because when the device
cannot be open because of ENOENT, this certainly won't help. So just print
that device does not exist and exit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/unix.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

  Ted, would you please include this minor improvement? One of our users
complained about it. Thanks.

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6cb2214..7eb269c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1109,6 +1109,8 @@ failure:
 		else if (retval == EBUSY)
 			printf(_("Filesystem mounted or opened exclusively "
 				 "by another program?\n"));
+		else if (retval == ENOENT)
+			printf(_("Possibly non-existent device?\n"));
 #ifdef EROFS
 		else if (retval == EROFS)
 			printf(_("Disk write-protected; use the -n option "
-- 
1.6.4.2

