From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: [patch 07/12] rfc: 2fsprogs update
Date: Wed, 27 Sep 2006 15:36:42 +0200
Message-ID: <20060927133642.GB25703@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144832.GG25755@openx1.frec.bull.fr> <20060926173700.GD4219@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:22695 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751190AbWI0Ngv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Sep 2006 09:36:51 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20060926173700.GD4219@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26, 2006 at 01:37:00PM -0400, Theodore Tso wrote:
> On Tue, Sep 26, 2006 at 04:48:32PM +0200, Alexandre Ratchov wrote:
> > convert all 32bit on-disk block number definitions (currently __u32,
> > blk_t, unsigned long, unsigned int...) to pblk_t that is defined as
> > __u32. In this way we are sure that blk_t is used only in memory.
> > Later, this would allow to make blk_t 64bit without disturbing any
> > programs (this would just eat more momory and use 64bit arithmetic).
> 
> I *really* dislike this approach, because it makes it very hard to
> prove that we got all of the conversions right --- any mistakes about
> which instances of blk_t need to become pblk_t, and which are supposed
> to stay blk_t, and we end up breaking our ABI compatibility.  And
> let's just say I have higher standards than Greg KH has shown with
> udev.  :-)    
> 
> I also don't like pblk_t, because it's not at all obvious what it
> means. 

It just means "__u32". It's used in very very few places. Mainly to access
on-disk indirect blocks, typically as follows:

		char *ind_block_buf;
		pblk_t *pblk;
		blk_t blk;

		...

		pblk = (pblk_t *)ind_block_buf;

		for (i = 0, ; i < N; i++) {
			blk = *pblk;
			...
			pblk++;
		}

So, the only purpose on the typedef is to "tag" 32bit variables that are
used for such purposes and that have to stay 32bit forever. I expect in the
long term to remove the typedef and to simply use __u32 in such code. For me
this patch is a "temporary stage" in order to avoid confusion between blk_t,
__u32, int, long, etc... and to do the 32bit -> 64bit convertion of block
numbers in a safe manner.

> And what if we want to support 64-bit logicial blocks someday?
> Then it's another painful exercise to figure out which blk_t get
> separated to lblk_t, etc.  
> 

i fully agree here; personnaly, i would like to see only one type for block
numbers: blk_t (or blk64_t if you prefer). And in some sense this patch
contributes to reduce the number of types we use for block numbers. Indeed,
it replaces most int, long, __u32 etc... by blk_t and pblk_t.

> 
> So my plan is to introduce a new type, blk64_t, and create new
> interfaces, such as ext2fs_extent_iterate(), which will use the new
> type --- and which will work with old-style indirect block inodes as
> well (it will translate indirect blocks into extents).

i think we want the same thing, except that i've called blk_t what you call
blk64_t.

In order to get the blk64_t interface working with old-style indirect block
inodes, we have to use __u32 pointers to access indirect blocks and blk64_t
for the rest. If we want to reuse the existing code, we have to walk through
it distinguishing between __u32, long, int, blk_t, and replacing some of them by
blk64_t. That's very close to what this patch does.

Perhaps it's not obvious, but thats my approach to get all of the
conversions right without rewriting everything from scratch ;-). I'm still
open to other approches.

cheers,

-- Alexandre
