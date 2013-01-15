From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [RFC] Optimizing readdir()
Date: Tue, 15 Jan 2013 08:21:43 +0100
Message-ID: <20130115072143.GA21506@laptop.redhat.com>
References: <20130113152204.GB26803@laptop.redhat.com>
 <20130114045152.GF29329@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab3AOHZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 02:25:22 -0500
Content-Disposition: inline
In-Reply-To: <20130114045152.GF29329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 11:51:52PM -0500, Theodore Ts'o wrote:
>On Sun, Jan 13, 2013 at 04:22:04PM +0100, Radek Pazdera wrote:
>> 
>> My idea was to try to add a second tree to the current index that would
>> be used to retrieve entries in inode-order. Its structure could be very
>> similar to the current HTree (the hash is 32bits and so are inode
>> numbers).
>
>Something to think about what the backwards compatibility impacts of
>this would be.  The current directory entries are indexed using
>*logical* block numbers, which means that if we ignore the directory
>htree blocks (which were deliberately crafted to look like deleted
>directory entries that were the size of the entire directory block),
>an htree-oblivious kernel (or the ext2 file system driver) would be
>able to interpret the directory entries as a traditional ext2
>directory.
>
>When you add this feature, you will almost certainly break this, at
>least for read/write forward compatibility.
>
>What I would suggest, if we do go down this path, is to store the
>secondary directory tree using physical block numbers, so the
>directory blocks are stored outside of the directory entirely.  That
>means you'll need to have a 64-bit block number, but it means that you
>won't have to do a lookup to translate the logical block number ot the
>physical block number.  It also means that there won't be any
>confusion about whether a particular directory entry block belongs to
>the htree-indexed tree or the inode-number-indexed tree.

Any new blocks to the directory file would have to be hidden in the same
manner as the current dx_nodes are. But placing them completely outside
of the directory file sounds much simpler. I haven't thought of that.

>If we want to make the file system be backwards compatible, this gets
>a bit more difficult, since the current code is not set up to handle
>the info_length to be anything other than 8.  This won't be a problem
>if you want to make the feature be completely backwards incompatible,
>but if you want to allow at least read/only compatibility, you might
>want to stick 64-bit block number at the end of the dx_root block
>(this is why the directory checksum is in the dx_tail structure).

Oh, I didn't realize that. I'll need to think about the impact on
backwards and forwards compatibility a little more. I didn't think
that through as much as I thought I did. I would like to break as
few things as possible.

>I wonder if the better approach is to just simply have some
>easy-to-use library routines that do a readdir/sort in userspace.  The
>spd_readdir does basically this, and as we can see it's good enough
>for most purposes.  The problem is danger when using this in threaded
>programs, or if you have programs doing really strange things with
>telldir/seekdir, etc.

I think this approach is great in the specific cases when you know you are
going to have to deal with large dirs and your system can accommodate for
the additional memory required to keep the whole directory file. But they
can grow pretty quickly in the worst-case scenario of really long names.

The size would have to be limited (probably?) for security reasons (as it
is in the spd_readdir) accordingly to the memory available on the target
machine.

>But it wouldn't be that hard to write a generic library function which
>if it were used for find, ls, tar, and a few other key programs, would
>solve the problem for most use cases.

I'm not sure if the possibility of allocating a fair amount of memory
would be acceptable for these basic operations. They can be used on a
variety of embedded devices that might have a problem with using
something similar to scandir(3) (as Stewart pointed out) for reading
a directory.

>Cheers,
>
>						- Ted

Thank you very much for the feedback!

Cheers,

-Radek
