From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mballoc: allocate stripe-multiple IOs on stripe boundaries
Date: Wed, 14 Jul 2010 16:10:23 -0500
Message-ID: <4C3E27BF.2000005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0GNVK2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jul 2010 17:10:28 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6ELAReg015425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 17:10:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason, today mballoc only allocates IOs which are exactly
stripe-sized on a stripe boundary.  If you have a multiple (say, a
128k IO on a 64k stripe) you may end up unaligned.

It seems to me that a simple change to align stripe-multiple IOs
on stripe boundaries would be a very good idea, unless this breaks
some other mballoc heuristic for some reason...

Reported-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..f64a439 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1821,8 +1821,7 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 
 /*
  * This is a special case for storages like raid5
- * we try to find stripe-aligned chunks for stripe-size requests
- * XXX should do so at least for multiples of stripe size as well
+ * we try to find stripe-aligned chunks for stripe-size-multiple requests
  */
 static noinline_for_stack
 void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
@@ -2094,8 +2093,8 @@ repeat:
 			ac->ac_groups_scanned++;
 			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
-			else if (cr == 1 &&
-					ac->ac_g_ex.fe_len == sbi->s_stripe)
+			else if (cr == 1 && sbi->s_stripe &&
+					!(ac->ac_g_ex.fe_len % sbi->s_stripe))
 				ext4_mb_scan_aligned(ac, &e4b);
 			else
 				ext4_mb_complex_scan_group(ac, &e4b);


