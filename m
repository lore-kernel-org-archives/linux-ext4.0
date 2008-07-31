From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] missing journal_stop in ext4_da_write_begin error case
Date: Thu, 31 Jul 2008 12:23:51 -0500
Message-ID: <4891F527.4060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYGaRYK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 13:24:10 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6VHNqjr016362
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:23:52 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VHNqHh005680
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:23:52 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m6VHNp0K014864
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:23:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_da_write_begin needs to call journal_stop before returning,
if the page allocation fails.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2008-07-29 17:18:26.000000000 -0500
+++ linux-2.6/fs/ext4/inode.c	2008-07-31 12:21:03.866229084 -0500
@@ -2280,8 +2280,11 @@ retry:
 	}
 
 	page = __grab_cache_page(mapping, index);
-	if (!page)
-		return -ENOMEM;
+	if (!page) {
+		ext4_journal_stop(handle);
+		ret = -ENOMEM;
+		goto out;
+	}
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,

