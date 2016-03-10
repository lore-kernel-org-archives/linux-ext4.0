From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix extent cache fragmentation
Date: Wed, 9 Mar 2016 23:35:13 -0500
Message-ID: <20160310043513.GC4937@thunk.org>
References: <1455010041-23082-1-git-send-email-dmonakhov@openvz.org>
 <20160222143741.GA10531@quack.suse.cz>
 <874mcy1hnv.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54626 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbcCJEfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2016 23:35:18 -0500
Content-Disposition: inline
In-Reply-To: <874mcy1hnv.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 24, 2016 at 03:17:40PM +0400, Dmitry Monakhov wrote:
> > So in principle this patch is fine but I hate how handling of extent status
> > tree is proliferating to fs/ext4/extent.c to handle some cases especially
> > through special function flags. So looking into the code, probably it would
> > make sense to move all updates of the extent status tree handling down into
> > ext4_ext_map_blocks() and ext4_ind_map_blocks(). Thoughts?
>
> Agree. This was my initial diea but patch was too big for stable
> releases. In fact this is not critical fix so we can simply make is
> in good way and simply ignore @stable. Will send updated version shortly.

Hi Dmitry,

Have you had a chance to come up with an updated patch?

Thanks,

						- Ted
