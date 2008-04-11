From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] check return of ext4_orphan_get properly
Date: Fri, 11 Apr 2008 15:32:08 -0400
Message-ID: <20080411193208.GB2757@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbYDKTsN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 15:48:13 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Hit a panic while running fsfuzzer, seems we are improperly checking the return
of ext4_orphan_get.  This patch fixes the problem, thank you

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -1652,8 +1652,8 @@ static void ext4_orphan_cleanup (struct 
 	while (es->s_last_orphan) {
 		struct inode *inode;
 
-		if (!(inode =
-		      ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan)))) {
+		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
 			break;
 		}
