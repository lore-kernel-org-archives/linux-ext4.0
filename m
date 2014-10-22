From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Make ext4_ext_convert_to_initialized() return proper number of blocks
Date: Wed, 22 Oct 2014 10:29:10 +0200
Message-ID: <1413966550-27404-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbaJVI3R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 04:29:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_convert_to_initialized() can return more blocks than are
actually allocated from map->m_lblk in case where initial part of the
on-disk extent is zeroed out. Luckily this doesn't have serious
consequences because the caller currently uses the return value
only to unmap metadata buffers. Anyway this is a data
corruption/exposure problem waiting to happen so fix it.

Coverity-id: 1226848
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 37043d0b2be8..0b16fb4c06d3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3603,11 +3603,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		}
 	}
 
-	allocated = ext4_split_extent(handle, inode, ppath,
-				      &split_map, split_flag, flags);
-	if (allocated < 0)
-		err = allocated;
