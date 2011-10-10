From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: "- 8" in EXT2_MAX_BLOCKS_PER_GROUP
Date: Mon, 10 Oct 2011 13:11:51 -0700
Message-ID: <20111010201151.GM12447@tux1.beaverton.ibm.com>
References: <4E931453.3010002@redhat.com> <4E933CD0.4050003@redhat.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52729 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1JJULl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 16:11:41 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p9AJuKVa003289
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 15:56:20 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9AKBe9Y229576
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 16:11:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9AKBd2i030052
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 17:11:39 -0300
Content-Disposition: inline
In-Reply-To: <4E933CD0.4050003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 10, 2011 at 01:43:28PM -0500, Eric Sandeen wrote:
> On 10/10/11 10:50 AM, Eric Sandeen wrote:
> > When looking at the maximal filesystem size issue, I found myself
> > wondering what the "- 8" is in here, it's not commented
> > or documented anywhere:
> > 
> > #define EXT2_MAX_BLOCKS_PER_GROUP(s)    (((1 << 16) - 8) *      \
> >                                           (EXT2_CLUSTER_SIZE(s) / \
> >                                            EXT2_BLOCK_SIZE(s)))
> > 
> > 
> > (pre-bigalloc, it was just ((1 << 16) - 8) )
> > 
> > Anyone know?
> 
> Ah, Darrick pointed out
> 
> http://osdir.com/ml/file-systems.ext2.devel/2006-03/msg00032.html
> 
> So it would have been - 1, to not overflow __u16, but since we have
> multiples of 8, we get - 8.
> 
> But now we have bg_free_blocks_count_hi, giving us 32 bits of counter.
> With EXT4_FEATURE_INCOMPAT_64BIT, MAX_BLOCKS_PER_GROUP should grow, no?

As far as I know, each group contains a block bitmap that is exactly 1 block
long, and block can be no longer than 4096 bytes in length.  Therefore, a group
can have no more than 4096 * 8 = 32768 blocks, correct?  To get more we'd have
to allow blocks larger than 4K (mkfs won't allow that) or change the disk
format to allow multi-block block bitmaps.

Unless of course a block bitmap can be the size of a cluster.... which afaict
is not the case.

--D
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
