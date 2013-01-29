From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Ext3: remove a useless check for the function
 ext3_free_blocks_sb
Date: Tue, 29 Jan 2013 12:08:09 -0500
Message-ID: <20130129170809.GB4261@thunk.org>
References: <51045F97.9070602@gmail.com>
 <20130128140757.GB32246@quack.suse.cz>
 <510765B1.7000100@gmail.com>
 <20130129144014.GE32246@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46043 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab3A2RIS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 12:08:18 -0500
Content-Disposition: inline
In-Reply-To: <20130129144014.GE32246@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2013 at 03:40:14PM +0100, Jan Kara wrote:
> > As we know the block to be freed can not be superblock and GDT..
> > I don't see any check about it in ext2/ext3/ext4....
>   Yes, you are right we apparently don't check for superblock or GDT
> blocks. But checking for those will be a bit more complex and they are
> really scarce so I don't think it's worth the overhead.

We actually do have code to test for that in ext4.  Take a look at
fs/ext4/block_validity.c.  We normally only check to make sure the
data block is within the file system bounds, but if you mount the file
system with the block_validity, it will actually check to make sure
the block being allocated or freed is not part of the superblock, GDT,
allocation bitmaps, or inode table.

I use this mount option when running my xfstests, just to add an
additional level of checking.  It's not enabled by default, since it
does increase CPU usage.  I suspect it would only be visible for
benchmarks such as TPC-C, but it's not something we've actually
measured to see if we could afford to enable by default.

The other major short coming is that we don't update the system zone
after an online resize, which means we don't protect the newly
metadata blocks until the next time the file system is mounted.  If we
added updating after a online resize, we'd also have to add some kind
of locking to protect the rbtree while it is being changed, and this
would increase its overhead if people wanted to use it in production.
We might be able to use RCU to avoid doing a real hard lock, but it's
not something that I've considered high priority.

If someone wanted to look at this, it would actually be a pretty good
starter project for someone who wanted to get started with doing ext4
hacking.

Cheers,

						- Ted
