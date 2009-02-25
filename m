From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] blkid: recognize ext4(dev) without journal
Date: Tue, 24 Feb 2009 23:17:54 -0600
Message-ID: <49A4D482.7000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZBYFR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 00:17:57 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1P5HujU011758
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:17:56 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1P5HuRi020407
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:17:56 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1P5HtAO008877
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:17:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4/ext4dev no longer require a journal.

w/o this blkid doesn't recognize after:

# mkfs.ext4 /dev/blah
# tune2fs -O ^has_journal
# blkid /dev/blah

We still must have one ext3-incompat-feature to flag
as ext4(dev) so we shouldn't ever mis-recognize it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c
+++ e2fsprogs/lib/blkid/probe.c
@@ -281,11 +281,6 @@ static int probe_ext4dev(struct blkid_pr
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
 		return -BLKID_ERR_PARAM;
 
-	/* ext4dev requires a journal */
-	if (!(blkid_le32(es->s_feature_compat) &
-	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
-		return -BLKID_ERR_PARAM;
-
 	/*
 	 * If the filesystem is marked as OK for use by in-development
 	 * filesystem code, but ext4dev is not supported, and ext4 is,
@@ -317,11 +312,6 @@ static int probe_ext4(struct blkid_probe
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
 		return -BLKID_ERR_PARAM;
 
-	/* ext4 requires journal */
-	if (!(blkid_le32(es->s_feature_compat) &
-	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
-		return -BLKID_ERR_PARAM;
