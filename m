From: Chuck Ebbert <cebbert@redhat.com>
Subject: [patch] ext4: really print the find_group_flex fallback warning
 only once
Date: Mon, 13 Apr 2009 19:03:29 -0400
Message-ID: <20090413190330.754a0dec@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbZDMXFA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Apr 2009 19:05:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: really print the find_group_flex fallback warning only once

Missing braces caused the warning to print more than once.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.27.noarch.orig/fs/ext4/ialloc.c
+++ linux-2.6.27.noarch/fs/ext4/ialloc.c
@@ -705,11 +705,12 @@ struct inode *ext4_new_inode(handle_t *h
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
 			ret2 = find_group_other(sb, dir, &group);
-			if (ret2 == 0 && once)
+			if (ret2 == 0 && once) {
 				once = 0;
 				printk(KERN_NOTICE "ext4: find_group_flex "
 				       "failed, fallback succeeded dir %lu\n",
 				       dir->i_ino);
+			}
 		}
 		goto got_group;
 	}
