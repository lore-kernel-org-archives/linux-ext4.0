From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove unaligned AIO warning printk
Date: Wed, 21 Nov 2012 11:05:52 -0600
Message-ID: <50AD09F0.6090706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2KURF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 12:05:57 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qALH5vG6011093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2012 12:05:57 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id qALH5rQT026245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2012 12:05:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Although I put this in, I now think it was a bad decision.
For most users, there is very little to be done in this case.  They
get the message, once per day, with no real context or proposed action.
TBH, it generates support calls when it probably does not need to;
the message sounds more dire than the situation really is.

Just nuke it.  Normal investigation via blktrace or whatnot can
reveal poor IO patterns if bad performance is encountered.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bf3966b..6c6b741 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -107,14 +107,6 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	/* Unaligned direct AIO must be serialized; see comment above */
 	if (unaligned_aio) {
-		static unsigned long unaligned_warn_time;
