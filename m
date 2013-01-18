From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ext4: remove useless assignment in dx_probe()
Date: Fri, 18 Jan 2013 16:01:13 +0800
Message-ID: <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55368 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARIBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 03:01:25 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 18 Jan 2013 17:55:18 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 948A82BB004E
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0I81Ilv60489782
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0I81Icf031982
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100
In-Reply-To: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No body care about the effect of this assignment.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b3717a3..e35ea3d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -714,7 +714,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 				*err = ERR_BAD_DX_DIR;
 			goto fail2;
 		}
-		at = entries = ((struct dx_node *) bh->b_data)->entries;
+		entries = ((struct dx_node *) bh->b_data)->entries;
 
 		if (!buffer_verified(bh) &&
 		    !ext4_dx_csum_verify(dir,
-- 
1.7.9.5

