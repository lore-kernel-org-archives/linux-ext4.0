From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-3.diff>
Date: Fri, 9 Feb 2007 18:11:26 -0800
Message-ID: <200702100211.l1A2BQRE007265@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXBJCOf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 3: Deadcode

blkid_dev_has_tag() will immediately return -1 (an error if value is NULL. Thus
at the test later on value cannot be NULL. There are two possible ways to go
about fixing this. The first would be to remove the first NULL check for value.
The second one would be to remove the second check (and the deadcode). I could
be persuaded either way, but to preserve existing functionality I will opt to
remove the second check.

Index: e2fsprogs+chaos/lib/blkid/tag.c
===================================================================
--- e2fsprogs+chaos.orig/lib/blkid/tag.c
+++ e2fsprogs+chaos/lib/blkid/tag.c
@@ -91,8 +91,6 @@ extern int blkid_dev_has_tag(blkid_dev d
 		return -1;
 
 	tag = blkid_find_tag_dev(dev, type);
-	if (!value)
-		return(tag != NULL);
 	if (!tag || strcmp(tag->bit_val, value))
 		return 0;
 	return 1;
