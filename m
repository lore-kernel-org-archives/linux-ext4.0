From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/7 v2] ext4: add physical block and status member into
 extent status tree
Date: Fri, 18 Jan 2013 17:49:34 +0800
Message-ID: <20130118094934.GA20442@gmail.com>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-4-git-send-email-wenqing.lz@taobao.com>
 <20130117044213.GA19734@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48873 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3ARJfm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 04:35:42 -0500
Received: by mail-pb0-f43.google.com with SMTP id jt11so579010pbb.30
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 01:35:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130117044213.GA19734@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2013 at 11:42:13PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 11, 2013 at 06:53:43PM +0800, Zheng Liu wrote:
> >  struct extent_status {
> >  	struct rb_node rb_node;
> >  	ext4_lblk_t es_lblk;	/* first logical block extent covers */
> >  	ext4_lblk_t es_len;	/* length of extent in block */
> > +	ext4_fsblk_t es_pblk;	/* first physical block */
> > +	int es_status;		/* record the status of extent */
> >  };
> 
> Given that we only support 48 bits for the physical block number, and
> we only need two bits for es_status, one thing we could do to save
> memory is to stash the es_status bits in the top two bits of es_pblk.

Thanks for the comment.  In next version, es_status will be stashed into
es_pblk.

Regards,
                                                - Zheng
