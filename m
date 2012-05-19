From: Jeffrin Jose <ahiliation@yahoo.co.in>
Subject: [PATCH]fs:ext4:fixed space issue related to * operator.
Date: Sat, 19 May 2012 21:27:20 +0530
Message-ID: <1337443040-3609-1-git-send-email-ahiliation@yahoo.co.in>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	ahiliation@yahoo.co.in
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm32-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.55]:20435 "HELO
	nm32-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750915Ab2ESQAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2012 12:00:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixed coding style issue relating to * operator found
by checkpath.pl tool in fs/ext4/fsync.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 fs/ext4/fsync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index bb6c7d8..b06e330 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -34,7 +34,7 @@
 
 #include <trace/events/ext4.h>
 
-static void dump_completed_IO(struct inode * inode)
+static void dump_completed_IO(struct inode *inode)
 {
 #ifdef	EXT4FS_DEBUG
 	struct list_head *cur, *before, *after;
-- 
1.7.10

