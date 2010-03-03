From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 1/3] ext4: Fix insertion point of extent in mext_insert_across_blocks()
Date: Wed, 03 Mar 2010 15:49:29 +0900
Message-ID: <4B8E0679.8060706@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57149 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0CCGuc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 01:50:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix insertion point of extent in mext_insert_across_blocks()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If the leaf node has 2 extent space or fewer and
EXT4_IOC_MOVE_EXT ioctl is called
with the file offset where after the 2nd extent covers,
mext_insert_across_blocks() always tries to insert extent into the first extent.
As a result, the file gets corrupted because of
wrong extent order.  The patch fixes this problem.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
  fs/ext4/move_extent.c |    4 ++++
  1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 1654eb8..9eca1c0 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -252,6 +252,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
  		}

  		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
  		new_flag = 1;

  	} else if (start_ext->ee_len && new_ext->ee_len &&
@@ -262,6 +263,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
  		 * orig  |------------------------------|
  		 */
  		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
  		new_flag = 1;

  	} else if (!start_ext->ee_len && new_ext->ee_len &&
@@ -502,6 +504,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
  		le32_to_cpu(oext->ee_block) + oext_alen) {
  		start_ext.ee_len = cpu_to_le16(le32_to_cpu(new_ext.ee_block) -
  					       le32_to_cpu(oext->ee_block));
+		start_ext.ee_block = oext->ee_block;
  		copy_extent_status(oext, &start_ext);
  	} else if (oext > EXT_FIRST_EXTENT(orig_path[depth].p_hdr)) {
  		prev_ext = oext - 1;
@@ -515,6 +518,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
  			start_ext.ee_len = cpu_to_le16(
  				ext4_ext_get_actual_len(prev_ext) +
  				new_ext_alen);
+			start_ext.ee_block = oext->ee_block;
  			copy_extent_status(prev_ext, &start_ext);
  			new_ext.ee_len = 0;
  		}
