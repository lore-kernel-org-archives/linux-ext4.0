From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Mon, 28 May 2007 12:10:59 -0400
Message-ID: <20070528161059.GC16941@thunk.org>
References: <20070522161127.GC13633@duck.suse.cz> <20070523123743.GD5608@thunk.org> <20070528160420.GD21509@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54206 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758470AbXE1QLD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2007 12:11:03 -0400
Content-Disposition: inline
In-Reply-To: <20070528160420.GD21509@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 28, 2007 at 06:04:20PM +0200, Jan Kara wrote:
>   OK, but then you could move the code to drop_inode() which is called at
> exactly that moment... I've been thinking more about it when fixing UDF.
> Discarding prealloc at drop_inode() has the disadvantage that
> symlinks/directories will keep their preallocated blocks until inodes are
> evicted from memory. Which is probably why ext2 discards prealloc on
> iput().

We should never be preallocating for symlinks (it just doesn't make
any sense), and for directories, it usually doesn't make sense,
either.  I don't recall that ext2 did preallocation for
symlinks/directories; I seem to recall it was only for normal files.
If it isn't, I'd argue that's a bug that should be fixed.

In either case, discarding on iput() doesn't help since we don't hold
a reference count on the inode, but rather the dentry .

>   OK, but still we could use e.g. i_writecount to check that we drop the
> last descriptor for writing...

That would be better, yes.

						- Ted
