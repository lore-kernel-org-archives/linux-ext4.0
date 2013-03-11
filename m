From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 1/5] ext4: improve ext4_es_can_be_merged() to avoid a
 potential overflow
Date: Mon, 11 Mar 2013 14:03:31 +0800
Message-ID: <20130311060331.GB3867@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-2-git-send-email-wenqing.lz@taobao.com>
 <20130311004358.GA10090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35948 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3CKFsQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 01:48:16 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so3325292pbc.39
        for <linux-ext4@vger.kernel.org>; Sun, 10 Mar 2013 22:48:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130311004358.GA10090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 10, 2013 at 08:43:58PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 06, 2013 at 10:17:11PM +0800, Zheng Liu wrote:
> > +	if (ext4_es_status(es1) ^ ext4_es_status(es2))
> >  		return 0;
> >  
> > -	if (ext4_es_status(es1) != ext4_es_status(es2))
> 
> Did you have a reason why changed != to ^?  

Honestly, no.  Just because subconsciously I think bit operation is
faster than other operations, and in ext4_can_extents_be_merged() it
also use '^'.  So I guess there is an optimization.

> 
> It's identical from a functional perspective, but it's less obvious to
> future readers of the code what's going on.  I tried checking to see
> if GCC did any better optimizing the code, but it doesn't seem to make
> any difference.  I'm going to switch it back to !=....

Obviously I'm wrong.  Thanks for checking it.

> 
> > +	/* we need to check delayed extent is without unwritten status */
> > +	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
> > +		return 1;
> 
> I'm not sure why we need to check the unwritten status?  Under what
> circumstances would we have an extent marked as under delayed
> allocation but also unwritten?

We could do some buffered writes into a hole.  So the extent will be
with delayed status.  Before these extents are written out, user might
uses fallocate(2) to preallocate some blocks at the same offset.  Then
these extents are marked as unwritten status.  But we still need to keep
delayed status because later these extents will be written out and we
will update reserved space according to these extents, especially in a
bigalloc file system.

> 
> 							- Ted
> 
> This is how I've restructured this function for now mainly to make it
> easier to understand;
> 
> static int ext4_es_can_be_merged(struct extent_status *es1,
> 				 struct extent_status *es2)
> {
> 	if (ext4_es_status(es1) != ext4_es_status(es2))
> 		return 0;
> 
> 	if (((__u64) es1->es_len) + es2->es_len > 0xFFFFFFFFULL)
> 		return 0;
> 
> 	if (((__u64) es1->es_lblk) + es1->es_len != es2->es_lblk)
> 		return 0;
> 
> 	if ((ext4_es_is_written(es1) || ext4_es_is_unwritten(es1)) &&
> 	    (ext4_es_pblock(es1) + es1->es_len == ext4_es_pblock(es2)))
> 		return 1;
> 
> 	if (ext4_es_is_hole(es1))
> 		return 1;
> 
> 	/* we need to check delayed extent is without unwritten status */
> 	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
> 		return 1;
> 
> 	return 0;
> }

It looks good to me.

Thanks,
                                                - Zheng
