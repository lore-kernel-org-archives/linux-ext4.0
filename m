From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Tue, 13 Mar 2012 15:53:39 -0400
Message-ID: <20120313195339.GA24124@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Phillip Susi <phillsusi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57748 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2CMTxp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2012 15:53:45 -0400
Content-Disposition: inline
In-Reply-To: <4F5F9A97.5060404@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 13, 2012 at 03:05:59PM -0400, Phillip Susi wrote:
> Why not just separate the hash table from the conventional, mostly
> in inode order directory entries?  For instance, the first 200k of
> the directory could be the normal entries that would tend to be in
> inode order ( and e2fsck -D would reorder ), and the last 56k of the
> directory would contain the hash table.  Then readdir() just walks
> the directory like normal, and namei() can check the hash table.

Because that would be a format change.

What we have today is not a hash table; it's a hashed tree, where we
use a fixed-length key for the tree based on the hash of the file
name.  Currently the leaf nodes of the tree are the directory blocks
themselves; that is, the lowest level of the index blocks tells you to
look at directory block N, where that directory contains the directory
indexes for those file names which are in a particular range (say,
between 0x2325777A and 0x2325801).

If we aren't going to change the ordering of the directory directory,
that means we would need to change things so the leaf nodes contain
the actual directory file names themselves, so that we know whether or
not we've hit the correct entry or not before we go to read in a
specific directory block (otherwise, you'd have problems dealing with
hash collisions).  But in that case, instead of storing the pointer to
the directory entry, since the bulk of the size of a directory entry
is the filename itself, you might as well store the inode number in
the tree itself, and be done with it.

And in that case, since you are replicating the information directory
twice over, and it's going to be an incompatible format change anyway,
you might as well just store the second copy of the directory entries
in *another* btree, except this one is indexed by inode number, and
then you use the second tree for readdir(), and you make the
telldir/seekdir cookie be the inode number.  That way readdir() will
always return results in a stat() optimized order, even in the face of
directory fragmentation and file system aging.

**This** is why telldir/seekdir is so evil; in order to do things
correctly in terms of the semantics of readdir() in the face of
telldir/seekdir and file names getting inserted and deleted into the
btree, and the possibility for tree splits/rotations, etc., and the
fact that the cookie is only 32 or 64 bits, you essentially either
need to just do something stupid and have a linear directory aala ext2
and V7 Unix, or you need to store the directory information twice over
in redundant b-trees.

Or, userspace needs to do the gosh-darned sorting by inode, or we do
some hack such as only sorting the inodes using non-swapping kernel
memory if the directory is smaller than some arbitrary size, such as
256k or 512k.

						- Ted
