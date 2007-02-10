From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-29.diff>
Date: Fri, 9 Feb 2007 18:11:25 -0800
Message-ID: <200702100211.l1A2BPFG007255@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:46449 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbXBJCOd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:33 -0500
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
Coverity ID: 29: Resource Leak

name is allocated some memory in blkid_strndup.  We could
potentially exit parse_dev() early if blkid_get_dev() is
unable to allocate memory.  blkid_get_dev() is passed name
but the address of name is not copied (instead a "deep" copy
is made in the form of strdup).  Thus it should be perfectly safe
to free name in this early return.

Index: e2fsprogs+chaos/lib/blkid/read.c
===================================================================
--- e2fsprogs+chaos.orig/lib/blkid/read.c
+++ e2fsprogs+chaos/lib/blkid/read.c
@@ -182,7 +182,7 @@ static int parse_end(char **cp)
  */
 static int parse_dev(blkid_cache cache, blkid_dev *dev, char **cp)
 {
-	char *start, *tmp, *end, *name;
+	char *start, *tmp, *end, *name = NULL;
 	int ret;
 
 	if ((ret = parse_start(cp)) <= 0)
@@ -223,8 +223,10 @@ static int parse_dev(blkid_cache cache, 
 
 	DBG(DEBUG_READ, printf("found dev %s\n", name));
 
-	if (!(*dev = blkid_get_dev(cache, name, BLKID_DEV_CREATE)))
+	if (!(*dev = blkid_get_dev(cache, name, BLKID_DEV_CREATE))) {
+		free(name);
 		return -BLKID_ERR_MEM;
+	}
 
 	free(name);
 	return 1;
