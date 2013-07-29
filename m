From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove unused ac_ex_scanned
Date: Mon, 29 Jul 2013 18:14:03 -0500
Message-ID: <51F6F73B.3050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab3G2XOE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 19:14:04 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6TNE496001435
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 19:14:04 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r6TNE3Ae022583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 19:14:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When looking at a bug report with:

> kernel: EXT4-fs: 0 scanned, 0 found

I thought wow, 0 scanned, that's odd?  But it's not odd; it's printing
a variable that is initialized to 0 and never touched again.

It's never been used since the original merge, so I don't really even
know what the original intent was, either.

If anyone knows how to hook it up, speak now via patch, otherwise just
yank it so it's not making a confusing situation more confusing in
kernel logs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4bbbf13..3aee266 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3983,8 +3983,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			(unsigned long)ac->ac_b_ex.fe_len,
 			(unsigned long)ac->ac_b_ex.fe_logical,
 			(int)ac->ac_criteria);
-	ext4_msg(ac->ac_sb, KERN_ERR, "%lu scanned, %d found",
-		 ac->ac_ex_scanned, ac->ac_found);
+	ext4_msg(ac->ac_sb, KERN_ERR, "%d found", ac->ac_found);
 	ext4_msg(ac->ac_sb, KERN_ERR, "groups: ");
 	ngroups = ext4_get_groups_count(sb);
 	for (i = 0; i < ngroups; i++) {
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 08481ee..72db0a0 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -175,8 +175,6 @@ struct ext4_allocation_context {
 	/* copy of the best found extent taken before preallocation efforts */
 	struct ext4_free_extent ac_f_ex;
 
-	/* number of iterations done. we have to track to limit searching */
-	unsigned long ac_ex_scanned;
 	__u16 ac_groups_scanned;
 	__u16 ac_found;
 	__u16 ac_tail;

