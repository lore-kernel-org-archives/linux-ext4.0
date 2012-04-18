From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 12:07:17 -0400
Message-ID: <20120418160717.GE5916@thunk.org>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAF89.5070805@redhat.com>
 <20120417184306.GA5916@thunk.org>
 <4F8DBC20.5010401@redhat.com>
 <20120418030208.GO6734@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36159 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab2DRQPU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 12:15:20 -0400
Content-Disposition: inline
In-Reply-To: <20120418030208.GO6734@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 18, 2012 at 01:02:08PM +1000, Dave Chinner wrote:
> In actual fact, on my 12 disk RAID0 array, XFS is faster with
> unwritten extents *enabled* than when hacked to turn them off. 

Can you explain why this is the case?  It seems... counterintuitive.

The only explanation I can think of is that your code paths when
unwritten extents are disabled haven't been optimized, in which case
the comparison between using and not using unwritten extents might not
be valid.

Is there anything going on other than _not_ mutating the extent tree
(and all of the logical journaling that would go along with it)?
Hacking to turn them off means it should be doing *less* work, so I
would expect at worst it would be the same speed as using extent
written extents.  If it's faster to use unwritten extents, something
very wierd must be going on....

					- Ted
