From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 21:11:29 -0400
Message-ID: <20110603011129.GG16306@thunk.org>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
 <20110603005403.GB27129@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34902 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab1FCBLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 21:11:33 -0400
Content-Disposition: inline
In-Reply-To: <20110603005403.GB27129@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 08:54:03PM -0400, Vivek Goyal wrote:
> 
> In this case I had done "sync" while aio-stress was doing O_DIRECT writes.
> I really don't have any real world example, I just cooked up a hypothetical
> scenario.
> 
> Just wondering why ext4 and XFS behavior are different and which is a
> more appropriate behavior. ext4 does not seem to be waiting for all
> pending AIO/DIO to finish while XFS does.

I think this is something we can chalk up to "different
implementations do different things".  I'm not convinced either
behviour is wrong per se.  Granted, the recent work to make sync and
fsync not livelock in the face of continuing writes means that I'm
more happy with ext4's behaviour, but I don't think that means xfs's
behavior is wrong.

One of the things that I have thought about is sysctl which makes sync
a no-op unless you are root.  The reason for that is that many system
administrators sometimes have a habit of typing sync, and on a heavily
loaded production server, this can really cause performance to go to
hell for up to tens of minutes.  So it might make sense to not allow
non-root users from trashing overall system performance by running
sync....

						- Ted
