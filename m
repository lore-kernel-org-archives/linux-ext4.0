From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] mke2fs: fix -T/-t usage output
Date: Wed,  7 Dec 2011 11:15:33 -0500
Message-ID: <1323274533-13103-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49663 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab1LGQPa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Dec 2011 11:15:30 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 3C0621B4022
	for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2011 16:15:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a slight desync between the mke2fs(8) man page and the mke2fs
help output when it comes to the -t/-T options.  Since the man page is
correct, update the mke2fs usage string to match.

Reported-by: Ben Kohler <bkohler@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 misc/mke2fs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..e97e44e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -121,7 +121,8 @@ static void usage(void)
 	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
 	"[-r fs-revision] [-E extended-option[,...]]\n"
-	"\t[-T fs-type] [-U UUID] [-jnqvFKSV] device [blocks-count]\n"),
+	"\t[-t fs-type] [-T usage-type ] [-U UUID] "
+	"[-jnqvFKSV] device [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
-- 
1.7.6.1

