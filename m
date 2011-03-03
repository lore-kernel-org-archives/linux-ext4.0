From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext4: Use sing thread to perform DIO unwritten convertion
Date: Thu, 03 Mar 2011 11:29:54 -0800
Message-ID: <1299180594.2826.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38591 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab1CCT35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 14:29:57 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p23JIL2V014578
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 12:18:21 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p23JTuOI116408
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 12:29:56 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p23JTujG032123
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 12:29:56 -0700
Received: from [9.48.56.176] (sig-9-48-56-176.mts.ibm.com [9.48.56.176])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p23JTuvL032117
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 12:29:56 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While running ext4 testing on multiple core, we found there are per cpu ext4-dio-unwritten threads processing
conversion from unwritten extents to written for IOs completed from async direct IO patch.
Per filesystem is enough, we don't need per cpu threads to work on conversion.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f6a318f..c76a6a5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3509,7 +3509,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	percpu_counter_set(&sbi->s_dirtyblocks_counter, 0);
 
 no_journal:
-	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
+	EXT4_SB(sb)->dio_unwritten_wq = create_singlethread_workqueue("ext4-dio-unwritten");
 	if (!EXT4_SB(sb)->dio_unwritten_wq) {
 		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
 		goto failed_mount_wq;
-- 
1.6.3.3



