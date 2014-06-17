From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Metadata Checksums Include fs_uuid?
Date: Tue, 17 Jun 2014 12:47:48 -0400
Message-ID: <20140617164748.GA24890@thunk.org>
References: <e54129c593d975dcd28431a2c9b29438@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43524 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965197AbaFQQru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 12:47:50 -0400
Content-Disposition: inline
In-Reply-To: <e54129c593d975dcd28431a2c9b29438@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2014 at 09:38:35AM -0700, Joseph D. Wagner wrote:
> It appears to describe the file system UUID as part of the checksum.  Is
> that correct?

Yes, it is correct.

> I am a little concerned, because the UUID can be changed manually using
> tune2fs.  Does changing the UUID invalidate the checksums?  Does tune2fs
> update the checksums based upon the new UUID?

Tune2fs updates the checksums based on the new UUID, yes.

> Why does the file system UUID even need to be part of the checksum?

This allows us to detect metadata blocks (in particular, portions of
the inode table which haven't been cleared yet) from previous file
systems.

There is a question of what to e2fsck should do when a metadata
checksum is invalid.  We do need to make e2fsck smarter so it does the
right thing automatically.  So for example, if the block group
descriptor checksums are invalid, so we read the backup block group
descriptors, we know that the last inode initialized fields are not
accurate.  In that case, if an inode table block has an invalid
checksum, we could ignore those blocks automatically without bothering
the user about it.  If we did all of this, then we could skip the lazy
inode table initialization when metadata_csum is enabled, since that
tends to impact performance for the a few hours when the file system
is first mounted.

Cheers,

						- Ted
