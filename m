From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: remove unused htree_dump "-l" argument
Date: Wed, 11 May 2011 11:46:19 -0500
Message-ID: <4DCABD5B.8040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1EKQqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 12:46:21 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4BGkLph017030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 12:46:21 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p4BGkJSh014345
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 12:46:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The long_opt / -l argument was apparently never implemented,
so remove it and associated argument parsing.

This slightly changes the (undocumented) behavior because it
no longer defaults to cwd if no filespec is specified...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 08f9749..b829e25 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -197,8 +197,6 @@ void do_htree_dump(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
 	struct ext2_inode inode;
-	int		c;
-	int		long_opt = 0;
 	blk64_t		blk;
 	char		*buf = NULL;
 	struct 		ext2_dx_root_info  *rootnode;
@@ -211,28 +209,7 @@ void do_htree_dump(int argc, char *argv[])
 
 	pager = open_pager();
 
-	reset_getopt();
-	while ((c = getopt (argc, argv, "l")) != EOF) {
-		switch (c) {
-		case 'l':
-			long_opt++;
-			break;
-		default:
-			goto print_usage;
-		}
-	}
-
-	if (argc > optind+1) {
-	print_usage:
-		com_err(0, 0, "Usage: htree_dump [-l] file");
-		goto errout;
-	}
