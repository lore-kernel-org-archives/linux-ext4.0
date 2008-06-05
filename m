From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Patches for the patchqueue
Date: Thu, 5 Jun 2008 15:23:50 +0530
Message-ID: <20080605095350.GG8942@skywalker>
References: <20080605095032.GE8942@skywalker> <20080605095158.GF8942@skywalker>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FsscpQKzF/jJk6ya"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:37202 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbYFEJ5P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 05:57:15 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m559uJmL011850
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:56:19 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m559sO6W4620308
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:54:24 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m559sfP5002878
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:54:42 +1000
Content-Disposition: inline
In-Reply-To: <20080605095158.GF8942@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--FsscpQKzF/jJk6ya
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="003-delalloc-clear-bh-delay-bit-fix.patch"

vfs: Don't flush delay buffer to disk

From: Mingming Cao <cmm@us.ibm.com>

In block_write_full_page() error case, we need to check the
delayed flag before flush bh to disk when trying to recover from
error.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/fs/buffer.c b/fs/buffer.c
index 2f86ca5..26dddac 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1775,7 +1775,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
 	do {
-		if (buffer_mapped(bh) && buffer_dirty(bh)) {
+		if (buffer_mapped(bh) && buffer_dirty(bh)
+			&& !buffer_delay(bh)) {
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
 		} else {

--FsscpQKzF/jJk6ya--
