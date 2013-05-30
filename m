From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] 285: Test offsets over 4GB
Date: Fri, 31 May 2013 08:34:14 +1000
Message-ID: <20130530223414.GR29466@dastard>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
 <1369917939-22660-3-git-send-email-jack@suse.cz>
 <51A758A8.80502@redhat.com>
 <20130530200118.GC586@quack.suse.cz>
 <51A7B0EE.1010300@redhat.com>
 <20130530204921.GD586@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:29570 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab3E3WeQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 18:34:16 -0400
Content-Disposition: inline
In-Reply-To: <20130530204921.GD586@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 30, 2013 at 10:49:21PM +0200, Jan Kara wrote:
> On Thu 30-05-13 15:05:02, Eric Sandeen wrote:
> > On 5/30/13 3:01 PM, Jan Kara wrote:
> > > On Thu 30-05-13 08:48:24, Eric Sandeen wrote:
> > >> On 5/30/13 7:45 AM, Jan Kara wrote:
> > >>> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> > >>> 4GB.
> > >>
> > >>
> > >> Hm, should we add 2T as well while we're at it?
> > >>
> > >> (and does this cause any new failures?)
> > >   Yes, ext4 is broken. I've sent fixes for it yesterday. I'm not sure what
> > 
> > Argh, sorry I forgot that.  I just want to be careful about more rigorous
> > tests making it look like we have regressions in the code.
> > 
> > > exactly would overflow at 2T ... block counts if signed int is used and
> > > blocksize is 1KB?
> > 
> > Hum ok, where'd I come up with 2T?  :)  never mind that maybe, unless
> > there are other potential trouble points we should add (8T? 16T for
> > filesystems that can handle it?)
>   Yeah, so 8T + something might be interesting and both ext4 & xfs should
> handle that fine. 16T + something might be interesting for xfs if it
> supports that size. I'll update this patch with these checks.

What boundary traversal are we trying to test at these high
offsets? 

I mean, I can understand wanting to confirm they work, but there's
no 32 bit variable boundary in the seek code at 8/16TB that needs to
be specifically test is there? i.e. is it just testing the same case
as the 8GB case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
