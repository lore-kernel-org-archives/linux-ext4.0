From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fielfrag: fix it so it works in the bmap fallback case.
Date: Wed, 15 Jul 2009 15:22:55 -0500
Message-ID: <4A5E3A9F.1040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57719 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZGOUW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 16:22:57 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6FKMvvI003012
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:22:57 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6FKMua4025054
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:22:57 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6FKMtMe026236
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:22:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like some debugging crept in?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 702cb8d..be57349 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -95,8 +95,6 @@ static int get_bmap(int fd, unsigned long block, unsigned long *phy_blk)
 	int	ret;
 	unsigned int b;
 
-	printf("Calling get_bmap for block %lu\n", block);
-	abort();
 	b = block;
 	ret = ioctl(fd, FIBMAP, &b); /* FIBMAP takes pointer to integer */
 	if (ret < 0) {


