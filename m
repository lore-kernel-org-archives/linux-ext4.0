From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: How to understand get_dx_countlimit?
Date: Fri, 3 Aug 2012 14:33:20 -0400
Message-ID: <20120803183320.GU58276@kernel.stglabs.ibm.com>
References: <50194231.5030303@gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:47076 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2HCSdj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2012 14:33:39 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 3 Aug 2012 12:33:39 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id B34A71FF0023
	for <linux-ext4@vger.kernel.org>; Fri,  3 Aug 2012 18:33:32 +0000 (WET)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q73IXNLF098988
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2012 12:33:23 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q73IXMnn016283
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2012 12:33:23 -0600
Content-Disposition: inline
In-Reply-To: <50194231.5030303@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 10:50:25PM +0800, Wang Sheng-Hui wrote:
> Dear all,
> 
> Sorry to trouble you! 
> 
> I'm confused by the namei.c/get_dx_countlimit.
> This function seems support metadata checksum for dir/dx.
> 
> I wonder what kind of dirent would meet:
> 
>     le16_to_cpu(dirent->rec_len) == EXT4_BLOCK_SIZE(inode->i_sb)
> 
> The tail dirent of one dir block?

This case usually indicates that there's one big "empty" dirent that's hiding
some dx hash tree data.  These ought to be non-root dx tree nodes.

> And the case "le16_to_cpu(dirent->rec_len) == 12"?

In a hashed directory, the first block (i.e. the root of the dx tree, if there
even is a tree) uses the first 24 bytes to present dirents for "." and "..".  The
remaining space is a big "empty" dirent that hides the root of the dx tree.

> I suspect these kinds of dirents are the tail ones, but
> I cannot figure out the physical layout for one dir block
> with metadat checksum, e.g in which case we would have dirents
> meet the conditions in the function get_dx_countlimit?

FYI, there's some (slightly out of date) additional reference data at
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout.

Before hashed directories, a directory file consisted of variable-length
dirents that weren't in any particular order.  The dirents are packed in
such a way that they do not cross $BLOCKSIZE (usually 4KiB) boundaries.  To add
metadata checksumming to one of these classic dirent blocks, I create an empty
"dirent" in the last 12 bytes of the block that looks deleted, and stuff the
crc32 into the name field.  Obviously, if there's no room in the block then
e2fsck has to rebuild the directory.

When hashed directories were added, it was desired to retrofit them into the
existing directory file structure in such a way that the old code could read
the directory file without getting confused by the tree data.  Furthermore, it
was decided that tree data should not be mixed in with regular dirents, i.e.
given a block in a directory, it either contains tree data or dirents pointing
to inodes, but not both.

To accomplish that, a block containing tree data is given a dirent header that
doesn't point to an inode ("null dirent"), since dirents that don't point to
valid inodes are skipped over by the old ext2 code.  The dirent header claims
to take up all the space in the block, and the tree data goes in the space that
normally stores the file name.  If metadata checksumming is enabled, the last
dx_entry in the tree block is reserved for storing the checksum.

There is one exception to what I just wrote -- the old ext2 code expects the
first block of a directory file to contain (at offset zero) two dirents
pointing to "." and "..".  Therefore, the root of the tree is encapsulated
inside a null dirent (just like the non-root nodes, as I describe above) but
the null dirent begins 24 bytes into that first block, instead of at the very
beginning of the block.

Hope that doesn't muddy the situation any more....

--D
> 
> Any explanations are welcomed!
> 
> Thanks,
> Sheng-Hui
> 

