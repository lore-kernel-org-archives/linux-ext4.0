From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-33.diff>
Date: Fri, 9 Feb 2007 18:11:29 -0800
Message-ID: <200702100211.l1A2BTRb007321@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:24558 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbXBJCOj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:39 -0500
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
Coverity ID: 33: Resource Leak

The memory allocated by buf is not reclaimed.  This patch
addresses the issue.

Index: e2fsprogs+chaos/misc/util.c
===================================================================
--- e2fsprogs+chaos.orig/misc/util.c
+++ e2fsprogs+chaos/misc/util.c
@@ -176,7 +176,7 @@ void check_mount(const char *device, int
 
 void parse_journal_opts(const char *opts)
 {
-	char	*buf, *token, *next, *p, *arg;
+	char	*buf = NULL, *token, *next, *p, *arg;
 	int	len;
 	int	journal_usage = 0;
 
@@ -234,8 +234,11 @@ void parse_journal_opts(const char *opts
 			"\tdevice=<journal device>\n\n"
 			"The journal size must be between "
 			"1024 and 102400 filesystem blocks.\n\n"), stderr);
+		free(buf);
 		exit(1);
 	}
+
+	free(buf);
 }	
 
 /*
