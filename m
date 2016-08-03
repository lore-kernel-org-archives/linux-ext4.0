From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/11] ext4: Properly align shifted xattrs when expanding inodes
Date: Wed,  3 Aug 2016 12:39:47 +0200
Message-ID: <1470220795-17045-4-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org#4.4.x-
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbcHCKkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:25 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We did not count with the padding of xattr value when computing desired
shift of xattrs in the inode when expanding i_extra_isize. As a result
we could create unaligned start of inline xattrs. Account for alignment
properly.

CC: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b18b1ff7cc27..c893f00b6dc0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1522,7 +1522,7 @@ retry:
 		if (entry_size + EXT4_XATTR_SIZE(size) >= isize_diff)
 			shift_bytes = isize_diff;
 		else
-			shift_bytes = entry_size + size;
+			shift_bytes = entry_size + EXT4_XATTR_SIZE(size);
 		/* Adjust the offsets and shift the remaining entries ahead */
 		ext4_xattr_shift_entries(entry, -shift_bytes,
 			(void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
-- 
2.6.6

