From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 23/74] e2image: check return value from check_if_mounted
Date: Tue, 10 Dec 2013 17:20:53 -0800
Message-ID: <20131211012053.30655.45546.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3LKBU7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:59 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2image.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/misc/e2image.c b/misc/e2image.c
index 624525b..878149e 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1309,7 +1309,11 @@ int main (int argc, char ** argv)
 	device_name = argv[optind];
 	image_fn = argv[optind+1];
 
-	ext2fs_check_if_mounted(device_name, &mount_flags);
+	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
+	if (retval) {
+		com_err(program_name, retval, "checking if mounted");
+		exit(1);
+	}
 
 	if (img_type && !ignore_rw_mount &&
 	    (mount_flags & EXT2_MF_MOUNTED) &&

