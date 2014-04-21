From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Mon, 21 Apr 2014 22:46:46 +0800
Message-ID: <20140421144646.GB19966@gmail.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
 <20140421135007.GA19966@gmail.com>
 <20140421140523.GF14869@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56075 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaDUOkY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2014 10:40:24 -0400
Received: by mail-pd0-f173.google.com with SMTP id z10so3737990pdj.18
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2014 07:40:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140421140523.GF14869@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2014 at 10:05:23AM -0400, Theodore Ts'o wrote:
[...]
> > Second question is about your deeply thought.  From your comment, it
> > seems that now we need a replacement algorithm that looks like we do in
> > memory management subsystem.  Now in memory management subsystem, we
> > have an active list and an inactive list which tracks some pages.  When
> > the system read/write some pages, these pages will be put on inactive
> > list.  Then if some pages are accessed again, they will be promoted into
> > active list.  When 'kswapd' thread tries to reclaim some pages, it will
> > drop some pages from inactive list and demote some pages from active
> > list to inactive list.  I am happy to give it a try later.
> 
> Yes, although we'll need to be careful that we don't introduce
> scalability problems caused by needing to take too many locks.  So I
> don't think we want to move items from the inactive to active list
> when the extent cache is referenced.  Instead, we'll probably want to
> bump a ref count in the cache entry, and then in the shrinker, when we
> scan the inactive list, we can check the ref count and decide then to
> move the item to the active list.  That way, only the shrinker needs
> to take the global lock.

I am not sure that I fully understand your meaning.  AFAIU, we have a
list which uses RR scheme to shrink extent caches.  In this list it
tracks written/unwrittten/hole extent caches.  When the shrinker tries
to reclaim some objects, it will scan this list and reclaim all extent
caches whose ref count are less than a number.  Meanwhile the ref count
of rest caches will be decreased and moved into active list.  In active
list it tracks all delayed extent caches, precached extent caches and
other caches that have been promoted.  The shrinker uses LRU algorithm
to reclaim objects from active list.  Please let me know if I miss
something.

Regards,
                                                - Zheng
