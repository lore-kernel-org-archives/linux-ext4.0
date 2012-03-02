From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext3: don't forget to discard last block in a
 group
Date: Fri, 2 Mar 2012 11:49:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203021149090.5178@dhcp-27-109.brq.redhat.com>
References: <1330609207-11755-1-git-send-email-lczerner@redhat.com> <1330609207-11755-2-git-send-email-lczerner@redhat.com> <20120302104211.GE1744@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab2CBKuD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 05:50:03 -0500
In-Reply-To: <20120302104211.GE1744@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2 Mar 2012, Jan Kara wrote:

> On Thu 01-03-12 14:40:07, Lukas Czerner wrote:
> > Currently we might omit to discard the last block in the group (max)
> > because of off-by-one condition error. This commit fixes the condition
> > so we always discard the whole range if possible.
>   I think this is actually caused by your previous patch because before it,
> max would be end_block+1 despite its name. So just fold this patch into the
> previous one please.
> 
> 								Honza

You're right. I'll fix this, thanks.

-Lukas

> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext3/balloc.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index e3a8d9e..997da27 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> > @@ -1970,7 +1970,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> >  	sbi = EXT3_SB(sb);
> >  
> >  	 /* Walk through the whole group */
> > -	while (start < max) {
> > +	while (start <= max) {
> >  		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
> >  		if (start < 0)
> >  			break;
> > @@ -1980,7 +1980,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> >  		 * Allocate contiguous free extents by setting bits in the
> >  		 * block bitmap
> >  		 */
> > -		while (next < max
> > +		while (next <= max
> >  			&& claim_block(sb_bgl_lock(sbi, group),
> >  					next, bitmap_bh)) {
> >  			next++;
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
