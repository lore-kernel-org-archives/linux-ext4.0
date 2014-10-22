From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Remove never taken branch from ext4_ext_shift_path_extents()
Date: Wed, 22 Oct 2014 11:15:04 +0200
Message-ID: <1413969304-2842-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaJVJPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 05:15:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

path[depth].p_hdr can never be NULL for a path passed to us (and even if
it could, EXT_LAST_EXTENT() would make something != NULL from it). So
just remove the branch.

Coverity-id: 1196498
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0b16fb4c06d3..31cd9b5c6419 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5239,8 +5239,6 @@ ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 				return -EIO;
 
 			ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
-			if (!ex_last)
-				return -EIO;
 
 			err = ext4_access_path(handle, inode, path + depth);
 			if (err)
-- 
1.8.1.4

