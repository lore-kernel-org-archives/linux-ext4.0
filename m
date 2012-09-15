From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Sat, 15 Sep 2012 14:30:23 -0400
Message-ID: <20120915183023.GA9895@thunk.org>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50830 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab2IOSaa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Sep 2012 14:30:30 -0400
Content-Disposition: inline
In-Reply-To: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 10, 2012 at 11:55:48AM -0000, Carlos Maiolino wrote:
> htree_dirblock_to_tree() declares a non-initialized 'err' variable,
> which is passed as a reference to another functions expecting them
> to set this variable with thei error codes.  It's passed to
> ext4_bread(), which then passes it to ext4_getblk(). If
> ext4_map_blocks() returns 0 due to a lookup failure, leaving the
> ext4_getblk() buffer_head uninitialized, it will make ext4_getblk()
> return to ext4_bread() without initialize the 'err' variable, and
> ext4_bread() will return to htree_dirblock_to_tree() with this
> variable still uninitialized.

Hi Carlos,

Thanks for noticing this problem!

In the case where there is no block mapping for a particular block,
ext4_bread() can return NULL, and with your patch, *err will now be
zero instead of some uninitialized value.  That's an improvement, and
in the case of htree_dirblock_to_tree(), when we return 0 as an
"error", the caller will do the right thing.

But there are other places where when ext4_bread() returns NULL with
err set to 0, the function ends up returning err, i.e., in ext4_add_entry:

		bh = ext4_bread(handle, dir, block, 0, &retval);
		if(!bh)
			return retval;

... which will cause the caller of ext4_add_entry() to think that the
function had succeeded.

In the case of directories, there is never supposed to "holes" in
directories, so the right thing to do is to check to see if err = 0
and in that case to call ext4_error() to mark the file system as being
inconsistent, and then returning some kind of error like -EIO.

So your patch is an improvement, but I'm worried that there were cases
where we had been returning some uninitialized, non-zero stack
garbage, we had been serendipously treating the case of a directory
hole as an "error", now we we consider that situation as a "success"
even though the calling function (such as ext4_add_entry) had not
completed its processing.  Which is a very long-winded way of saying
that we need to audit all of the functions which call ext4_bread() so
that they do the right thing when ext4_bread() returns NULL and err is
set to zero.

Regards,

						- Ted
