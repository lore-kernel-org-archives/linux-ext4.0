From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in mainline?)
Date: Tue, 4 Aug 2009 14:18:51 -0400
Message-ID: <20090804181850.GF9324@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell> <20090804144846.GE28678@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Cc: Julia Lawall <julia@diku.dk>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jesper Andersen <jespera@diku.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087AbZHDSS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 14:18:56 -0400
Content-Disposition: inline
In-Reply-To: <20090804144846.GE28678@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 04, 2009 at 10:48:46AM -0400, Theodore Tso wrote:
> 
> If you want to start preparing for the semantic patches by preparing
> and testing the receipes, and then helping to flag those patches that
> contain some changes that contain some changes that can't be applied
> via spatch, that would be helpful.
> 
> Does that sound like a plan?

That sounds great.  We won't be able to automate everything, but after
this exercise, I bet spatch will be able to automate most of it.

Jesper, the patches you'll be interested in can be found in the
shared-64bit branch of:

git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

If getting these out of git is at any trouble at all, please ask and
I'll send them as plain patches.  The obvious candidates are things
like:

Author: Valerie Aurora Henson <vaurora@redhat.com>
Date:   Tue Feb 3 13:15:19 2009 -0800

    parse_num_blocks() -> parse_num_blocks2()

More difficult and interesting projects include:

Author: Valerie Aurora Henson <vaurora@redhat.com>
Date:   Tue Feb 3 13:15:19 2009 -0800

    New accessor functions for block group descriptor variables.

And the following three patches.  I attached a (huge) .cocci script
that I used to do part of that conversion.  I'm looking forward to
your professional version of it. :) This is a good patch for testing
newline fixup features.

-VAL

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="group_desc.cocci"

// Checksum
@@
ext2_filsys fs;
expression group, flag;
@@

-fs->group_desc[group].bg_checksum
+ext2fs_bg_checksum(fs, group)


// Get/set block/inode counts
@@
ext2_filsys fs;
expression group;
identifier blk;
expression E;
@@
(
// Free blocks
-blk = fs->group_desc[group].bg_free_blocks_count
+blk = ext2fs_bg_free_blocks_count(fs, group)
|
-fs->group_desc[group].bg_free_blocks_count = E
+ext2fs_bg_free_blocks_count_set(fs, group, E)
|
// Free inodes
-blk = fs->group_desc[group].bg_free_inodes_count
+blk = ext2fs_bg_free_inodes_count(fs, group)
|
-fs->group_desc[group].bg_free_inodes_count = E
+ext2fs_bg_free_inodes_count_set(fs, group, E)
|
// Used dirs
-blk = fs->group_desc[group].bg_used_dirs_count
+blk = ext2fs_bg_used_dirs_count(fs, group)
|
-fs->group_desc[group].bg_used_dirs_count = E
+ext2fs_bg_used_dirs_count_set(fs, group, E)
|
// Unused inode table blocks
-blk = fs->group_desc[group].bg_itable_unused
+blk = ext2fs_bg_itable_unused(fs, group)
|
-fs->group_desc[group].bg_itable_unused = E
+ext2fs_bg_itable_unused_set(fs, group, E)
)

