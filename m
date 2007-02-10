From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-8.diff>
Date: Fri, 9 Feb 2007 18:11:43 -0800
Message-ID: <200702100211.l1A2BhBF007541@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:20101 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXBJCOv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:51 -0500
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
Coverity ID: 8: Forward Null

Looks like flawed reasoning.  Here if infor_DIR is NULL then you are guaranteed
to blow up since you will dereference it.  It seems like the correct thing to
do here (what the code author meant to do) was to set *code_ptr =
SS_ET_NO_INFO_DIR if info_dir was NULL or if *info_dir was an empty string (aka
*info_dir == '\0').

Index: e2fsprogs+chaos/lib/ss/help.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ss/help.c
+++ e2fsprogs+chaos/lib/ss/help.c
@@ -134,7 +134,7 @@ void ss_add_info_dir(sci_idx, info_dir, 
     register char **dirs;
 
     info = ss_info(sci_idx);
-    if (info_dir == NULL && *info_dir) {
+    if (info_dir == NULL || *info_dir == '\0') {
 	*code_ptr = SS_ET_NO_INFO_DIR;
 	return;
     }
