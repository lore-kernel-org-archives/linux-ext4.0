From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 08:17:16 -0400
Message-ID: <200805200817.17059.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <200805191439.36577.chris.mason@oracle.com> <20080520082517.GH22369@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33926 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbYETMTM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 08:19:12 -0400
In-Reply-To: <20080520082517.GH22369@kernel.dk>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 May 2008, Jens Axboe wrote:
> On Mon, May 19 2008, Chris Mason wrote:
> > On Monday 19 May 2008, Chris Mason wrote:
> > > Here's a test workload that corrupts ext3 50% of the time on power fail
> > > testing for me.  The machine in this test is my poor dell desktop
> > > (3ghz, dual core, 2GB of ram), and the power controller is me walking
> > > over and ripping the plug out the back.
> >
> > Here's a new version that still gets about corruptions 50% of the
> > time, but does it with fewer files by using longer file names (240
> > chars instead of 160 chars).
> >
> > I tested this one with a larger FS (40GB instead of 2GB) and larger
> > log (128MB instead of 32MB).  barrier-test -s 32 -p 1500 was still
> > able to get a 50% corruption rate on the larger FS.
>
> I ran this twice, killing power after 'renames ready'. The first time it
> was fine, the second time I got:

Great, thanks Jens.

So, one compromise may be to change the barriers on ext3 to look like the 
patch Ted just sent out for ext4.  It should be mostly safe to skip the 
barrier between the log blocks and the commit block since the drive is likely 
to do those sequentially anyway.  A little extra logic could be added to 
detect log wrapping and force an extra barrier in that case.

Reiserfs saw some significant performance gains when I changed the code from:

write log blocks
barrier
wait on log blocks
write commit
barrier
wait on commit

to

write log blocks
barrier
write commit
barrier
wait on all of them

Both were tested with the great big emc power failure machine and both passed.  
In the event of an IO error on log blocks, we should zero out the commit.

-chris