// Increment/decrement block/inode counts
// I tried to create an isomorphism for this, but I failed.
@@
ext2_filsys fs;
expression group, i;
@@
(
// Free blocks
-fs->group_desc[group].bg_free_blocks_count++
+ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+1)
|
-fs->group_desc[group].bg_free_blocks_count--
+ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-1)
|
-fs->group_desc[group].bg_free_blocks_count += i
+ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+i)
|
-fs->group_desc[group].bg_free_blocks_count -= i
+ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-i)
|
// Free inodes
-fs->group_desc[group].bg_free_inodes_count++
+ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group)+1)
|
-fs->group_desc[group].bg_free_inodes_count--
+ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group)-1)
|
-fs->group_desc[group].bg_free_inodes_count += i
+ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group)+i)
|
-fs->group_desc[group].bg_free_inodes_count -= i
+ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group)-i)
|
// Used dirs
-fs->group_desc[group].bg_used_dirs_count++
+ext2fs_bg_used_dirs_count_set(fs, group, ext2fs_bg_used_dirs_count(fs, group)+1)
|
-fs->group_desc[group].bg_used_dirs_count--
+ext2fs_bg_used_dirs_count_set(fs, group, ext2fs_bg_used_dirs_count(fs, group)-1)
|
-fs->group_desc[group].bg_used_dirs_count += i
+ext2fs_bg_used_dirs_count_set(fs, group, ext2fs_bg_used_dirs_count(fs, group)+i)
|
-fs->group_desc[group].bg_used_dirs_count -= i
+ext2fs_bg_used_dirs_count_set(fs, group, ext2fs_bg_used_dirs_count(fs, group)-i)
|
// Unused inode table blocks
-fs->group_desc[group].bg_itable_unused++
+ext2fs_bg_itable_unused_set(fs, group, ext2fs_bg_itable_unused(fs, group)+1)
|
-fs->group_desc[group].bg_itable_unused--
+ext2fs_bg_itable_unused_set(fs, group, ext2fs_bg_itable_unused(fs, group)-1)
|
-fs->group_desc[group].bg_itable_unused += i
+ext2fs_bg_itable_unused_set(fs, group, ext2fs_bg_itable_unused(fs, group)+i)
|
-fs->group_desc[group].bg_itable_unused -= i
+ext2fs_bg_itable_unused_set(fs, group, ext2fs_bg_itable_unused(fs, group)-i)
)

// Get a pointer to a whole dang descriptor
@@
ext2_filsys fs;
expression group;
@@
-&fs->group_desc[group]
+ext2fs_group_desc(fs, fs->group_desc, group)

// Block group flags
@@
ext2_filsys fs;
expression group, flag;
@@
(
-fs->group_desc[group].bg_flags & flag
+ext2fs_bg_flag_test(fs, group, flag)
|
-fs->group_desc[group].bg_flags &= ~flag
+ext2fs_bg_flag_clear(fs, group, flag)
|
-fs->group_desc[group].bg_flags |= flag
+ext2fs_bg_flag_set(fs, group, flag)
|
-fs->group_desc[group].bg_flags = 0
+ext2fs_bg_flags_clear(fs, group, 0)
)

// Block group bitmap/table locations
@@
ext2_filsys fs;
expression group, E;
@@
(
-fs->group_desc[group].bg_block_bitmap = E
+ext2fs_block_bitmap_loc_set(fs, group, E)
|
-fs->group_desc[group].bg_block_bitmap
+ext2fs_block_bitmap_loc(fs, group)
|
-fs->group_desc[group].bg_inode_bitmap = E
+ext2fs_inode_bitmap_loc_set(fs, group, E)
|
-fs->group_desc[group].bg_inode_bitmap
+ext2fs_inode_bitmap_loc(fs, group)
|
-fs->group_desc[group].bg_inode_table = E
+ext2fs_inode_table_loc_set(fs, group, E)
|
-fs->group_desc[group].bg_inode_table
+ext2fs_inode_table_loc(fs, group)
|
-fs->group_desc[group].bg_free_blocks = E
+ext2fs_bg_free_blocks_count_set(fs, group, E)
|
-fs->group_desc[group].bg_free_blocks_count
+ext2fs_bg_free_blocks_count(fs, group)
|
-fs->group_desc[group].bg_free_inodes_count = E
+ext2fs_bg_free_inodes_count_set(fs, group, E)
|
-fs->group_desc[group].bg_free_inodes_count
+ext2fs_bg_free_inodes_count(fs, group)
|
-fs->group_desc[group].bg_used_dirs_count = E
+ext2fs_bg_used_dirs_count_set(fs, group, E)
|
-fs->group_desc[group].bg_used_dirs_count
+ext2fs_bg_used_dirs_count(fs, group)
|
-fs->group_desc[group].bg_itable_unused = E
+ext2fs_bg_itable_unused_set(fs, group, E)
|
-fs->group_desc[group].bg_itable_unused
+ext2fs_bg_itable_unused(fs, group)
)

--2fHTh5uZTiUOsy+g--
