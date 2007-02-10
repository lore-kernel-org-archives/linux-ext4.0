From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-35.diff>
Date: Fri, 9 Feb 2007 18:11:30 -0800
Message-ID: <200702100211.l1A2BUGH007330@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:46449 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXBJCOg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:36 -0500
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
Coverity ID: 35: Resource Leak

The memory allocated by string_copy is clearly never reclaimed. The fix adds
free() to the end of the function to reclaim the memory, I didn't see an API
function to free memory allocated by string_copy().

Fixed some whitespace issues as well

Index: e2fsprogs+chaos/e2fsck/unix.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/unix.c
+++ e2fsprogs+chaos/e2fsck/unix.c
@@ -524,7 +524,7 @@ static void parse_extended_opts(e2fsck_t
 		if (p) {
 			*p = 0;
 			next = p+1;
-		} 
+		}
 		arg = strchr(token, '=');
 		if (arg) {
 			*arg = 0;
@@ -550,6 +550,8 @@ static void parse_extended_opts(e2fsck_t
 			extended_usage++;
 		}
 	}
+	free(buf);
+
 	if (extended_usage) {
 		fputs(("\nExtended options are separated by commas, "
 		       "and may take an argument which\n"
@@ -558,7 +560,7 @@ static void parse_extended_opts(e2fsck_t
 		       "\tea_ver=<ea_version (1 or 2)>\n\n"), stderr);
 		exit(1);
 	}
-}	
+}
 
 static void syntax_err_report(const char *filename, long err, int line_num)
 {
