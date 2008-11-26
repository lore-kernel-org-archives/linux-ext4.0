From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Wed, 26 Nov 2008 08:18:06 -0500
Message-ID: <20081126131806.GE587@unused.rdu.redhat.com>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081125102335.GB9882@mit.edu> <20081125224115.GW3186@webber.adilger.int> <20081126051057.GE1410@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Josef Bacik <jbacik@redhat.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYKZNW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Nov 2008 08:22:59 -0500
Content-Disposition: inline
In-Reply-To: <20081126051057.GE1410@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 12:10:57AM -0500, Theodore Tso wrote:
> On Tue, Nov 25, 2008 at 03:41:15PM -0700, Andreas Dilger wrote:
> > > Stupid question... if the goal is to not have the average commit time
> > > not react too strongly to sudden and vast changes to the commit time,
> > > would it be better to do this instead:
> > > 
> > > > +		journal->j_average_commit_time = (commit_time +
> > > > +				journal->j_average_commit_time*3) / 4;
> > 
> > Actually, yes.  That is my fault, I'd suggested the original change to
> > Josef.
> 
> BTW, I've added a patch to display the average commit time it does
> vary wildly, especially on a laptop hard drive.  While the system is
> idle, and the occasional commits need to wait for the hard drive to
> wake up, leads to a average commit time of around 80-140ms.  If the
> disk is just getting lightly tickled, such that it never has a chance
> to go to sleep, the average commit time can drop down to around
> 20-25ms.  If the hard drive is really busy, then the average commit
> time can go up to 40-50ms.
> 
> Increasing the weight as described below will slow down the move to
> these long-term averages, but at least for laptop or Green Star drives
> with power savings enabled, the average commit time does seem to vary
> in some non-inintuitive ways.  Of course, if we are capping the max
> transaction time at 15ms, most of this will never be visible, but it
> would probably be interesting to test out this patch on a fast SSD or
> an expensive enterprise array to see whether are similar surprising
> variations in the average commit time.
>

I was printing out the commit time when I was testing this and with high end
storage the commit time didn't vary all that much.  With my SATA drive on a
normal running box it didn't vary all that much either, it would drop down to
like 1ms because of syslog, but other than that it would ramp up when there was
load and it would slowly come back down as the load went away.  Also do you
want a new patch with that fix, or will you just fix it up?  Thanks,

Josef 
