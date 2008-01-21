From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix the BUG_ON in jbd2_journal_commit_transaction
Date: Mon, 21 Jan 2008 11:26:06 +0530
Message-ID: <1200894966-10130-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:44541 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYAUF4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2008 00:56:21 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0L5v6MF011420
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2008 16:57:06 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0L5xtdT141562
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2008 16:59:55 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0L5uHSc019682
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2008 16:56:17 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

kunmap_atomic was passed the wrong argument.

 [  394.122353] Call Trace:
 [  394.128052]  [<c01051fa>] show_trace_log_lvl+0x1a/0x30
 [  394.138643]  [<c01052b9>] show_stack_log_lvl+0xa9/0xd0
 [  394.149239]  [<c01053aa>] show_registers+0xca/0x1c0
 [  394.159310]  [<c01055b6>] die+0x116/0x220
 [  394.167638]  [<c03ffc61>] do_trap+0x91/0xc0
 [  394.176321]  [<c01059a9>] do_invalid_op+0x89/0xa0
 [  394.185996]  [<c03ffa2a>] error_code+0x72/0x78
 [  394.195208]  [<c011dcff>] kmap_atomic+0x1f/0x30
 [  394.204613]  [<c01fe63e>] jbd2_journal_commit_transaction+0x132e/0x15a0
 [  394.218206]  [<c0202e51>] kjournald2+0xd1/0x3b0
 [  394.227590]  [<c013d092>] kthread+0x42/0x70
 [  394.236298]  [<c0104df3>] kernel_thread_helper+0x7/0x14

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/jbd2/commit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2a081b7..2107820 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -359,7 +359,7 @@ static inline __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 	addr = kmap_atomic(page, KM_USER0);
 	checksum = crc32_be(crc32_sum,
 		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
-	kunmap_atomic(page, KM_USER0);
+	kunmap_atomic(addr, KM_USER0);
 
 	return checksum;
 }
-- 
1.5.4.rc3.24.gb53139-dirty
