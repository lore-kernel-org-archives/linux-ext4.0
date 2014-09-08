From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Mon, 8 Sep 2014 17:47:47 +0200
Message-ID: <20140908154747.GA8160@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
 <20140827150121.GC22211@quack.suse.cz>
 <20140903033738.GB2504@thunk.org>
 <20140903153122.GA17066@quack.suse.cz>
 <20140903200039.GM2504@thunk.org>
 <20140903221402.GD19005@quack.suse.cz>
 <20140903223805.GD12154@thunk.org>
 <20140904071553.GA26930@quack.suse.cz>
 <20140904154459.GE4047@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaIHPrv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2014 11:47:51 -0400
Content-Disposition: inline
In-Reply-To: <20140904154459.GE4047@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-09-14 11:44:59, Ted Tso wrote:
> On Thu, Sep 04, 2014 at 09:15:53AM +0200, Jan Kara wrote:
> >   Ah, sorry. I was mistaken and thought we do check for __GFP_FS in
> > ext4_es_scan() but we don't and we don't need to. But thinking about it
> > again - if we're going to always scan at most nr_to_scan cache entries,
> > there's probably no need to reduce s_es_lock latency by playing with
> > spinlock_contended(), right?
> 
> I'm more generally worried contention on s_es_lock, since it's a file
> system-wide spinlock that is grabbed whenever we need to add or remove
> an inode from the es_list.  So if someone were to try to run AIM7
> benchmark on a large core count machine on an ext4 file system mounted
> on a ramdisk, this lock would likely show up.
> 
> Now, this might not be a realistic scenario, but it's a common way to
> test for fs scalability without having a super-expensive RAID array,
> so it's quite common if you look at FAST papers over the last couple
> of years, for example..
> 
> So my thinking was that if we do run into contention, the shrinker
> thread should always yield, since if it gets slowed down slightly,
> there's no harm done.  Hmmm.... OTOH, the extra cache line bounce
> could potentially be worse, so maybe it would be better to let the
> shrinker thread do its thing and then get out of there.
  Yeah. I think cache bouncing limits scalability in a similar way spinlock
itself does so there's no big win in shortening the lock hold times. If
someone is concerned about scalability of our extent cache LRU, we could
use some more fancy LRU implementation like the one implemented in
mm/list_lru.c and used for other fs objects. But I would see that as a
separate step and only once someone can show a benefit...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
