From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 3/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Thu, 4 Sep 2014 21:05:50 +0800
Message-ID: <20140904130550.GC13193@gmail.com>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
 <20140827135516.GB22211@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51869 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaIDM4Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2014 08:56:25 -0400
Received: by mail-pd0-f170.google.com with SMTP id r10so13575910pdi.29
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2014 05:56:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140827135516.GB22211@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2014 at 03:55:16PM +0200, Jan Kara wrote:
> On Thu 07-08-14 11:35:50, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Currently extent status tree doesn't cache extent hole when a write
> > looks up in extent tree to make sure whether a block has been allocated
> > or not.  In this case, we don't put extent hole in extent cache because
> > later this extent might be removed and a new delayed extent might be
> > added back.  But it will cause a defect when we do a lot of writes.
> > If we don't put extent hole in extent cache, the following writes also
> > need to access extent tree to look at whether or not a block has been
> > allocated.  It brings a cache miss.  This commit fixes this defect.
> > Meanwhile, if an inode has no any extent, this extent hole also will
> > be cached.
> > 
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>   So I agree with this change, it certainly doesn't make things worse. But
> when looking into ext4_ext_put_gap_in_cache() I have one question: That
> function uses ext4_find_delalloc_range() to check that the intended range
> doesn't have any delalloc blocks in it. However it doesn't make any effort
> to put a smaller hole in cache - for example if we have blocks allocated
> like:
> 
> 5-6 = delalloc
> 7-10 = allocated
> 
> and ext4_ext_put_gap_in_cache() is called for block 0, the function won't
> put anything into cache although it could put range 0-4 in the cache as a
> hole. Why is that?

Oops, it should put range 0-4 in the cache.  Thanks for pointing it out.
I will fix it.

Regards,
                                                - Zheng
