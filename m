From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix Null dereference.
Date: Mon,  4 Feb 2008 12:45:07 +0530
Message-ID: <1202109307-30671-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, bunk@kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41367 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827AbYBDHPO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 02:15:14 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m147F9eA019993
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 12:45:09 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m147F8xH741496
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 12:45:08 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m147F8iw019711
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 07:15:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Repoted by Adrian Bunk <bunk@kernel.org>:

The Coverity checker spotted the following NULL dereference:

static int ext4_mb_mark_diskspace_used
{
	...
	if (!bitmap_bh)
		goto out_err;
	...
out_err:
	sb->s_dirt = 1;
	put_bh(bitmap_bh);
	...

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 76e5fed..06d1f52 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3069,7 +3069,7 @@ static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 
 out_err:
 	sb->s_dirt = 1;
-	put_bh(bitmap_bh);
+	brelse(bitmap_bh);
 	return err;
 }
 
-- 
1.5.4.rc3.24.gb53139-dirty
