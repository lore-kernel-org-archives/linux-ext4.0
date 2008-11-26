From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Wed, 26 Nov 2008 00:10:57 -0500
Message-ID: <20081126051057.GE1410@mit.edu>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081125102335.GB9882@mit.edu> <20081125224115.GW3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45358 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbYKZFLB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 00:11:01 -0500
Content-Disposition: inline
In-Reply-To: <20081125224115.GW3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2008 at 03:41:15PM -0700, Andreas Dilger wrote:
> > Stupid question... if the goal is to not have the average commit time
> > not react too strongly to sudden and vast changes to the commit time,
> > would it be better to do this instead:
> > 
> > > +		journal->j_average_commit_time = (commit_time +
> > > +				journal->j_average_commit_time*3) / 4;
> 
> Actually, yes.  That is my fault, I'd suggested the original change to
> Josef.

BTW, I've added a patch to display the average commit time it does
vary wildly, especially on a laptop hard drive.  While the system is
idle, and the occasional commits need to wait for the hard drive to
wake up, leads to a average commit time of around 80-140ms.  If the
disk is just getting lightly tickled, such that it never has a chance
to go to sleep, the average commit time can drop down to around
20-25ms.  If the hard drive is really busy, then the average commit
time can go up to 40-50ms.

Increasing the weight as described below will slow down the move to
these long-term averages, but at least for laptop or Green Star drives
with power savings enabled, the average commit time does seem to vary
in some non-inintuitive ways.  Of course, if we are capping the max
transaction time at 15ms, most of this will never be visible, but it
would probably be interesting to test out this patch on a fast SSD or
an expensive enterprise array to see whether are similar surprising
variations in the average commit time.

						- Ted
