From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Tue, 22 Apr 2014 09:10:02 +1000
Message-ID: <20140421231002.GC15995@dastard>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25147 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbaDUXKH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2014 19:10:07 -0400
Content-Disposition: inline
In-Reply-To: <20140417153526.GF18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 11:35:26AM -0400, Theodore Ts'o wrote:
> So I've been thinking about this some more, and it seems to me is
> actually, what we need is *both* an LRU and a RR scheme.

We already have shrinker implementations that do this. It would
probably take 10-15 lines of code to add it to any existing LRU
list based shrinker.....

> The real problem here is that we have workloads that are generating a
> large number of "low value" extent cache entries.  That is, they are
> extremely unlikely to be used again, because they are small, and being
> generated when you have a highly fragmented extent status cache, and
> very often, the workload is a random read/write workload, so there is
> no way the full "working set" of extent cache entries could be kept in
> memory at the same time anyway.  These less valuable cache entries are
> being generated at a very high rate, and we want to make sure we don't
> penalize the "valuable" cache entries.

Yup, an "object referenced" bit that gets set on a cache lookup hit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
