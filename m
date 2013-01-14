From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] Optimizing readdir()
Date: Sun, 13 Jan 2013 23:51:52 -0500
Message-ID: <20130114045152.GF29329@thunk.org>
References: <20130113152204.GB26803@laptop.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43196 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3ANEv5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jan 2013 23:51:57 -0500
Content-Disposition: inline
In-Reply-To: <20130113152204.GB26803@laptop.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 04:22:04PM +0100, Radek Pazdera wrote:
> 
> My idea was to try to add a second tree to the current index that would
> be used to retrieve entries in inode-order. Its structure could be very
> similar to the current HTree (the hash is 32bits and so are inode
> numbers).

Something to think about what the backwards compatibility impacts of
this would be.  The current directory entries are indexed using
*logical* block numbers, which means that if we ignore the directory
htree blocks (which were deliberately crafted to look like deleted
directory entries that were the size of the entire directory block),
an htree-oblivious kernel (or the ext2 file system driver) would be
able to interpret the directory entries as a traditional ext2
directory.

When you add this feature, you will almost certainly break this, at
least for read/write forward compatibility.

What I would suggest, if we do go down this path, is to store the
secondary directory tree using physical block numbers, so the
directory blocks are stored outside of the directory entirely.  That
means you'll need to have a 64-bit block number, but it means that you
won't have to do a lookup to translate the logical block number ot the
physical block number.  It also means that there won't be any
confusion about whether a particular directory entry block belongs to
the htree-indexed tree or the inode-number-indexed tree.

If we want to make the file system be backwards compatible, this gets
a bit more difficult, since the current code is not set up to handle
the info_length to be anything other than 8.  This won't be a problem
if you want to make the feature be completely backwards incompatible,
but if you want to allow at least read/only compatibility, you might
want to stick 64-bit block number at the end of the dx_root block
(this is why the directory checksum is in the dx_tail structure).

I wonder if the better approach is to just simply have some
easy-to-use library routines that do a readdir/sort in userspace.  The
spd_readdir does basically this, and as we can see it's good enough
for most purposes.  The problem is danger when using this in threaded
programs, or if you have programs doing really strange things with
telldir/seekdir, etc.

But it wouldn't be that hard to write a generic library function which
if it were used for find, ls, tar, and a few other key programs, would
solve the problem for most use cases.

Cheers,

						- Ted
