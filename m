From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH]ext4: Fix ext4_mb_init_cache return error
Date: Sun, 01 Jun 2008 14:02:26 -0700
Message-ID: <1212354146.4368.3.camel@localhost.localdomain>
References: <483FE24F.50105@rs.jp.nec.com>
	 <1212173573.8596.84.camel@BVR-FS.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Shen Feng <shen@cn.fujitsu.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Theodore Tso <tytso@mit.edu>, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48636 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYFAVCd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 17:02:33 -0400
In-Reply-To: <1212173573.8596.84.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix ext4_mb_init_cache return error

From: Mingming Cao <cmm@us.ibm.com>

ext4_mb_init_cache() incorrectly always return EIO on success. This
causes the caller of ext4_mb_init_cache() fail when it checks
 the return value.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc4/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/mballoc.c	2008-06-01 12:55:19.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/mballoc.c	2008-06-01 12:55:23.000000000 -0700
@@ -798,7 +798,7 @@ static int ext4_mb_init_cache(struct pag
 	for (i = 0; i < groups_per_page && bh[i]; i++)
 		wait_on_buffer(bh[i]);
 
-	err = -EIO;
+	err = 0;
 	for (i = 0; i < groups_per_page && bh[i]; i++)
 		if (!buffer_uptodate(bh[i]))
 			goto out;


