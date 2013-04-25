From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
Date: Thu, 25 Apr 2013 15:27:08 +0200
Message-ID: <20130425132708.GB32353@quack.suse.cz>
References: <1365769446-22034-1-git-send-email-wenqing.lz@taobao.com>
 <20130425101249.GA16770@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab3DYN1K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Apr 2013 09:27:10 -0400
Content-Disposition: inline
In-Reply-To: <20130425101249.GA16770@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-04-13 18:12:49, Zheng Liu wrote:
> On Fri, Apr 12, 2013 at 08:24:06PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Now jbd_alloc_handle is only called by new_handle.  So this commit
> > uses kmem_cache_zalloc instead of kmem_cache_alloc/memset.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> Hi Jan,
> 
> Sorry, I forgot to Cc you.  Could you please take a look at this patch?
  Yeah, I must have missed it somehow. The patch looks fine, thanks. I've
added it to my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
