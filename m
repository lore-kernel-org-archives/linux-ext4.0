From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Mon, 25 Feb 2013 17:57:21 +0800
Message-ID: <20130225095721.GA23984@gmail.com>
References: <87obfcs1x6.fsf@openvz.org>
 <20130224145837.GA3722@gmail.com>
 <87zjys3hza.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:39106 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab3BYJm1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2013 04:42:27 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so1398424dae.17
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2013 01:42:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87zjys3hza.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 12:39:21PM +0400, Dmitry Monakhov wrote:
> On Sun, 24 Feb 2013 22:58:37 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > Hi Dmirty,
> > 
> > On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
> > [snip]
> > > From 65c5fc212b1c684c76899c6e5e1f24d88550c6fc Mon Sep 17 00:00:00 2001
> > > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > > Date: Fri, 22 Feb 2013 20:55:52 +0400
> > > Subject: [PATCH] ext4 add sanity ext4_es_lookup_extent
> > > 
> > > This patch does very simple thing: it recheck result returned from
> > > ext4_es_lookup_extent() by comparing it old-good lookup via
> > > ext4_{ind,ext}_map_blocks() under i_data_sem
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > I try to apply the following patch in my tree, but I realize that it
> > seems that we couldn't add this sanity check in ext4_map_blocks and
> > ext4_da_map_blocks now.  The reason is that when we try to initialize an
> > unwritten extent this extent could be zeroed out.  But we could know it
> > in *_map_blocks, and status tree couldn't be updated.  So we will hit a
> > BUG_ON(1) after added this sanity check.
> This means that extent-status tree should be updated once zeroout
> happen.
> 
> > 
> > I agree with you that we need to add self-testing infrastructre after
> > applied status tree patch series.  But it seems that we need to mix
> > updating status tree code with extent tree code.  IMHO it is too
> > complicated.  Any thought?
> Many developers have invested significant amount of man-hours in to 
> ext4's delay allocation state machine. It is now known as stable and reliable
> So it reasonable to use it as a primary for self-testing of
> extent-status tree. If es_cache != real_state this is means that we have
> forget to update es_cache.
> For example when extents was introduced it have many self testing things
> such as:
> 1) CHECK_BINSEARCH__: Which recheck binarry search result.
>         
> 2) AGGRESSIVE_TEST : Which force deep extent tree constructions and
>                      allow to cover unusual branches.
> 3) DOUBLE_CHECK : Recheck block alloc bitmap one more time

Thanks for your reminder.  I will add it.

> 
> I strongly believe in testing. Ext4 is production-grade filesystem
> so we can not break it in the name of new features, unless we are sure
> that features are safe and valuable, that's why investments in
> self-testing infrastructure for ES should have very high priority.
> But off course Theodore's decision whenever feature is looks stable
> enough to get ready go upstream.

Yes, I agree with you that we shouldn't break a production-grade file
system.  Certainly Ted has the final decision.

Regards,
                                                - Zheng
