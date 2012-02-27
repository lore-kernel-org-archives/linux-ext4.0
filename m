From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 18:57:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202271838330.5540@dhcp-27-109.brq.redhat.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <20120227170011.GB1651@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	psusi@ubuntu.com, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2B0R6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 12:58:02 -0500
In-Reply-To: <20120227170011.GB1651@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Feb 2012, Ted Ts'o wrote:

> On Fri, Feb 24, 2012 at 09:34:50AM +0100, Lukas Czerner wrote:
> > Previously when running e2fsck with '-E discard' argument the end of
> > the last group has not been discarded. This patch fixes it so we
> > always discard the end of the last group if needed.
> > 
> > This commit also removes unneeded argument from the
> > e2fsck_discard_blocks(). Simultaneously the commit causes the block
> > groups with BLOCK_UNINIT flag not to be discarded, which makes
> > since because we do not need to reclaim the space since so far
> > there has not been written anything.
> 
> Let me ask the question Phillip is asking a different way.  What's the
> *benefit* in not issuing a discard for blocks in block groups where
> the block bitmap is marked as unitialized, as opposed to simply
> issuing discard for all blocks that are not marked as in use?  Are you
> trying to optimize the amount of time that the storage device spends
> processing the trim commands?  Do you think issuing discards on space
> that is already discarded will somehow cause more wear on SSD's?
> 
>      			       	       	     	  - Ted
> 

Hi Ted,

exactly. I am trying to benefit from the same optimization e2fsck does.
If the BLOCK_UNINIT is set then we can easily leave that group be and
save some time. Even though that might not be a huge problem with small
file systems, or some *really* fast SSD's, you'll certainly notice it on
huge thin-provisioned storage, or generally any bigger discard capable
device.

I do not think that issuing discards on already discarded space would
somehow wear off the SSD's, however this might not be true for some ancient
disks, or the small cheap flashes. I know that the "common sense" tells
us that when there is nothing to discard, it should be really cheap
operation, however that is not the case. From what I have seen so far
the discard time of non-provisioned regions is almost the same as on
provisioned regions.

Note that on today SSD's discard should be relatively fast (I have not
actually tested any recent device though), this is not the case of some
older SSD and it certainly is not the case for thin-provisioned storage
appliances. The situation is even worse that this storage might be
significantly bigger than todays SSD's.

Moreover device mapper tp target should now support discard as well, so
we can have relatively big thin-provisioned storage which is common enough
and we certainly want to optimize for that, not some obscure case when
people dd their fs on tp targets.

However if we want to implement what Phillip suggested - mark the block
group UNINIT again when the became entirely free - then we'll have to
deal with that somehow. Possibly new ?BLOCK_UNUSED? flag, but it is
different problem to solve.

Oh, and it reminds me that we should take advantage of the BLOCK_UNINIT
flag in FITRIM implementation as well. I am working on the patches.

Thanks!
-Lukas
