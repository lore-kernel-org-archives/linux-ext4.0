From: root <jeremy.cochoy@gmail.com>
Subject: [PATCH] fix ext2 parse_options printk
Date: Mon,  7 Dec 2009 15:01:01 +0100
Message-ID: <1260194461-8937-2-git-send-email-jeremy.cochoy@gmail.com>
References: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
Cc: linux-ext4@vger.kernel.org, Manish Katiyar <mkatiyar@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Corentin Chary <corentin.chary@gmail.com>,
	Jeremy Cochoy <jeremy.cochoy@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38225 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094AbZLGNyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 08:54:19 -0500
In-Reply-To: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jeremy Cochoy <jeremy.cochoy@gmail.com>

Signed-off-by: Jeremy Cochoy <jeremy.cochoy@gmail.com>
---
 fs/ext2/super.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..f28618f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -505,7 +505,7 @@ static int parse_options (char * options,
 #else
 		case Opt_user_xattr:
 		case Opt_nouser_xattr:
-			printk("EXT2 (no)user_xattr options not supported\n");
+			printk(KERN_NOTICE "EXT2 (no)user_xattr options not supported\n");
 			break;
 #endif
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
@@ -518,14 +518,14 @@ static int parse_options (char * options,
 #else
 		case Opt_acl:
 		case Opt_noacl:
-			printk("EXT2 (no)acl options not supported\n");
+			printk(KERN_NOTICE "EXT2 (no)acl options not supported\n");
 			break;
 #endif
 		case Opt_xip:
 #ifdef CONFIG_EXT2_FS_XIP
 			set_opt (sbi->s_mount_opt, XIP);
 #else
-			printk("EXT2 xip option not supported\n");
+			printk(KERN_NOTICE "EXT2 xip option not supported\n");
 #endif
 			break;
 
@@ -550,11 +550,11 @@ static int parse_options (char * options,
 
 		case Opt_reservation:
 			set_opt(sbi->s_mount_opt, RESERVATION);
-			printk("reservations ON\n");
+			printk(KERN_INFO "reservations ON\n");
 			break;
 		case Opt_noreservation:
 			clear_opt(sbi->s_mount_opt, RESERVATION);
-			printk("reservations OFF\n");
+			printk(KERN_INFO "reservations OFF\n");
 			break;
 		case Opt_ignore:
 			break;
-- 
1.5.6.5

