From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix oops when online resizing a filesystem with
	flex_bg
Date: Mon, 26 Jan 2009 19:07:43 -0500
Message-ID: <20090127000743.GC10118@mit.edu>
References: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33935 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZA0CG7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2009 21:06:59 -0500
Content-Disposition: inline
In-Reply-To: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 23, 2009 at 06:41:49PM -0200, Thadeu Lima de Souza Cascardo wrote:
> http://kerneloops.org/raw.php?rawid=176715 and
> http://bugzilla.kernel.org/show_bug.cgi?id=12433 report a bug when
> resizing a mounted ext4 filesystem. I could easily reproduce it using
> 2.6.29-rc2, 2.6.28 and 2.6.27.
> 
> ext4_error was called just before the NULL derefence from
> ext4_get_group_desc, indicating a block group beyond s_groups_count.
> This function returned a NULL. The requested block group was beyond
> s_groups_count because this is the last changed bit when resizing.
> 
> The caller, ext4_group_used_meta_blocks, did not check the returned
> pointer. It needs the gdp anyway. Fortunately, its only caller,
> ext4_init_block_bitmap, has a gdp and it was simply a matter of adding
> this parameter to ext4_group_used_meta_blocks and use it.
> 
> Tested and the oops is gone.

This fixes the symptom, and the patch is a good thing to do since it
reduces the code size; but I don't think it fixes the root cause of
the problem.  The much bigger problem is in ext4_group_add around line
869 of fs/ext4/resize.c:

	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);   <-------

The problem here is that the group descriptor contains arbitrary
garbage here, so this should be:

	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);

instead.  What's happening is bg_flags contains random garbage, and if
happens to have the EXT4_BG_BLOCK_UNINIT bit set, then we end up
calling ext4_init_block_bitmap(), which causes the OOPS.  However, if
EXT4_BG_BLOCK_UNINIT is not set, then we don't end up going down this
code path --- which is why we didn't catch it in our testing, and why
the oops in BZ #12433 is somewhat hard to reproduce.

Fortunately having random bits in bg_flags is otherwise mostly
harmless, but this is clearly a bug.  Can you test and confirm this
also fixes your failure case?

						- Ted

commit 13e707e95258844c8872f1c4dcac4f0a545b8ef6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jan 26 19:06:41 2009 -0500

    ext4: Initialize the new group descriptor when resizing the filesystem
    
    Make sure all of the fields of the group descriptor are properly
    initialized.  Previously, we allowed bg_flags field to be contain
    random garbage, which could trigger non-deterministic behavior,
    including a kernel OOPS.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12433
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@kernel.org

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c328be5..c06886a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -861,12 +861,13 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	gdp = (struct ext4_group_desc *)((char *)primary->b_data +
 					 gdb_off * EXT4_DESC_SIZE(sb));
 
+	memset(gdp, 0, EXT4_DESC_SIZE(sb));
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	ext4_free_blks_set(sb, gdp, input->free_blocks_count);
 	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
-	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
