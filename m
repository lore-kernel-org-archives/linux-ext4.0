From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] handle journal checksum errors via ext4_error()
Date: Sun, 8 Nov 2009 16:34:09 -0500
Message-ID: <20091108213409.GB7592@mit.edu>
References: <4AF1BBD0.3050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZKHVeK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 16:34:10 -0500
Content-Disposition: inline
In-Reply-To: <4AF1BBD0.3050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 04, 2009 at 11:37:20AM -0600, Eric Sandeen wrote:
> As the code stands today, journal checksum errors on the root fs,
> resulting in only a partial journal replay, result in no kernel
> messages and no error condition, because it is all handled under
> a "!(sb->s_flags & MS_RDONLY)" test - and the root fs starts out
> life in RO mode.
> 
> It seems to me that just calling ext4_error() here is almost the
> right thing to do; it will unconditionally mark the fs with errors,
> and act according to the selected mount -o errors= behavior...
> 
> However, for the root fs, ext4_error will be short-circuited because
> the root is mounted readonly; and in fact these errors came into
> being while we were writing to a read-only fs during journal recovery.
> So we won't do a journal_abort or anything like that, and other than
> a printk and an error flag, not much action is taken for a
> partially-recovered fs.  Does this seem like enough?
> 
> Should we just let the root fs carry on if it's been partially-recovered,
> and therefore pretty well known to be corrupt?

I think we need to do more, especially since there will be a large
number of desktop/laptop systems that only have a single root file
system.  Given that we are willing to modify the file system to replay
the journal and deal with the orphaned inode list, even when it is
mounted read-only, I think we should temporarily mark the file-system
read/write, before calling ext4_error(), and then restore the
file-system back to read-only status if we return from ext4_error().

That way when the init scripts run fsck, we'll at least get a forced
fsck to clean up the file system afterwards.

Given that we've seen how disatrous things can be when we abort a
journal replay several checksums before the end, I think we really
need to think about adding per-block checksums, so that in the case
where the block is later overwritten by a subsequent transaction
(which is quite likely for most metadata blocks, especially block or
inode allocation bitmaps), we have a better chance of recovering from
a failed checksum.  Once we have per-block checksums, even if we don't
have a newer version of the block, it may be that we're better off
continuing to replay subsequent commits, and just not write the block
where we know the checksum is bad, on the theory that while we will
still need to run fsck afterwards, there will likely be less damage to
repair...

The other thing which we might do is see if we can be more aggressive
checkpointing transactions, since if the blocks have been written to
the final lcoation on disk, it doesn't matter if there was a failure
writing them to the journal.  This obviously has performance
implications, though.

						- Ted
