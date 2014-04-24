From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Thu, 24 Apr 2014 11:46:13 +1000
Message-ID: <20140424014613.GU18672@dastard>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
 <20140421231002.GC15995@dastard>
 <20140423053520.GA9041@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53951 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaDXBqR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2014 21:46:17 -0400
Content-Disposition: inline
In-Reply-To: <20140423053520.GA9041@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 23, 2014 at 01:35:21PM +0800, Zheng Liu wrote:
> On Tue, Apr 22, 2014 at 09:10:02AM +1000, Dave Chinner wrote:
> > On Thu, Apr 17, 2014 at 11:35:26AM -0400, Theodore Ts'o wrote:
> > > So I've been thinking about this some more, and it seems to me is
> > > actually, what we need is *both* an LRU and a RR scheme.
> > 
> > We already have shrinker implementations that do this. It would
> > probably take 10-15 lines of code to add it to any existing LRU
> > list based shrinker.....
> 
> Hi Dave,
> 
> I guess that you are talking about lru list in include/linux/list_lru.h.
> Thanks for pointing it out, and I will take a look at it.

No, I'm not - that's just the linked list implementation.

I'm talking about the use of referenced bits on the objects
themselves, and how the shrinker treats them. i.e. the I_REFERENCED
state bit in the inode, and DCACHE_REFERENCED on the dentry.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
