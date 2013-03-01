From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: optimize ext4_es_shrink()
Date: Fri, 01 Mar 2013 10:40:37 -0600
Message-ID: <5130DA05.4070601@redhat.com>
References: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com> <20130227174553.GA224@x4> <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com> <20130227192907.GB14253@thunk.org> <20130227201217.GD14253@thunk.org> <20130301033005.GA7081@redhat.com> <20130301040039.GA4452@thunk.org> <20130301050029.GB4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Jones <davej@redhat.com>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3CAQkn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 11:40:43 -0500
In-Reply-To: <20130301050029.GB4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/28/13 11:00 PM, Theodore Ts'o wrote:
> When the system is under memory pressure, ext4_es_srhink() will get
> called very often.  So optimize returning the number of items in the
> file system's extent status cache by keeping a per-filesystem count,
> instead of calculating it each time by scanning all of the inodes in
> the extent status cache.
> 
> Also rename the slab used for the extent status cache to be
> "ext4_extent_status" so it's obviousl the slab in question is created
> by ext4.

Certainly better than walking an arbitrarily long list.  :)
So:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I was wondering a couple things, though - 

1) should this one be scaled by the vfs_cache_pressure sysctl?

2) Also, given that this is only for shrinker accounting, do we need the
precision of the atomic counter? I see that quota uses a per-cpu counter.
Would a percpu counter be any more efficient?  I'll follow
w/ a patch.

-Eric
