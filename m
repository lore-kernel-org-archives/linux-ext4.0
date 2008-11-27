From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Wed, 26 Nov 2008 23:50:47 -0500
Message-ID: <20081127045047.GF14101@mit.edu>
References: <20081121102309.182113793@bull.net> <20081121102309.507553245@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53671 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbYK0Euu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 23:50:50 -0500
Content-Disposition: inline
In-Reply-To: <20081121102309.507553245@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:23:10AM +0100, Solofo.Ramangalahy@bull.net wrote:
> The inode table has been zeroed in setup_new_group_blocks().
> Mark it as such in ext4_group_add().

This patch makes sense to apply right away.  However:

1) You didn't include a Developer's Certification of Origin (i.e., a
"Signed-off-by" header).  Since this is a one line patch, and it seems
pretty clear your intention is to submit this to Linus, I added one on
your behalf so you can see how it should be done.  However, in general
you should never add a signoff for someone else, so I need an explicit
OK from you that you agree with the terms of the Developer's
Certification of Origin as found in the Linux kernel source code,
Documentation/SubmittingPatches before I can push this patch to Linus.
This is very important legally.

2) You need to set the flag *before* you calculate the block group
checksum, not afterwards.

So the corrected patch should look like this....

							- Ted

ext4: When resizing set the EXT4_BG_INODE_ZEROED flag for new block groups

From: Solofo.Ramangalahy@bull.net

The inode table has been zeroed in setup_new_group_blocks().  Mark it as
such in ext4_group_add().  Since we are currently clearing inode table
for the new block group, we should set the EXT4_BG_INODE_ZEROED flag.
If at some point in the future we don't immediately zero out the inode
table as part of the resize operation, then obviously we shouldn't do
this.

Signed-off-by: Solofo.Ramangalahy@bull.net
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b6ec184..d448eb1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -864,6 +864,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
