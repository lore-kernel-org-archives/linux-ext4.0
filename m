From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 20:54:03 -0400
Message-ID: <20110603005403.GB27129@redhat.com>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1FCAyK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 20:54:10 -0400
Content-Disposition: inline
In-Reply-To: <20110603004300.GE16306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 08:43:00PM -0400, Ted Ts'o wrote:
> On Thu, Jun 02, 2011 at 08:27:14PM -0400, Vivek Goyal wrote:
> > 
> > In this case only a single thread is doing IO continuously. I am assuming
> > if there is a database using XFS, it is not unreasonable to have prolonged
> > periods of continuous IO activity. In that case I think by above design
> > sync will not finish until and unless there is a momentary pause in IO. This
> > does not sound like the best design choice.
> 
> Sure, but under what circumstances would a database be blasting data
> using AIO/DIO in one thread, and calling fsync() in another thread?
> In practice I don't think this situation should ever arise.  If it
> did, the question of which writes could be considered safely on stable
> store and which would not would be undefined.  In fact, for most
> enterpise databases, they are using preallocated files, so there's no
> need at all to use fsync() and AIO/DIO at the same time.

In this case I had done "sync" while aio-stress was doing O_DIRECT writes.
I really don't have any real world example, I just cooked up a hypothetical
scenario.

Just wondering why ext4 and XFS behavior are different and which is a
more appropriate behavior. ext4 does not seem to be waiting for all
pending AIO/DIO to finish while XFS does.

Thanks
Vivek
