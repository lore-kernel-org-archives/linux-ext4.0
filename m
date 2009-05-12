From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5] Fix sub-block zeroing for buffered writes
	intounwritten extents
Date: Tue, 12 May 2009 20:46:46 +0530
Message-ID: <20090512151646.GB23862@skywalker>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512024218.GH21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:37781 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZELPQ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 11:16:59 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4CFGuKj028546
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 20:46:56 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4CFGuVK1560802
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 20:46:56 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4CFGttZ005711
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 01:16:56 +1000
Content-Disposition: inline
In-Reply-To: <20090512024218.GH21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext3: Fix sub-block zeroing for writes into preallocated extents

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to mark the buffer_head mapping preallocated space as new
during write_begin. Otherwise we don't zero out the page cache content
properly for a partial write. This will cause file corruption with
preallocation.

Now that we mark the buffer_head new we also need to have a valid
buffer_head blocknr so that unmap_underlying_metadata unmap the
right block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    2 ++
 fs/ext4/inode.c   |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e403321..c3768cd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2875,6 +2875,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev    = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..498cf8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2323,6 +2323,14 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result)) {
+			set_buffer_new(bh_result);
+		}
 		ret = 0;
 	}
 
