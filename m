From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] ext4: Fix xattr shifting when expanding inodes (2)
Date: Wed,  3 Aug 2016 12:39:46 +0200
Message-ID: <1470220795-17045-3-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org#4.4.x-
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564AbcHCKkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:25 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When multiple xattrs need to be moved out of inode, we did not properly
recompute total size of xattr headers in the inode and the new header
position. Thus when moving the second and further xattr we asked
ext4_xattr_shift_entries() to move too much and from the wrong place,
resulting in possible xattr value corruption or general memory
corruption.

CC: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cb1d7b4482de..b18b1ff7cc27 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1516,6 +1516,7 @@ retry:
 		error = ext4_xattr_ibody_set(handle, inode, &i, is);
 		if (error)
 			goto cleanup;
+		total_ino -= entry_size;
 
 		entry = IFIRST(header);
 		if (entry_size + EXT4_XATTR_SIZE(size) >= isize_diff)
@@ -1526,11 +1527,11 @@ retry:
 		ext4_xattr_shift_entries(entry, -shift_bytes,
 			(void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
 			EXT4_I(inode)->i_extra_isize + shift_bytes,
-			(void *)header, total_ino - entry_size,
-			inode->i_sb->s_blocksize);
+			(void *)header, total_ino, inode->i_sb->s_blocksize);
 
 		isize_diff -= shift_bytes;
 		EXT4_I(inode)->i_extra_isize += shift_bytes;
+		header = IHDR(inode, raw_inode);
 
 		i.name = b_entry_name;
 		i.value = buffer;
-- 
2.6.6

