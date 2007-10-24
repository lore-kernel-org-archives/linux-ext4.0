From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix mballoc BUG when running compilebench
Date: Wed, 24 Oct 2007 22:17:18 +0530
Message-ID: <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45945 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764699AbXJXQs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:48:28 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OGloh1012744
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:50 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OGpQag265132
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:51:26 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OGlZ3Y025703
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:35 +1000
In-Reply-To: <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This fix the mballoc bug when running compile bench.
Instead of using direct division even though the arguments
are 32 bits we retain do_div. This would be needed if we
move to 64 bit logical block number.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fe7cf9e..8467b3d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3089,13 +3089,14 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		}
 	}
 	if (wind == 0) {
+		__u64 tstart;
 		/* file is quite large, we now preallocate with
 		 * the biggest configured window with regart to
 		 * logical offset */
 		wind = sbi->s_mb_prealloc_table[i - 1];
-		start = ac->ac_o_ex.fe_logical;
-		do_div(start, wind);
-		start = start * wind;
+		tstart = ac->ac_o_ex.fe_logical;
+		do_div(tstart, wind);
+		start = tstart * wind;
 	}
 	size = wind;
 	orig_size = size;
-- 
1.5.3.4.319.gdd817-dirty
