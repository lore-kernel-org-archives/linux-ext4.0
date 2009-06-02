From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 23/24] ext4: Clear the unwritten buffer_head flag after the extent is initialized
Date: Tue,  2 Jun 2009 08:09:35 -0400
Message-ID: <1243944576-20915-23-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
 <1243944576-20915-16-git-send-email-tytso@mit.edu>
 <1243944576-20915-17-git-send-email-tytso@mit.edu>
 <1243944576-20915-18-git-send-email-tytso@mit.edu>
 <1243944576-20915-19-git-send-email-tytso@mit.edu>
 <1243944576-20915-20-git-send-email-tytso@mit.edu>
 <1243944576-20915-21-git-send-email-tytso@mit.edu>
 <1243944576-20915-22-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59273 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZFBMJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:46 -0400
In-Reply-To: <1243944576-20915-22-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The BH_Unwritten flag indicates that the buffer is allocated on disk
but has not been written; that is, the disk was part of a persistent
preallocation area.  That flag should only be set when a get_blocks()
function is looking up a inode's logical to physical block mapping.

When ext4_get_blocks_wrap() is called with create=1, the uninitialized
extent is converted into an initialized one, so the BH_Unwritten flag
is no longer appropriate.  Hence, we need to make sure the
BH_Unwritten is not left set, since the combination of BH_Mapped and
BH_Unwritten is not allowed; among other things, it will result ext4's
get_block() to be called over and over again during the write_begin
phase of write(2).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 2a8964d63d50dd2d65d71d342bc7fb6ef4117614)
---
 fs/ext4/inode.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 16c8dcb..6620045 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1085,6 +1085,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	int retval;
 
 	clear_buffer_mapped(bh);
+	clear_buffer_unwritten(bh);
 
 	/*
 	 * Try to see if we can get  the block without requesting
@@ -1115,6 +1116,18 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		return retval;
 
 	/*
+	 * When we call get_blocks without the create flag, the
+	 * BH_Unwritten flag could have gotten set if the blocks
+	 * requested were part of a uninitialized extent.  We need to
+	 * clear this flag now that we are committed to convert all or
+	 * part of the uninitialized extent to be an initialized
+	 * extent.  This is because we need to avoid the combination
+	 * of BH_Unwritten and BH_Mapped flags being simultaneously
+	 * set on the buffer_head.
+	 */
+	clear_buffer_unwritten(bh);
+
+	/*
 	 * New blocks allocate and/or writing to uninitialized extent
 	 * will possibly result in updating i_data, so we take
 	 * the write lock of i_data_sem, and call get_blocks()
-- 
1.6.3.1.1.g75fc.dirty

