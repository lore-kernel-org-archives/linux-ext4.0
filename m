From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/74] e4defrag: don't crash if umounts the filesystem races
 with us
Date: Tue, 10 Dec 2013 17:20:40 -0800
Message-ID: <20131211012040.30655.381.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3LKBUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:46 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If someone umounts the filesystem between statfs64 and the getmntent()
iteration, we can exit the loop having never set mnt_type, and strcmp
can crash.  Fix the potential NULL deref.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e4defrag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 4b31d03..b6e2e31 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -374,7 +374,7 @@ static int is_ext4(const char *file, char *devname)
 	}
 
 	endmntent(fp);
-	if (strcmp(mnt_type, FS_EXT4) == 0) {
+	if (mnt_type && strcmp(mnt_type, FS_EXT4) == 0) {
 		FREE(mnt_type);
 		return 0;
 	} else {

