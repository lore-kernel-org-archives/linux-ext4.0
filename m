From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Mon, 9 Aug 2010 16:38:05 -0700
Message-ID: <20100809233805.GH2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40666 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab0HIXqL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Aug 2010 19:46:11 -0400
Content-Disposition: inline
In-Reply-To: <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 05:19:22PM -0400, Andreas Dilger wrote:
> On 2010-08-09, at 15:53, Darrick J. Wong wrote:
> > This patch attempts to coordinate barrier requests being sent in by fsync.
> > Instead of each fsync call initiating its own barrier, there's now a flag
> > to indicate if (0) no barriers are ongoing, (1) we're delaying a short time
> > to collect other fsync threads, or (2) we're actually in-progress on a
> > barrier.
> > 
> > So, if someone calls ext4_sync_file and no barriers are in progress, the
> > flag shifts from 0->1 and the thread delays for 500us to see if there are
> > any other threads that are close behind in ext4_sync_file.  After that
> > wait, the state transitions to 2 and the barrier is issued.  Once that's
> > done, the state goes back to 0 and a completion is signalled.
> 
> You shouldn't use a fixed delay for the thread.  500us _seems_ reasonable, if
> you have a single HDD.  If you have an SSD, or an NVRAM-backed array, then
> 2000 IOPS is a serious limitation.

2000 fsyncs per second, anyway.  I wasn't explicitly trying to limit any other
types of IO.

> What is done in the JBD2 code is to scale the commit sleep interval based on
> the average commit time.  In fact, the ext4_force_commit->
> ...->jbd2_journal_force_commit() call will itself be waiting in the jbd2 code
> to merge journal commits.  It looks like we are duplicating some of this
> machinery in ext4_sync_file() already.

I actually picked 500us arbitrarily because it seemed to work, even for SSDs.
It was a convenient test vehicle, and not much more.  That said, I like your
recommendation much better.  I'll look into that.

> It seems like a better idea to have a single piece of code to wait to merge
> the IOs.  For the non-journal ext4 filesystems it should implement the wait
> for merges explicitly, otherwise it should defer the wait to jbd2.

I wondered if this would have been better off in the block layer than ext4?
Though I suppose that could imply two kinds of flush: flush-immediately, and
flush-shortly.  I intend to try those flush drain elimination patches before I
think about this much more.

--D
