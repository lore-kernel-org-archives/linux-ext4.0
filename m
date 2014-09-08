From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/25] misc: don't return ENOMEM if we run out of disk space
Date: Mon, 08 Sep 2014 16:11:55 -0700
Message-ID: <20140908231155.25904.55767.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38774 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXMC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:02 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there aren't enough blocks in the FS to allocate all of the
hugefiles, return ENOSPC, not ENOMEM.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mk_hugefiles.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 8291f01..3e4274c 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -530,10 +530,10 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 
 	fs_blocks = ext2fs_free_blocks_count(fs->super);
 	if (fs_blocks < num_slack + align)
-		return ENOMEM;
+		return ENOSPC;
 	fs_blocks -= num_slack + align;
 	if (num_blocks && num_blocks > fs_blocks)
-		return ENOMEM;
+		return ENOSPC;
 	if (num_blocks == 0 && num_files == 0)
 		num_files = 1;
 

