From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 58/54] e2fsck: turn inline data symlink into a fast symlink
 when possible
Date: Thu, 19 Mar 2015 16:54:24 -0700
Message-ID: <20150319235424.GM11031@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43033 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbCSXyb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 19:54:31 -0400
Content-Disposition: inline
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When there's a problem accessing the EA part of an inline data symlink
and we want to truncate the symlink back to 60 characters (hoping the
user can re-establish the link later on, apparently) be sure to turn
off the inline data flag to convert the symlink back to a regular fast
symlink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2c5fca6..8c66c6d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1327,6 +1327,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 						ctx->flags |= E2F_FLAG_ABORT;
 						goto endit;
 					}
+					if (LINUX_S_ISLNK(inode->i_mode))
+						inode->i_flags &= ~EXT4_INLINE_DATA_FL;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
 					failed_csum = 0;
