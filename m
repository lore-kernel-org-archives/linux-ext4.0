From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-14.diff>
Date: Fri, 9 Feb 2007 18:11:12 -0800
Message-ID: <200702100211.l1A2BCGB007040@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:33134 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbXBJCOU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:20 -0500
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
Coverity ID: 14: Resource Leak

The profile must be freed early if subsequent memory allocations
fail for 'expanded_filename'.  

Index: e2fsprogs+chaos/e2fsck/profile.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/profile.c
+++ e2fsprogs+chaos/e2fsck/profile.c
@@ -414,13 +414,16 @@ errcode_t profile_open_file(const char *
 			len += strlen(home_env);
 	}
 	expanded_filename = malloc(len);
-	if (expanded_filename == 0)
+	if (!expanded_filename) {
+	    profile_free_file(prf);
 	    return errno;
+	}
 	if (home_env) {
 	    strcpy(expanded_filename, home_env);
 	    strcat(expanded_filename, filespec+1);
-	} else
+	} else {
 	    memcpy(expanded_filename, filespec, len);
+	}
 
 	prf->filespec = expanded_filename;
 
