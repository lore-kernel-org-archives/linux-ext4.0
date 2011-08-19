From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Flush any pending end_io requests before
 O_direct read on dioread_nolock
Date: Fri, 19 Aug 2011 16:57:22 -0400
Message-ID: <20110819205722.GA3578@thunk.org>
References: <20110819012845.7A4A32012F@ruihe2.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57192 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab1HSU50 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Aug 2011 16:57:26 -0400
Content-Disposition: inline
In-Reply-To: <20110819012845.7A4A32012F@ruihe2.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 06:28:45PM -0700, Jiaying Zhang wrote:
> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  	}
>  
>  retry:
> -	if (rw == READ && ext4_should_dioread_nolock(inode))
> +	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> +		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
> +			mutex_lock(&inode->i_mutex);
> +			ext4_flush_completed_IO(inode);
> +			mutex_unlock(&inode->i_mutex);
> +		}

Doesn't this largely invalidate the reasons for using dioread_nolock
in the first place, which was to avoid taking the i_mutex for
performance reasons?  If we are willing to solve the problem this way,
I wonder if we be better off just simply telling users to disable
dioread_nolock if they care about cache consistency between DIO reads
and buffered writes?  

(Yes, I do understand that in the hopefully common case where a user
is not trying to do buffered writes and DIO reads at the same time,
we'll just take and release the mutex very quickly, but still, it's
got to have a performance impact.)

I seem to recall a conversation I had with Stephen Tweedie over a
decade ago, where he noted that many other Unix systems made
absolutely no cache consistency guarantees with respect to DIO and the
page cache, but he wanted to set a higher standard for Linux.  Which
is fair enough, but I wonder if for the case of dioread_nolock, since
its raison d'etre is to avoid the i_mutex lock, to simply just say
that one of the side effects of dioread_nolock is that (for now) the
cache consistency guarantees are repealed if this mount option is
chosen.

What do folks think?

					- Ted
