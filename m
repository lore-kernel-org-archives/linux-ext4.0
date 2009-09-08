From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 8 Sep 2009 17:41:21 -0400
Message-ID: <20090908214121.GR22901@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com> <20090908050614.GA10477@mit.edu> <6601abe90909080757r23faeabbt7dcdfa3d5daf5985@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58363 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbZIHVlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 17:41:23 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909080757r23faeabbt7dcdfa3d5daf5985@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 07:57:02AM -0700, Curt Wohlgemuth wrote:
> 
> I think we can take a look at this, but there are a lot of calls to
> ext4_handle_dirty_metadata(), and it's not clear on a quick inspection
> that we'd be able to determine which would need to be called with
> do_sync = 1...

Well, it's already the case that ext4_handle_dirty_metadata is a
#define:

#define ext4_handle_dirty_metadata(handle, inode, bh) \
	__ext4_handle_dirty_metadata(__func__, (handle), (inode), (bh))

So all we need to do is change it to be:

#define ext4_handle_dirty_metadata(handle, inode, bh) \
	__ext4_handle_dirty_metadata(__func__, (handle), (inode), (bh), 0)

#define ext4_handle_dirty_metadata_sync(handle, inode, bh) \
	__ext4_handle_dirty_metadata(__func__, (handle), (inode), (bh), 1)

And then add the extra function parameter to
__ext4_handle_dirty_metadata().  Hey, presto!  :-)

> On the other hand, this would take care of a similar problem that I
> was going to be sending a patch for this week: where removing an
> extent block without a journal requires a sync_dirty_buffer() in order
> to avoid writeback of the extent header in the block, *after* the
> block is marked free in the bitmap.

As I mentioned in the other message, the other thing we can do is to
use bforget(); that is more efficient than using sync_dirty_buffer(),
since it eliminates the write altogether.  Since the file has been
deleted, there's no point writing the dirty buffer out; simply using
bforget() to drop the dirty buffer is all that is necessary.

Regards,

						- Ted
