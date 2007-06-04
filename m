From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks (take 2).
Date: Mon, 4 Jun 2007 11:32:10 -0500
Message-ID: <20070604113210.1a76934b@gara>
References: <20070601105234.4be40028@rx8>
	<20070601225441.GF5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36853 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbXFDQc6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 12:32:58 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l54GWwbw010134
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jun 2007 12:32:58 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l54GWlUx233660
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jun 2007 10:32:56 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l54GWPsP025665
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jun 2007 10:32:26 -0600
In-Reply-To: <20070601225441.GF5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
than 32bit block sizes during mount time.  This ensure proper record
lenth when writing to the journal.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
 fs/ext4/super.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.22-rc3/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
+++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-04 11:05:11.389126418 -0500
@@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
 		goto failed_mount3;
 	}
 
+        /*
+	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
+	 * with more that 32-bit block counts
+	 */
+	if(es->s_blocks_count_hi &&
+	   !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
+				      JBD2_FEATURE_INCOMPAT_64BIT)){
+		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
+		goto failed_mount4;
+	}
+
 	/* We have now updated the journal if required, so we can
 	 * validate the data journaling mode. */
 	switch (test_opt(sb, DATA_FLAGS)) {


Thanks
-JRS
