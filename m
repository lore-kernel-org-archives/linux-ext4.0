From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 13:02:08 +1000
Message-ID: <20120418030208.GO6734@dastard>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAF89.5070805@redhat.com>
 <20120417184306.GA5916@thunk.org>
 <4F8DBC20.5010401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26185 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2DRDCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2012 23:02:13 -0400
Content-Disposition: inline
In-Reply-To: <4F8DBC20.5010401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 17, 2012 at 01:53:20PM -0500, Eric Sandeen wrote:
> On 4/17/12 1:43 PM, Ted Ts'o wrote:
> > On Tue, Apr 17, 2012 at 01:59:37PM -0400, Ric Wheeler wrote:
> >>
> >> You could get both security and avoid the run time hit by fully
> >> writing the file or by having a variation that relied on "discard"
> >> (i.e., no need to zero data if we can discard or track it as
> >> unwritten).
> > 
> > It's certainly the case that if the device supports persistent
> > discard, something which we definitely *should* do is to send the
> > discard at fallocate time and then mark the space as initialized.
> > 
> > Unfortunately, not all devices, and in particular no HDD's for which I
> > aware support persistent discard.  And, writing all zero's to the file
> > is in fact what a number of programs for which I am aware (including
> > an enterprise database) are doing, precisely because they tend to
> > write into the fallocated space in a somewhat random order, and the
> > extent conversion costs is in fact quite significant.  But writing all
> > zero's to the file before you can use it is quite costly; at the very
> > least it burns disk bandwidth --- one of the main motivations of
> > fallocate was to avoid needing to do a "write all zero pass", and
> > while it does solve the problem for some use cases (such as DVR's),
> > it's not a complete solution.
> 
> Can we please start with profiling the workload causing trouble, see why
> ext4 takes such a hit, and see if anything can be done there to fix
> it surgically, rather than just throwing this big hammer at it?
> 
> In my (admittedly quick, hacky) test, xfs suffed about a 1% perf degradation,
> ext4 about 8%.  Until we at least know why ext4 is so much worse, I'll
> signal a strong NAK for this change, for whatever may or may not be worth.  :)

In actual fact, on my 12 disk RAID0 array, XFS is faster with
unwritten extents *enabled* than when hacked to turn them off. Yes,
you can turn off unwritten extent tracking in XFS if you know what
you are doing, we just don't provide any interfaces to users to do
so because of all the security problems it entails.

The result (using 256MB prealloc file, 2000 sparse 4k block writes,
one with O_SYNC, the other done async with a post write sync), with
averages over 5 runs are:

		O_SYNC		post-sync
unwritten	7.297s		5.734s
stale		7.641s		6.108s

These results are consistently repeatable, and only reinforce the
point that if ext4 is slow using unwritten extent tracking, then
it's an implementation problem and not an excuse to add an interface
to expose stale data....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
