From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] blkid: recognize ext3 with test_fs set as ext3
Date: Tue, 14 Oct 2008 12:27:15 -0500
Message-ID: <48F4D673.8020202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYJNR1S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Oct 2008 13:27:18 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9EHRHfc015288
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:27:17 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EHRGVC003554
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:27:17 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9EHRF0i031361
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:27:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It seems that if we have the test_filesystem flag set on an ext3
filesystem(!) on a system which provides ext4, blkid gets confused.

According to the current logic:

* It's not an ext4dev filesystem, because the system provides ext4.
* It's not an ext4 filesystem, because it has no ext4 features.
* It's not an ext3 filesystem, because the test flag is set.

In the end, it's nothing.

blkid should return *something* that is mountable... I'm inclined to
think that ext3 should be the right answer, if no ext4-specific features
are set.

This would mean just dropping the EXT2_FLAGS_TEST_FILESYS test in
probe_ext3(), because ext4 & ext4dev probes have come first already.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c
+++ e2fsprogs/lib/blkid/probe.c
@@ -353,10 +353,6 @@ static int probe_ext3(struct blkid_probe
 	struct ext2_super_block *es;
 	es = (struct ext2_super_block *)buf;

-	/* Distinguish from ext4dev */
-	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)
-		return -BLKID_ERR_PARAM;
