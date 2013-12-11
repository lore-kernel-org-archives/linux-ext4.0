From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/74] libss: fix fd error handling
Date: Tue, 10 Dec 2013 17:21:08 -0800
Message-ID: <20131211012108.30655.33410.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42764 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3LKBVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:14 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ss/help.c     |    1 +
 lib/ss/list_rqs.c |    5 +++++
 2 files changed, 6 insertions(+)


diff --git a/lib/ss/help.c b/lib/ss/help.c
index 6a61e70..5278c95 100644
--- a/lib/ss/help.c
+++ b/lib/ss/help.c
@@ -110,6 +110,7 @@ void ss_help (argc, argv, sci_idx, info_ptr)
     switch (child = fork()) {
     case -1:
 	ss_perror(sci_idx, errno, "Can't fork for pager");
+	(void) close(fd);
 	return;
     case 0:
 	(void) dup2(fd, 0); /* put file on stdin */
diff --git a/lib/ss/list_rqs.c b/lib/ss/list_rqs.c
index 38e6aef..6baed41 100644
--- a/lib/ss/list_rqs.c
+++ b/lib/ss/list_rqs.c
@@ -45,6 +45,11 @@ void ss_list_requests(int argc __SS_ATTR((unused)),
     sigprocmask(SIG_BLOCK, &igmask, &omask);
     func = signal(SIGINT, SIG_IGN);
     fd = ss_pager_create();
+    if (fd < 0) {
+        perror("ss_pager_create");
+        (void) signal(SIGINT, func);
+        return;
+    }
     output = fdopen(fd, "w");
     sigprocmask(SIG_SETMASK, &omask, (sigset_t *) 0);
 

