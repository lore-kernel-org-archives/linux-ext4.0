From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Date: Tue, 6 Sep 2011 08:26:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1109060821420.4596@dhcp-27-109.brq.redhat.com>
References: <1315233249-27167-1-git-send-email-lczerner@redhat.com> <4E659E71.7050008@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1IFG0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 02:26:14 -0400
In-Reply-To: <4E659E71.7050008@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Sep 2011, Tao Ma wrote:

> Hi Lucas,
> On 09/05/2011 10:34 PM, Lukas Czerner wrote:
> > In ext4_trim_fs it is possible that start+len might overflow. Fix it by
> > decrementing the len so that start+len equals to the file system size in
> > the worst case.
> Actually start + len can never overflow since they are changed by
> start = range->start >> sb->s_blocksize_bits;
> len = range->len >> sb->s_blocksize_bits;
> 
> range->start and range->len are u64, and after they are shifted with
> blocksize_bits, start+len(ext4_fsblk_t is also 64bit) can't overflow.
> 
> Thanks
> Tao

Hi Tao,

I am really sorry for badly worded commit description. The problem is
real, however as you pointed out the overflow does not happen in
len+start addition but in ext4_get_group_no_and_offset() when we are
storing group number into the ext4_group_t which is 32 bit long, but
the result of do_div() might be bigger than that.

I will rephrase the commit description and resend the patch. I was doing
similar thing for xfs and I have just used almost the same description
which is wrong.

Thanks!
-Lukas

> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/mballoc.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 17a5a57..d86dc14 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -4952,14 +4952,18 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  	uint64_t start, len, minlen, trimmed = 0;
> >  	ext4_fsblk_t first_data_blk =
> >  			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
> > +	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
> >  	int ret = 0;
> >  
> >  	start = range->start >> sb->s_blocksize_bits;
> >  	len = range->len >> sb->s_blocksize_bits;
> >  	minlen = range->minlen >> sb->s_blocksize_bits;
> >  
> > -	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> > +	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)) ||
> > +	    unlikely(start > max_blks))
> >  		return -EINVAL;
> > +	if (unlikely(len > max_blks))
> > +		len = max_blks - start;
> >  	if (start + len <= first_data_blk)
> >  		goto out;
> >  	if (start < first_data_blk) {
> 
> 

-- 
