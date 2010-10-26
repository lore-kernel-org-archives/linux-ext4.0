From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] ext4: Add batched discard support for ext4
Date: Tue, 26 Oct 2010 14:43:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010261426350.3107@dhcp-lab-213.englab.brq.redhat.com>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com> <1285596600-28358-4-git-send-email-lczerner@redhat.com> <20101025185010.GH16981@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, adilger@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721Ab0JZMnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 08:43:14 -0400
In-Reply-To: <20101025185010.GH16981@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Oct 2010, Ted Ts'o wrote:

> On Mon, Sep 27, 2010 at 04:09:59PM +0200, Lukas Czerner wrote:
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 93eb6c2..80a5139 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
>       ....
> > +	struct ext4_buddy e4b;
> > +	ext4_fsblk_t first_group, last_group;
> 
> This should be ext4_group_t, shouldn't it?  

Right, it should be. Sorry about that.

> 
> > +	/* Determine first and last group to examine based on start and len */
> > +	first_group = (start - le32_to_cpu(es->s_first_data_block)) /
> > +		      EXT4_BLOCKS_PER_GROUP(sb);
> > +	last_group = (start + len - le32_to_cpu(es->s_first_data_block)) /
> > +		     EXT4_BLOCKS_PER_GROUP(sb);
> 
> I've tried compiling this for 32-bit x86, and this blows up because
> you can't divide long long's in the kernel.  (This is what do_div is
> for, and it's why ext4_get_group_no_and_offset() exists.)

I am ashamed, I probably should test patches on different architectures.
Thanks.

> 
> > +	first_block = (start - le32_to_cpu(es->s_first_data_block)) %
> > +			EXT4_BLOCKS_PER_GROUP(sb);
> > +	last_block = EXT4_BLOCKS_PER_GROUP(sb);
> 
> This means that the ext4 FITRIM ioctl will trim to the end of the
> blockgroup, and not just to the last block specified by the user.  Is
> this intentional?

If the group is NOT last group, or (start+len) is aligned to the
EXT4_BLOCK_PER_GROUP() boundary we will trim all blocks in this
particular block group. Otherwise we will know how much we need to trim
in this group to satisfy user request

	if (len >= EXT4_BLOCKS_PER_GROUP(sb))
		len -= (EXT4_BLOCKS_PER_GROUP(sb) - first_block);
	else
		last_block = len;

because we do keep track of how many block we need to trim by
decreasing len.

> 
> Also, it looks like there's nothing to check for the last blockgroup,
> where the last block might be less than a grpblk_t offset of
> EXT4_BLOCKS_PER_GROUP()?

This is not a problem, because when traversing the bitmap we will hit
the end of the group anyway, because those blocks (out of filesystem) are
marked as used in the bitmap and hence:

	start = mb_find_next_zero_bit(bitmap, max, start);
		if (start >= max)
			break;

will end the traversing without any attempt to trim blocks out of
filesystem boundary.

> 
> 						- Ted
> 

-Lukas
