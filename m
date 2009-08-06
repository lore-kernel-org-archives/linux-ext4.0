From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] filefrag: fix frag count in bmap case
Date: Wed, 05 Aug 2009 21:43:23 -0500
Message-ID: <4A7A434B.9090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZHFCn1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:27 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n762hPmD031426
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 22:43:25 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n762hOMZ031874
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 22:43:25 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n762hNUI032763
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 22:43:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fragmentation count in the bmap case seems to be
off by one:

# echo foo > /mnt/test/bar
# filefrag /mnt/test/bar
/mnt/test/bar: 0 extents found

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index eed2b86..128a391 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -342,6 +342,8 @@ static void frag_report(const char *filename)
 			rc = get_bmap(fd, i, &block);
 			if (block == 0)
 				continue;
+			if (!num_extents)
+				num_extents++;
 			count++;
 			if (last_block && (block != last_block+1) ) {
 				if (verbose)


