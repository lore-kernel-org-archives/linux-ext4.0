From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-19.diff>
Date: Fri, 9 Feb 2007 18:11:16 -0800
Message-ID: <200702100211.l1A2BGRU007105@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXBJCO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:26 -0500
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
Coverity ID: 19: Resource Leak

Need to close old_f before returning since it had been successfully opened
before.

Index: e2fsprogs+chaos/util/subst.c
===================================================================
--- e2fsprogs+chaos.orig/util/subst.c
+++ e2fsprogs+chaos/util/subst.c
@@ -273,8 +273,10 @@ static int compare_file(const char *outf
 	if (!old_f)
 		return 0;
 	new_f = fopen(newfn, "r");
-	if (!new_f)
+	if (!new_f) {
+		fclose(old_f);
 		return 0;
+	}
 
 	while (1) {
 		oldcp = fgets(oldbuf, sizeof(oldbuf), old_f);
