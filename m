From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't overwrite allocation_context ac_status
Date: Wed, 10 Dec 2008 18:37:43 +0530
Message-ID: <1228914463-12716-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:49767 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYLJNlr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 08:41:47 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id mBADfBep4247686
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2008 00:41:11 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBADYCbw059490
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2008 00:34:14 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBADVRPV003561
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2008 00:34:12 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can call ext4_mb_check_limits even after successfull
allocation. Make sure we don't overwrite ac_status.
This fix the below lockdep warning

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-rc6-autokern1 #1
---------------------------------------------
fsstress/11948 is trying to acquire lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278
.....

stack backtrace:
.....
 [<c04db974>] ext4_mb_regular_allocator+0xbb5/0xd44
.....

but task is already holding lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 22d31c3..8ce2f19 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1403,6 +1403,8 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
 	struct ext4_free_extent ex;
 	int max;
 
+	if (ac->ac_status == AC_STATUS_FOUND)
+		return;
 	/*
 	 * We don't want to scan for a whole year
 	 */
-- 
1.6.1.rc1.56.g2dd62

