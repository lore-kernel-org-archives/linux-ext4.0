From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH RESEND] Free allocated and pre-allocated blocks when check_eofblocks_fl fails
Date: Tue, 21 Jun 2011 19:33:50 -0700 (PDT)
Message-ID: <20110622023351.0326042270@ruihe.smo.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:39201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab1FVCdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 22:33:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have hit the same BUG_ON as described in
https://bugzilla.kernel.org/show_bug.cgi?id=31222
on some of our servers that have disk failures or corrupted inodes. After
looking at the code, I think the problem is that we are not freeing inode's
preallocation list when check_eofblocks_fl fails in ext4_ext_map_blocks(),
which leaves the inode's preallocation list in an inconsistent state.

Below is a proposed patch to fix the bug. I have tested it by manually
inserting a random failure in check_eofblocks_fl() and run a test that
creates and uses an inode's preallocated blocks. Without the fix, the kernel
crashes after a few runs. With the fix, no crash is observed.
    
ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails

Upon corrupted inode or disk failures, we may fail after we already allocate
some blocks from the inode or take some blocks from the inode's preallocation
list, but before we successfully insert the corresponding extent to the extent
tree. In this case, we should free any allocated blocks and discard the inode's
preallocated blocks because the entries in the inode's preallocation list may
be in an inconsistent state.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/extents.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..8cf6ec9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3596,10 +3596,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
        }

        err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-       if (err)
-               goto out2;
