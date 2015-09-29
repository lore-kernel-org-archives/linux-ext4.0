From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 e2fsprogs] subst: use 0644 perms
Date: Mon, 28 Sep 2015 21:14:38 -0400
Message-ID: <1443489278-6435-1-git-send-email-vapier@gentoo.org>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42320 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbbI2BOq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 21:14:46 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 03B7B3403C1
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2015 01:14:40 +0000 (UTC)
In-Reply-To: <1442562858-862-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When running on NFS, opening files with 0444 perms for writing can
sometimes fail.  Delay the permission update until the end (which
restores behavior to pre-commit 2873927d15ffb9ee9ed0e2700791a0e5).

URL: https://bugs.gentoo.org/550986
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 util/subst.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/util/subst.c b/util/subst.c
index f36adb4..10ad6b9 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -370,7 +370,7 @@ int main(int argc, char **argv)
 		}
 		strcpy(newfn, outfn);
 		strcat(newfn, ".new");
-		fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0444);
+		fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0644);
 		if (fd < 0) {
 			perror(newfn);
 			exit(1);
@@ -443,6 +443,11 @@ int main(int argc, char **argv)
 				perror("rename");
 				exit(1);
 			}
+			/* set read-only to alert user it is a generated file */
+			if (chmod(outfn, 0444)) {
+				perror("chmod");
+				exit(1);
+			}
 		}
 	}
 	if (old)
-- 
2.5.2

