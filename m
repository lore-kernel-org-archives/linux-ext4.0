From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] remove write-only variables from ext4_ordered_write_end
Date: Thu, 31 Jul 2008 12:57:53 -0500
Message-ID: <4891FD21.2000704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYGaR6Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 13:58:25 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6VHvsS2027561
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:57:54 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VHvswo029121
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:57:54 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m6VHvrwd010460
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:57:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

from & to are unused.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2008-07-31 12:38:45.000000000 -0500
+++ linux-2.6/fs/ext4/inode.c	2008-07-31 12:55:59.181165399 -0500
@@ -1336,12 +1336,8 @@ static int ext4_ordered_write_end(struct
 {
 	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = mapping->host;
-	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
-	to = from + len;
