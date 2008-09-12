From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] debugfs : Fix usage of logdump command to make consistent with man page.
Date: Fri, 12 Sep 2008 14:09:19 +0530
Message-ID: <ea11fea30809120139w352d97a7ha355e79658190ba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:44079 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYILIjV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 04:39:21 -0400
Received: by ti-out-0910.google.com with SMTP id b6so483351tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 01:39:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below path adds the missing 's' option in the usage of logdump. Also
trivially replace "inode" with "filespec" to make consistent with man
page.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

---
 debugfs/logdump.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index fed9838..73680de 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -88,7 +88,7 @@ void do_logdump(int argc, char **argv)
 	struct journal_source journal_source;
 	struct ext2_super_block *es = NULL;

-	journal_source.where = 0;
+	journal_source.where = JOURNAL_IS_INTERNAL;
 	journal_source.fd = 0;
 	journal_source.file = 0;
 	dump_all = 0;
@@ -264,7 +264,7 @@ errout:
 	return;

 print_usage:
-	fprintf(stderr, "%s: Usage: logdump [-ac] [-b<block>] [-i<inode>]\n\t"
+	fprintf(stderr, "%s: Usage: logdump [-acs] [-b<block>] [-i<filespec>]\n\t"
 		"[-f<journal_file>] [output_file]\n", argv[0]);
 }

-- 
1.5.4.3


Thanks -
Manish
