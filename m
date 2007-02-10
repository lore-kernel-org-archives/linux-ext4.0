From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-2.diff>
Date: Fri, 9 Feb 2007 18:11:17 -0800
Message-ID: <200702100211.l1A2BHsG007115@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:43687 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXBJCO0 (ORCPT
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
Coverity ID: 2: Deadcode

Looks like ss_current_request is a macro that will set code to 0. This test
will always be false. I will remove this error case.

Index: e2fsprogs+chaos/lib/ss/help.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ss/help.c
+++ e2fsprogs+chaos/lib/ss/help.c
@@ -49,10 +49,6 @@ void ss_help (argc, argv, sci_idx, info_
     register ss_data *info;
 
     request_name = ss_current_request(sci_idx, &code);
-    if (code != 0) {
-	ss_perror(sci_idx, code, "");
-	return;		/* no ss_abort_line, if invalid invocation */
-    }
     if (argc == 1) {
 	ss_list_requests(argc, argv, sci_idx, info_ptr);
 	return;
