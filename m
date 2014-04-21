From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Mon, 21 Apr 2014 10:54:16 -0400
Message-ID: <20140421145416.GA18564@thunk.org>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
 <20140421135007.GA19966@gmail.com>
 <20140421140523.GF14869@thunk.org>
 <20140421144646.GB19966@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51777 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaDUOyV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2014 10:54:21 -0400
Content-Disposition: inline
In-Reply-To: <20140421144646.GB19966@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2014 at 10:46:46PM +0800, Zheng Liu wrote:
> I am not sure that I fully understand your meaning.  AFAIU, we have a
> list which uses RR scheme to shrink extent caches.  In this list it
> tracks written/unwrittten/hole extent caches.  When the shrinker tries
> to reclaim some objects, it will scan this list and reclaim all extent
> caches whose ref count are less than a number.  Meanwhile the ref count
> of rest caches will be decreased and moved into active list.  In active
> list it tracks all delayed extent caches, precached extent caches and
> other caches that have been promoted.  The shrinker uses LRU algorithm
> to reclaim objects from active list.  Please let me know if I miss
> something.

Yes, that's right.  I misunderstood your analogy to how it's like the
MM.  It is much like the page aging algorithm in that the work done by
the MMU is very minimal, and most of the work is done in the scanning
algorithm.  It might be that a pure "clock algorithm", would work
better than something which is closer to a GC like scheme with a
"tenured" and "nursery" space".  It certainly would be simpler to
implement.

So it's certainly something that's worth considering.

Cheers,

						- Ted
