From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] ext3: Fix compilation of super.c
Date: Thu, 23 Oct 2008 21:50:46 +0200
Message-ID: <200810232150.47692.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYJWTqD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2008 15:46:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Rafael J. Wysocki <rjw@sisk.pl>

ext3: Fix compilation of super.c

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/ext3/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -2836,7 +2836,7 @@ static int ext3_quota_on(struct super_bl
 		err = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 		if (err) {
-			path_put(&nd.path);
+			path_put(&path);
 			return err;
 		}
 	}
