From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/24] e2fsck: free ctx->fs, not fs, at the end of fsck
Date: Fri, 18 Jul 2014 15:53:35 -0700
Message-ID: <20140718225335.31374.76938.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33128 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991AbaGRWxk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:40 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we call ext2fs_close_free at the end of main(), we need to supply
the address of ctx->fs, because the subsequent e2fsck_free_context
call will try to access ctx->fs (which is now set to a freed block) to
see if it should free the directory block list.  This is clearly not
desirable, so fix the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index bb5141f..d883c9e 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1780,7 +1780,7 @@ no_journal:
 	io_channel_flush(ctx->fs->io);
 	print_resource_track(ctx, NULL, &ctx->global_rtrack, ctx->fs->io);
 
-	ext2fs_close_free(&fs);
+	ext2fs_close_free(&ctx->fs);
 	free(ctx->journal_name);
 
 	e2fsck_free_context(ctx);

