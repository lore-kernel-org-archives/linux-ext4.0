From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 06/10] Fs: ext4: extents: whitespace cleanup
Date: Sat, 25 Sep 2010 14:31:57 -0400
Message-ID: <1285439521-2557-6-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0IYSc7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Sep 2010 14:32:59 -0400
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tracey Dent <Tdent48227@gmail.com>

Fixed whitespaces issues that checkpath.pl founded

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/extents.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 06328d3..06f7bb3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -461,7 +461,7 @@ static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 
 	ext_debug("path:");
 	for (k = 0; k <= l; k++, path++) {
-		if (path->p_idx) {
+		if (path->p_idx)	{
 		  ext_debug("  %d->%llu", le32_to_cpu(path->p_idx->ei_block),
 			    idx_pblock(path->p_idx));
 		} else if (path->p_ext) {
@@ -553,7 +553,7 @@ ext4_ext_binsearch_idx(struct inode *inode,
 		int k;
 
 		chix = ix = EXT_FIRST_INDEX(eh);
-		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
+		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++)	{
 		  if (k != 0 &&
 		      le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
 				printk(KERN_DEBUG "k=%d, ix=0x%p, "
@@ -1784,7 +1784,7 @@ has_space:
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
-	} else if (le32_to_cpu(newext->ee_block)
+	}	else if (le32_to_cpu(newext->ee_block)
 			   > le32_to_cpu(nearex->ee_block)) {
 /*		BUG_ON(newext->ee_block == nearex->ee_block); */
 		if (nearex != EXT_LAST_EXTENT(eh)) {
@@ -3477,7 +3477,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(ar.len);
 	/* Mark uninitialized */
-	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
+	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)	{
 		ext4_ext_mark_uninitialized(&newex);
 		/*
 		 * io_end structure was created for every IO write to an
@@ -3807,7 +3807,7 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
-		if (ret <= 0 || ret2 )
+		if (ret <= 0 || ret2)
 			break;
 	}
 	return ret > 0 ? ret2 : ret;
-- 
1.7.3

