From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/47] dumpe2fs: don't crash when the user provides no block
 device argument
Date: Fri, 07 Nov 2014 13:51:02 -0800
Message-ID: <20141107215102.883.8882.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:07 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user doesn't provide any arguments, the guard fails to run and
the whole thing segfaults on ext2fs_open2().  Don't do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index e565f2d..26f2e37 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -656,7 +656,7 @@ int main (int argc, char ** argv)
 			usage();
 		}
 	}
-	if (argc - 1 > optind) {
+	if (optind != argc - 1) {
 		usage();
 		exit(1);
 	}

