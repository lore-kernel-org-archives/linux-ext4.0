From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Wed, 16 Apr 2014 11:42:09 -0400
Message-ID: <20140416154209.GB17208@thunk.org>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55181 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161615AbaDPPmP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 11:42:15 -0400
Content-Disposition: inline
In-Reply-To: <20140416151938.GA17208@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 11:19:38AM -0400, Theodore Ts'o wrote:
> 
> 1) We should first fix __ext4_es_shrink so that we interpret
> nr_to_scan correctly --- it's the number of objects to scan, not the
> number of objects that we need to shirnk.  That should significantly
> reduce the number of scans that we do, and fixing this could
> potentially influence the metrics that we measure.

I've been looking at this more closely, and what we're doing isn't as
bad as I thought.  We only return the number of extents that are not
subject delayed allocation, and the number of items we shrink is equal
to the number of objects that we scan.

It may be, however, that the better way to do this is to return the
number of items in the extent status cache (i.e., including the
delalloc extents), and then skip the delalloc extents.  That way the
VM knows how much work we are doing, and it is balancing the amount of
work that our shrinker is doing against the other shrinkers.  If there
are no cache entries that can be freed (because they are all delalloc
entries), we could then return SHRINK_STOP.

That should help in particular with the really pathalogical workloads
where we have a large number of delalloc extents.

							- Ted
