From: Theodore Tso <tytso@mit.edu>
Subject: Re: Checking of NULL with __GFP_NOFAIL in kzalloc()
Date: Mon, 2 Mar 2009 08:44:11 -0500
Message-ID: <20090302134411.GL6973@mit.edu>
References: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com> <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48399 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZCBNoR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2009 08:44:17 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 02, 2009 at 11:38:53AM +0530, Manish Katiyar wrote:
> On Sun, Mar 1, 2009 at 11:35 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> > Hi,
> >
> > While going through jbd code, I was wondering why do we need to check
> > new_transaction for NULL, if we are passing __GFP_NOFAIL ?
> > Last code change around this code was when Ted converted kmalloc to
> > kzalloc, but since he also didn't remove it I am guessing there would
> > be some good reason for it. Can someone enlighten me ?
> 
> I didn't receive any response to this. So probably removing the NULL
> check is harmless. Or should I remove the __GFP_NOFAIL flag and keep
> the error handling ?

We don't want to remove __GFP_NOFAIL here since returning an error
would cause the filesystem to be marked as corrupted, and so it's
better to simply ask the memory allocator to retry until it can
succeed, which is what GFP_NOFAIL does.

This isn't an excuse for using GFP_NOFAIL in journal_init_common(),
though; that's an example of a use of __GFP_NOFAIL that should go
away.  (Basically, if that fails, the mount will fail; we should
printk an explanatory message since the mount system call return
EINVAL, but failing a mount due to not enough memory is reasonable.
Marking the filesystem as corrupted, and remounting the filesystem
read-only and/or panic'ing the system is not.)

						- Ted
