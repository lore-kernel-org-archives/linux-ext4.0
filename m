From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/37] debugfs: force logdump to display (old) journal
 contents
Date: Thu, 01 May 2014 16:13:02 -0700
Message-ID: <20140501231302.31890.45397.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaEAXNH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:07 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user passes -a more than once to logdump, try to dump old log
contents.  This can be used to try to track down journal problems even
after recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/logdump.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 8b9dc5b..bf4bef5 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -393,9 +393,13 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	fprintf(out_file, "Journal starts at block %u, transaction %u\n",
 		blocknr, transaction);
 
-	if (!blocknr)
+	if (!blocknr) {
 		/* Empty journal, nothing to do. */
-		return;
+		if (dump_all < 2)
+			return;
+		else
+			blocknr = 1;
+	}
 
 	while (1) {
 		retval = read_journal_block(cmdname, source,
@@ -420,7 +424,8 @@ static void dump_journal(char *cmdname, FILE *out_file,
 			fprintf (out_file, "Found sequence %u (not %u) at "
 				 "block %u: end of journal.\n",
 				 sequence, transaction, blocknr);
-			return;
+			if (dump_all < 2)
+				return;
 		}
 
 		if (dump_descriptors) {

