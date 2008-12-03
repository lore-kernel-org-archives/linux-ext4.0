From: <gregkh@suse.de>
Subject: patch ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:46 -0800
Message-ID: <20081203185911.7EBED48D80@coco.kroah.org>
References: <1226851540-8032-21-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: frederic.bohe@bull.net, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbYLCS7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:12 -0500
In-Reply-To: <1226851540-8032-21-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: add checksum calculation when clearing UNINIT flag in ext4_new_inode

to the 2.6.27-stable tree.  Its filename is

    ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:45:18 2008
From: Frederic Bohe <frederic.bohe@bull.net>
Date: Sun, 16 Nov 2008 11:05:40 -0500
Subject: ext4: add checksum calculation when clearing UNINIT flag in ext4_new_inode
To: stable@kernel.org
Cc: Frederic Bohe <frederic.bohe@bull.net>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-21-git-send-email-tytso@mit.edu>

From: Frederic Bohe <frederic.bohe@bull.net>

(cherry picked from commit 23712a9c28b9f80a8cf70c8490358d5f562d2465)

When initializing an uninitialized block group in ext4_new_inode(),
its block group checksum must be re-calculated.  This fixes a race
when several threads try to allocate a new inode in an UNINIT'd group.

There is some question whether we need to be initializing the block
bitmap in ext4_new_inode() at all, but for now, if we are going to
init the block group, let's eliminate the race.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ialloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -717,6 +717,8 @@ got:
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_free_blocks_count = cpu_to_le16(free);
+			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
+								gdp);
 		}
 		spin_unlock(sb_bgl_lock(sbi, group));
 


Patches currently in stable-queue which might be from frederic.bohe@bull.net are

queue-2.6.27/ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch
queue-2.6.27/ext4-fix-initialization-of-uninit-bitmap-blocks.patch
queue-2.6.27/ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch
