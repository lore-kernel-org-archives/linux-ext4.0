From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: e2fsck performance for large lost+found dirs
Date: Mon, 2 Nov 2015 15:42:02 -0800
Message-ID: <20151102234202.GA2213@birch.djwong.org>
References: <62BDBCF1-B82A-449C-BFDD-84AF76CC829E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46008 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbbKBXmI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2015 18:42:08 -0500
Content-Disposition: inline
In-Reply-To: <62BDBCF1-B82A-449C-BFDD-84AF76CC829E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 02, 2015 at 03:49:38PM -0700, Andreas Dilger wrote:
> Running e2fsck on a filesystem with a large number of disconnected inodes
> can take a long time to complete.   This can happen with Lustre, since there
> may be hundreds of thousands of inodes in one directory, and extent corruption
> can wipe out the whole directory (more on that in a separate email).

Or the case I saw a few months ago where a client had a 35-million-entry
directory which was corrupt and had to be fixed... the reason for it being
that large was that it was not possible to give each department in this large
bureaucracy its own directory "for reasons of political expediency". :)

(XFS, but still...)

> It is a very lengthy O(n^2) operation to reattach all disconnected inodes
> to lost+found, which can take a long time if there are millions of them.
> 
> 
> It would be much more efficient to keep a cursor pointing to the last leaf
> block in the directory in which an entry was inserted. Since e2fsck is not
> deleting entries from lost+found, and because the entry names are always
> getting longer (due to scanning in increasing inode number order) there is
> no value to search earlier blocks again. This would make lost+found insertion
> O(1) and significantly improve e2fsck performance in this case. This could be
> very fast since there is only the inode bitmap to traverse, and filenames are
> "#ino" so only leaf block allocation and writes needed.

Agreed.

> For generic libext2fs usage (e.g. Darrick's FUSE interface) where entries
> may be deleted from a directory, the cursor could be reset to the block of
> any deleted entry, if it was at a lower offset.
> 
> Darrick, at one time I thought you had a patch to fix this behaviour, but
> I couldn't find it.  Maybe your patch was related to a similar O(n^2) search
> problem with block allocation?

Hmm... sorry, I don't recall ever doing that.

(Bad memory, however.  Too many patches.)

> Any thoughts about how to fix this?  I was originally thinking that I could
> just cache this into the "file pointer", but no such thing exists in the
> ext2fs_link() interface, only the directory inode number is passed, and it
> has an additional level of indirection in that it calls the block iterator
> with a callback to process each leaf block separately.  It also has the
> problem that any cache would be local to ext2fs_link() and not visible to
> ext2fs_unlink().
> 
> I was thinking to start with ext2fs_link() calling ext2fs_dir_iterate2()
> directly, just to avoid the first level of confusion in this code.  That
> still doesn't allow passing a starting offset for the iteration, however.
> 
> Next, cache the block number into the link_struct state and skip the leaf
> block searches if block number < cursor, but that still needs iterating
> over all the blocks to skip to the last one.
> 
> Should I just call ext2fs_block_iterate2() in e2fsck_reconnect_file()
> and keep the mechanics local to e2fsck?  I thought it might be a good
> generic optimization, but the interfaces make this difficult.

Uggghhh.... :)

So I started to look at ext2fs_link -> ext2fs_dir_iterate2 ->
ext2fs_block_iterate3, to see if there was a way to skip to the last block.
There isn't any such thing, currently.

How about this: create a new flags value for ext2fs_link which means "only
search the last block".  Weirdly, the flags argument at the moment seems to
provide the ftype entry for the directory, nothing more.  So this new flag
would have to be filtered out of flags before it gets used as ftype.

Next we create a similar "last block only" flag for dir_iterate2 so that we
can convey the append-only intent to the directory iterator, which could take
a shortcut in which instead of calling the block iterator, it would instead
ext2fs_bmap2() to find the pblk of the last directory block and call the
function ext2fs_process_dir_block on that last block.

This isn't /quite/ as efficient as simply storing a cursor, but I don't know
of a non-messy way for a client program to stuff state into a libext2 call.

<shrug>

--D

> 
> Cheers, Andreas
> 
> 
> 
> 
> 


