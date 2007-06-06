From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger than
 32-bit blocks
Date: Tue, 5 Jun 2007 23:09:12 -0500
Message-ID: <20070605230912.1d6c4377@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38899 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXFFEJ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jun 2007 00:09:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5636qIM012988
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 23:06:52 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5649P65559714
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 00:09:25 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5649PX5031706
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 00:09:25 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5649PLN031703
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jun 2007 00:09:25 -0400
Received: from gara (sig-9-48-59-140.mts.ibm.com [9.48.59.140])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l5649OJP041930
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 23:09:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
than 32bit block sizes during mount time.  This ensure proper record
lenth when writing to the journal.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.22-rc3/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
+++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-05 21:14:33.974854532 -0500
@@ -1824,6 +1824,13 @@ static int ext4_fill_super (struct super
 		goto failed_mount3;
 	}
 
+	if (ext4_blocks_count(es) > 0xffffffff &&
+	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
+				       JBD2_FEATURE_INCOMPAT_64BIT)) {
+		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
+		goto failed_mount4;
+	}
+
 	/* We have now updated the journal if required, so we can
 	 * validate the data journaling mode. */
 	switch (test_opt(sb, DATA_FLAGS)) {


-JRS
