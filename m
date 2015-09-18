From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH e2fsprogs] subst: use 0644 perms
Date: Fri, 18 Sep 2015 03:54:18 -0400
Message-ID: <1442562858-862-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40493 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbIRHyW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 03:54:22 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id C1360340AE4
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2015 07:54:21 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When running on NFS, opening files with 0444 perms for writing can
sometimes fail.  Since there's no real reason for these files to be
read-only, give the owner write permission.

URL: https://bugs.gentoo.org/550986
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 util/subst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/subst.c b/util/subst.c
index f36adb4..e4004c9 100644
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
-- 
2.5.1

