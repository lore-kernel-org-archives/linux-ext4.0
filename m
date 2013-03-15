From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: mke2fs with bigalloc is too slow
Date: Fri, 15 Mar 2013 10:28:44 -0400
Message-ID: <20130315142844.GA7403@thunk.org>
References: <CAA0+VHz9+LpS9jGbTEE_OE9kvgdXDqj3qMQQV5kTTJ12WDxMPg@mail.gmail.com>
 <20130313190016.GE5604@thunk.org>
 <CAA0+VHx5=hYPOefnA-5eTrwFMtsg4sLujCLB91fGx2eoZrP0+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53630 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab3COO2r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Mar 2013 10:28:47 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHx5=hYPOefnA-5eTrwFMtsg4sLujCLB91fGx2eoZrP0+w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 15, 2013 at 01:53:58AM +0400, Andrey Sidorov wrote:
>
> Oh, thanks for pointing that! I was mostly reading v1.42 that is more
> than year old and missed the fact 1.42.7 has rbtree bitmap
> implementation.
> That explains why formatting bigalloc became slower compared to 1.42.
> In this case ffs/ffz seem like a right choice, I'll try them. I'll
> also try mirroring as it won't waste much RAM and might be faster.

As you'll discover fairly quickly, we haven't implemented ffs/ffz for
rbtree bitmaps yet.  We've implemented find_first_zero for for
bitarrays (and for the generic bitmap framework in lib/ext2fs/bitops.h
and lib/ext2fs/gen_bitmap*.c), but not in lib/ext2fs/blkmap64_rb.c
yet.  More critically for the mke2fs's use case in
convert_subcluster_bitmap, will be the find_first_set operation.

Adding this has been on my todo list for a while, but I just haven't
had the time.  Note that test cases for this will be critically
important, especially if we start using them in correctness-critical
code such as e2fsck.

                                                - Ted

