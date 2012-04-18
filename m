From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Thu, 19 Apr 2012 09:37:49 +1000
Message-ID: <20120418233749.GP6734@dastard>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAF89.5070805@redhat.com>
 <20120417184306.GA5916@thunk.org>
 <4F8DBC20.5010401@redhat.com>
 <20120418030208.GO6734@dastard>
 <20120418160717.GE5916@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57585 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab2DRXhx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 19:37:53 -0400
Content-Disposition: inline
In-Reply-To: <20120418160717.GE5916@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 18, 2012 at 12:07:17PM -0400, Ted Ts'o wrote:
> On Wed, Apr 18, 2012 at 01:02:08PM +1000, Dave Chinner wrote:
> > In actual fact, on my 12 disk RAID0 array, XFS is faster with
> > unwritten extents *enabled* than when hacked to turn them off. 
> 
> Can you explain why this is the case?  It seems... counterintuitive.

I'll admit that I was slightly surprised, too.

> The only explanation I can think of is that your code paths when
> unwritten extents are disabled haven't been optimized,

When unwritten extents are disabled, the IO takes the normal
overwrite/extending write path, which is as optimised as
the unwritten path because it is more commonly used.

> in which case
> the comparison between using and not using unwritten extents might not
> be valid.

It's and apples to apples comparison.

The code paths are identical on IO submission, the only difference
is the IO completion path. In the case of unwritten extents, it has
to do a transaction to convert the extents and update the file size.
In the case of the stale extent, it has to modify the file size
because the IO is beyond EOF.

My point, however, is that despite the complexity of unwritten
extent conversion it is not noticably more expensive than a file
size update transaction on XFS. Hence the reasoning for exposing
stale data due to unwritten conversion has too much overhead to be
useful is demonstratably false.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
