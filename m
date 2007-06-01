From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks.
Date: Fri, 1 Jun 2007 10:52:34 -0500
Message-ID: <20070601105234.4be40028@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40651 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbXFAPxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2007 11:53:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l51Fr54u013686
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jun 2007 11:53:05 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l51Fr5x9552042
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jun 2007 11:53:05 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l51Fr524007908
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jun 2007 11:53:05 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l51Fr4pI007897
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jun 2007 11:53:05 -0400
Received: from rx8 (rx8.austin.ibm.com [9.41.41.30])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l51Fr47s045318
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jun 2007 10:53:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
than 32bit block sizes during mount time.  This ensure proper record
lenth when writing to the journal.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

--- .pc/ext4-set_64-bit_JBD_incompat.patch/fs/ext4/super.c	2007-05-31 22:25:21.843984697 -0500
+++ fs/ext4/super.c	2007-05-31 22:26:14.913670672 -0500
@@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
 		goto failed_mount3;
 	}
 
+        /* 
+	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
+	 * with more that 32-bit block counts
+	 */
+	if(es->s_blocks_count_hi)
+		if (!jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0, 
+					       JBD2_FEATURE_INCOMPAT_64BIT)){
+			printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
+			goto failed_mount4;
+		}
+
 	/* We have now updated the journal if required, so we can
 	 * validate the data journaling mode. */
 	switch (test_opt(sb, DATA_FLAGS)) {


Thanks
-JRS
