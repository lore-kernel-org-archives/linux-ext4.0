From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-17.diff>
Date: Fri, 9 Feb 2007 18:11:14 -0800
Message-ID: <200702100211.l1A2BEuC007083@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:14899 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXBJCOY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:24 -0500
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
Coverity ID: 17: Resource Leak

Need to free memory allocated to buf.

Index: e2fsprogs+chaos/lib/e2p/mntopts.c
===================================================================
--- e2fsprogs+chaos.orig/lib/e2p/mntopts.c
+++ e2fsprogs+chaos/lib/e2p/mntopts.c
@@ -132,5 +132,6 @@ int e2p_edit_mntopts(const char *str, __
 			*mntopts |= mask;
 		cp = next ? next+1 : 0;
 	}
+	free(buf);
 	return 0;
 }
