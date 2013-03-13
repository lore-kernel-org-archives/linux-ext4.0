From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: mke2fs with bigalloc is too slow
Date: Wed, 13 Mar 2013 15:00:16 -0400
Message-ID: <20130313190016.GE5604@thunk.org>
References: <CAA0+VHz9+LpS9jGbTEE_OE9kvgdXDqj3qMQQV5kTTJ12WDxMPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53189 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab3CMTAV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 15:00:21 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHz9+LpS9jGbTEE_OE9kvgdXDqj3qMQQV5kTTJ12WDxMPg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 13, 2013 at 08:04:57PM +0400, Andrey Sidorov wrote:
> 
> It takes 29 seconds to format 1TB partition as ext4 with 256k cluster
> size on MIPS. e2fsprogs version is 1.42.7.
> The most time consumer is ext2fs_convert_subcluster_bitmap which folds
> 30M into 500K walking through block bitmap bit by bit. Afair, it takes
> less time on x86 since there are asm bit ops for x86, but mips uses
> generic ones.

Actually, these days we use a rbtree to encode the bitmap.  That means
that it should be possible to create a very efficient find_first_set
and find_first_zero functions.  This would work especially well for
mke2fs since the allocation bitmap will be mostly empty.  This I think
would improve things dramatically.

> First thing I did is allocated per-cluster bitmap instead of per-block
> bitmap in ext2fs_initialize so that conversion doesn't occur. That
> dropped mke2fs time from 29s to 2.5s. e2fsck -f found this fresh fs as
> a good one and mounting/writing/reading/unmounting also went good. Of
> course groups are allocated at different offsets and about 60M of
> usable space are lost if compared to 'slow' formatting. That's fine,
> we can live with that.
> Are there any long-term consequences that I've missed? Are there any
> reasons for using block bitmap instead of cluster bitmap except for
> meta-data space efficiency?

Fragmenting the block allocation bitmaps slows down operations that
need to read in multiple block bitmaps in sequence.  This includes
dumpe2fs, e2fsck, and in some cases, block allocation.  So making this
change is not zero-cost.  I agree that 30 seconds for mke2fs is
non-optimal, but I'm surprised you're finding this to be a
showstopper.  I assume you're worried about substantially bigger file
systems than just 1TB?

					- Ted
