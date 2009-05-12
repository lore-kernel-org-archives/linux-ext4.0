From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/6] ext4: Clear the unwritten buffer_head flag after the extent is initialized
Date: Tue, 12 May 2009 18:45:24 -0400
Message-ID: <1242168327-31127-4-git-send-email-tytso@mit.edu>
References: <1242168327-31127-1-git-send-email-tytso@mit.edu>
 <1242168327-31127-2-git-send-email-tytso@mit.edu>
 <1242168327-31127-3-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44255 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbZELWpb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:45:31 -0400
In-Reply-To: <1242168327-31127-3-git-send-email-tytso@mit.edu>
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
---
 fs/ext4/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0ac31a0..8d0ff73 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1149,6 +1149,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	int retval;
 
 	clear_buffer_mapped(bh);
+	clear_buffer_unwritten(bh);
 
 	/*
 	 * Try to see if we can get  the block without requesting
@@ -1179,6 +1180,12 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		return retval;
 
 	/*
+	 * The above get_blocks can cause the buffer to be
+	 * marked unwritten. So clear the same.
+	 */
+	clear_buffer_unwritten(bh);
+
+	/*
 	 * New blocks allocate and/or writing to uninitialized extent
 	 * will possibly result in updating i_data, so we take
 	 * the write lock of i_data_sem, and call get_blocks()
-- 
1.6.3.rc4.1.g3e14.dirty

