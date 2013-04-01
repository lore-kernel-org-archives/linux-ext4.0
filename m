From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Mon, 1 Apr 2013 11:39:52 -0400
Message-ID: <20130401153952.GE4731@thunk.org>
References: <87d2uese6t.fsf@openvz.org>
 <5159A55B.1090302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57825 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab3DAPj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:39:59 -0400
Content-Disposition: inline
In-Reply-To: <5159A55B.1090302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 10:18:51AM -0500, Eric Sandeen wrote:
> I'd add:
> 
> 3) Why do we have a "nodelalloc" mount option at all?
> 
> but then I thought:
> 
> Is it also this bad when using the ext4 driver to run an ext3 fs?

Yes, and I there would be a similar performance problem if you are
using the ext3 file system driver, since ext3_*_writepage() also ends
up calling block_write_full_page() which will also result in the
writes happening with WRITE_SYNC.

The main reason why we keep nodelalloc at this point is bug-for-bug
compatibility with ext3 file systems --- basically, for users who are
using this as a workaround for the O_PONIES issue instead of fixing
their applications to use fsync() appropriately.

So another question is how much do we care about exact emulation of
ext3's behaviour for those distributions who wish to use ext4 file
system driver for ext2 and ext3 file systems?

One of the reasons for keeping nodealloc mode was the argument was
that it removing it wouldn't really allow us to remove that much
complexity from ext4.  But adding a nodealloc specific ext4_writepages
pages would result in adding a huge amount of complexity, and my first
reaction is that it's really not worth the code maintenance headache.
Dmitry, is there a reason why you are especially worried about the
performace of nodelalloc mode?

	       	      	       	   	- Ted
