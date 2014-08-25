From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: enable block_validity by default
Date: Mon, 25 Aug 2014 09:36:32 -0700
Message-ID: <20140825163632.GC22645@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042630.2441.34661.stgit@birch.djwong.org>
 <20140824224721.GG6236@thunk.org>
 <20140825155218.GA22645@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45121 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaHYQgi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2014 12:36:38 -0400
Content-Disposition: inline
In-Reply-To: <20140825155218.GA22645@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enable by default the block_validity feature, which checks for
collisions between newly allocated blocks and critical system
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b28b36..bbf515c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3519,8 +3519,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, ERRORS_CONT);
 	else
 		set_opt(sb, ERRORS_RO);
-	if (def_mount_opts & EXT4_DEFM_BLOCK_VALIDITY)
-		set_opt(sb, BLOCK_VALIDITY);
+	/* block_validity enabled by default; disable with noblock_validity */
+	set_opt(sb, BLOCK_VALIDITY);
 	if (def_mount_opts & EXT4_DEFM_DISCARD)
 		set_opt(sb, DISCARD);
 
