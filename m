From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] fuse2fs: delete unused variables
Date: Tue, 19 Apr 2016 12:21:00 -0700 (PDT)
Message-ID: <20160419192100.GA5405@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24799 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbcDSTY0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2016 15:24:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/fuse2fs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c75527e..5a19f23 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3712,8 +3712,7 @@ int main(int argc, char *argv[])
 	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
 	struct fuse2fs fctx;
 	errcode_t err;
-	char *tok, *arg, *logfile;
-	int i;
+	char *logfile;
 	char extra_args[BUFSIZ];
 	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
 
