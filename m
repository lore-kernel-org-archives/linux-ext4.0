From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: simplify some logic in ext4_mb_normalize_request
Date: Sun, 16 Aug 2009 14:24:32 -0500
Message-ID: <4A885CF0.60901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZHPTYc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Aug 2009 15:24:32 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7GJOXbn014533
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:24:33 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7GJOXNT031184
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:24:33 -0400
Received: from Liberator.lan (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7GJOWqI006557
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:24:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While reading through some of the mballoc code it seems that a couple
spots in the size normalization function could be streamlined.

The test for non-overlapping PAs can be or'd for the start & end
conditions, and the tests for adjacent PAs can be else-if'd - 
it's essentially independently testing:

	if (A + B <= C)
		...
	if (A > C)
		...

These cannot both be true so it seems like the else-if might
be slightly more efficient and/or informative.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 mballoc.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2741b11..992ec20 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3171,23 +3171,18 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		BUG_ON(!(ac->ac_o_ex.fe_logical >= pa_end ||
 			ac->ac_o_ex.fe_logical < pa->pa_lstart));
 
-		/* skip PA normalized request doesn't overlap with */
-		if (pa->pa_lstart >= end) {
-			spin_unlock(&pa->pa_lock);
-			continue;
-		}
-		if (pa_end <= start) {
+		/* skip PAs this normalized request doesn't overlap with */
+		if (pa->pa_lstart >= end || pa_end <= start) {
 			spin_unlock(&pa->pa_lock);
 			continue;
 		}
 		BUG_ON(pa->pa_lstart <= start && pa_end >= end);
 
+		/* adjust start or end to be adjacent to this pa */
 		if (pa_end <= ac->ac_o_ex.fe_logical) {
 			BUG_ON(pa_end < start);
 			start = pa_end;
-		}
