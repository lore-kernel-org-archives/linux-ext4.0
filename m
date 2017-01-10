From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsprogs: enable project quota reporting in debugfs
Date: Tue, 10 Jan 2017 16:54:01 -0500
Message-ID: <20170110215401.GA1232@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34262 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdAJVyb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2017 16:54:31 -0500
Received: by mail-qk0-f194.google.com with SMTP id e1so22552842qkh.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2017 13:54:26 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the minor changes required so the list_quota and get_quota commands
can report project quota information.  This also fixes a debugfs
segfault that currently occurs when either list_quota or get_quota is
invoked with an unknown quota_type argument.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 debugfs/quota.c        | 12 ++++++------
 tests/f_quota/expect.0 | 28 ++++++++++++++--------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/debugfs/quota.c b/debugfs/quota.c
index cf1078c..0b7c2ee 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -25,7 +25,7 @@ extern char *optarg;
 
 #include "debugfs.h"
 
-const char *quota_type[] = { "user", "group", NULL };
+const char *quota_type[] = { "user", "group", "project", NULL };
 
 static int load_quota_ctx(char *progname)
 {
@@ -92,7 +92,7 @@ static int parse_quota_type(const char *cmdname, const char *str)
 static int list_quota_callback(struct dquot *dq,
 			       void *cb_data EXT2FS_ATTR((unused)))
 {
-	printf("%8u   %8lld %8lld %8lld    %8lld %8lld %8lld\n",
+	printf("%10u   %8lld %8lld %8lld    %8lld %8lld %8lld\n",
 	       dq->dq_id, (long long)dq->dq_dqb.dqb_curspace,
 	       (long long)dq->dq_dqb.dqb_bsoftlimit,
 	       (long long)dq->dq_dqb.dqb_bhardlimit,
@@ -120,8 +120,8 @@ void do_list_quota(int argc, char *argv[])
 	if (type < 0)
 		return;
 
-	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
-	       (type == 0) ? "user id" : "group id",
+	printf("%7s %2s   %8s %8s %8s    %8s %8s %8s\n",
+	       quota_type[type], "id",
 	       "blocks", "quota", "limit", "inodes", "quota", "limit");
 	qh = current_qctx->quota_file[type];
 	retval = qh->qh_ops->scan_dquots(qh, list_quota_callback, NULL);
@@ -154,8 +154,8 @@ void do_get_quota(int argc, char *argv[])
 	if (err)
 		return;
 
-	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
-	       (type == 0) ? "user id" : "group id",
+	printf("%7s %2s   %8s %8s %8s    %8s %8s %8s\n",
+	       quota_type[type], "id",
 	       "blocks", "quota", "limit", "inodes", "quota", "limit");
 
 	qh = current_qctx->quota_file[type];
diff --git a/tests/f_quota/expect.0 b/tests/f_quota/expect.0
index c0ad63d..eb5294e 100644
--- a/tests/f_quota/expect.0
+++ b/tests/f_quota/expect.0
@@ -1,21 +1,21 @@
 debugfs: list_quota user
- user id     blocks    quota    limit      inodes    quota    limit
-       0      13312        0        0           2        0        0
-      34       1024        0        0           1        0        0
-     100       2048       32       50           2       20       30
+   user id     blocks    quota    limit      inodes    quota    limit
+         0      13312        0        0           2        0        0
+        34       1024        0        0           1        0        0
+       100       2048       32       50           2       20       30
 debugfs: list_quota group
-group id     blocks    quota    limit      inodes    quota    limit
-       0      16384        0        0           5        0        0
+  group id     blocks    quota    limit      inodes    quota    limit
+         0      16384        0        0           5        0        0
 debugfs: get_quota user 0
- user id     blocks    quota    limit      inodes    quota    limit
-       0      13312        0        0           2        0        0
+   user id     blocks    quota    limit      inodes    quota    limit
+         0      13312        0        0           2        0        0
 debugfs: get_quota user 100
- user id     blocks    quota    limit      inodes    quota    limit
-     100       2048       32       50           2       20       30
+   user id     blocks    quota    limit      inodes    quota    limit
+       100       2048       32       50           2       20       30
 debugfs: get_quota user 34
- user id     blocks    quota    limit      inodes    quota    limit
-      34       1024        0        0           1        0        0
+   user id     blocks    quota    limit      inodes    quota    limit
+        34       1024        0        0           1        0        0
 debugfs: get_quota group 0
-group id     blocks    quota    limit      inodes    quota    limit
-       0      16384        0        0           5        0        0
+  group id     blocks    quota    limit      inodes    quota    limit
+         0      16384        0        0           5        0        0
 debugfs: 
-- 
2.1.4

