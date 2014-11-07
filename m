From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/47] e2fsck: don't complain about root dir csum failures
 when getting lnf
Date: Fri, 07 Nov 2014 13:52:51 -0800
Message-ID: <20141107215251.883.27455.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36004 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaKGVwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:55 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't complain about checksum failures on the root dir when we're
trying to find l+f if the root dir is going to be rehashed anyway.

The test case for this is t_enable_mcsum in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 2d94ece..1d5255f 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -384,14 +384,23 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	char *			block;
 	static const char	name[] = "lost+found";
 	struct 	problem_context	pctx;
+	int			will_rehash, flags;
 
 	if (ctx->lost_and_found)
 		return ctx->lost_and_found;
 
 	clear_problem_context(&pctx);
 
+	will_rehash = e2fsck_dir_will_be_rehashed(ctx, EXT2_ROOT_INO);
+	if (will_rehash) {
+		flags = ctx->fs->flags;
+		ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	}
 	retval = ext2fs_lookup(fs, EXT2_ROOT_INO, name,
 			       sizeof(name)-1, 0, &ino);
+	if (will_rehash)
+		ctx->fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			(ctx->fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 	if (retval && !fix)
 		return 0;
 	if (!retval) {

