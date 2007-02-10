From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-32.diff>
Date: Fri, 9 Feb 2007 18:11:28 -0800
Message-ID: <200702100211.l1A2BSid007312@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXBJCOh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:37 -0500
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
Coverity ID: 32: Resource Leak

The memory allocated by inst is not reclaimed.  There also was a
call to exit that coverity did not catch the resource leak.  This
might not really be a big issue since the memory will be freed when
fsck exits, but it should be done anyway imho.

Index: e2fsprogs+chaos/misc/fsck.c
===================================================================
--- e2fsprogs+chaos.orig/misc/fsck.c
+++ e2fsprogs+chaos/misc/fsck.c
@@ -470,6 +470,7 @@ static int execute(const char *type, con
 	s = find_fsck(prog);
 	if (s == NULL) {
 		fprintf(stderr, _("fsck: %s: not found\n"), prog);
+		free(inst);
 		return ENOENT;
 	}
 
@@ -486,12 +487,14 @@ static int execute(const char *type, con
 		pid = -1;
 	else if ((pid = fork()) < 0) {
 		perror("fork");
+		free(inst);
 		return errno;
 	} else if (pid == 0) {
 		if (!interactive)
 			close(0);
 		(void) execv(s, argv);
 		perror(argv[0]);
+		free(inst);
 		exit(EXIT_ERROR);
 	}
 
