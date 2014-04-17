From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Thu, 17 Apr 2014 11:35:26 -0400
Message-ID: <20140417153526.GF18591@thunk.org>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56584 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaDQPfc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 11:35:32 -0400
Content-Disposition: inline
In-Reply-To: <20140416154209.GB17208@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I've been thinking about this some more, and it seems to me is
actually, what we need is *both* an LRU and a RR scheme.

The real problem here is that we have workloads that are generating a
large number of "low value" extent cache entries.  That is, they are
extremely unlikely to be used again, because they are small, and being
generated when you have a highly fragmented extent status cache, and
very often, the workload is a random read/write workload, so there is
no way the full "working set" of extent cache entries could be kept in
memory at the same time anyway.  These less valuable cache entries are
being generated at a very high rate, and we want to make sure we don't
penalize the "valuable" cache entries.

There's a classic solution to this problem for garbage collectors, and
that's to have a "nursery" and "tenured" space.  So what we could do
is to have two lists (as the proposed LRU improvement patch does), but
in the first list, we put the delalloc and "tenured" cache entries,
and in the second list we put the "nursery" cache entries.

The "nursery" cache items are cleaned using an RR scheme, and indeed,
we might want to have a system where we try to keep the "nursery"
cache items to a mangeable level, even if we aren't under memory
pressure.  If a cache item gets used a certain number of times, then
when we get to that item in the RR scheme, it gets "promoted" to the
"tenured" space.

The "tenured" space is then kept under control using some kind of LRU
scheme, and a target number of "tenured" items.  (We might or might
not want to count delalloc entries for the purposes of this target.
That's TBD.)

The system should ideally automatically tune itself to control the
promotion rate from the nursery to tenured space based on the number
of uses required before a cache entry gets promoted, and there will be
a bunch of hueristics that we'll need to tune.  But I think this
general approach should work pretty well.

What do other people think?

					- Ted

