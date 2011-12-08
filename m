From: Jan Kara <jack@suse.cz>
Subject: [PATCH] resize2fs: Calculate s_first_data_block into minimum filesystem size
Date: Thu,  8 Dec 2011 15:09:09 +0100
Message-ID: <1323353349-9675-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1LHOJM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 09:09:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

calculate_minimum_resize_size() forgot to account s_first_data_block
into minimum filesystem size. Thus in case the size of filesystem was
such that the last group had the minimal size (50 blocks + metadata
overhead), the code in adjust_fs_info() decided the group is unneeded,
removed it, and in some cases the resizing then failed with ENOSPC.

Fix the issue by properly accounting for s_first_data_block in
calculate_minimum_resize_size().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 resize/resize2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 06ce73e..dc2805d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2033,6 +2033,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 
 	if (ext2fs_bg_has_super(fs, groups-1))
 		overhead += SUPER_OVERHEAD(fs);
+	overhead += fs->super->s_first_data_block;
 
 	/*
 	 * since our last group doesn't have to be BLOCKS_PER_GROUP large, we
-- 
1.7.1

