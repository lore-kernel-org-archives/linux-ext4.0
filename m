From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: start seraching for the right extent from the goal group.
Date: Wed, 30 Apr 2008 16:46:26 +0530
Message-ID: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:55247 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbYD3LY0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Apr 2008 07:24:26 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id m3UBPNEJ2330640
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 21:25:23 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3UBKm8W065060
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 21:20:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3UBGlc5007278
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 21:16:48 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With mballoc we search for the best extent using different
criteria. We should always use the goal group when we are
starting with a new criteria.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2a6c814..9b4cde7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1730,10 +1730,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
-
-	/* searching for the right group start from the goal value specified */
-	group = ac->ac_g_ex.fe_group;
