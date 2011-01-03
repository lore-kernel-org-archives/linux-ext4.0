From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Date: Mon, 3 Jan 2011 12:09:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101031208400.2815@dhcp-lab-213.englab.brq.redhat.com>
References: <1290700425-4094-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1101031202080.2815@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab1ACLJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 06:09:40 -0500
In-Reply-To: <alpine.LFD.2.00.1101031202080.2815@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Jan 2011, Lukas Czerner wrote:

> On Thu, 25 Nov 2010, Lukas Czerner wrote:
> 
> > When determining last group through ext4_get_group_no_and_offset() the
> > result may be wrong in cases when range->start and range-len are too
> > big, because it may overflow when summing up those two numbers.
> > 
> > Fix that by checking range->len and limit its value to
> > ext4_blocks_count(). This commit was tested by myself with expected
> > result.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/mballoc.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 5b4d4e3..7b05d92 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -4819,6 +4819,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
> >  	ext4_grpblk_t cnt = 0, first_block, last_block;
> >  	uint64_t start, len, minlen, trimmed;
> > +	ext4_fsblk_t blocks_count = ext4_blocks_count(EXT4_SB(sb)->s_es);
> >  	int ret = 0;
> >  
> >  	start = range->start >> sb->s_blocksize_bits;
> > @@ -4826,6 +4827,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  	minlen = range->minlen >> sb->s_blocksize_bits;
> >  	trimmed = 0;
> >  
> > +	if (len > blocks_count)
> > +		len = blocks_count - start;
> > +
> >  	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> >  		return -EINVAL;
> >  
> > 
> 
> Hi Ted,
> 
> what is the status of this one?
> 
> Thanks!
> -Lukas
> 

Oh, please ignore this, I just found "already applied" message. Sorry
for the noise.

-Lukas
