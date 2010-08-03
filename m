From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Mon, 02 Aug 2010 19:52:29 -0700
Message-ID: <1280803949.3966.86.camel@localhost.localdomain>
References: <1280753306-23871-1-git-send-email-tytso@mit.edu>
	 <1280790152.3966.14.camel@localhost.localdomain>
	 <20100803000609.GI25653@thunk.org>
	 <1280796823.3966.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52313 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0HCCwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 22:52:36 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o732hwl9020871
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 20:43:58 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o732qZGi141778
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 20:52:35 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o732tvWs002706
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 20:55:58 -0600
In-Reply-To: <1280796823.3966.74.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-08-02 at 17:53 -0700, john stultz wrote:
> On Mon, 2010-08-02 at 20:06 -0400, Ted Ts'o wrote:
> > On Mon, Aug 02, 2010 at 04:02:32PM -0700, john stultz wrote:
> > > >From these numbers, it looks like the atomic variables are a minor
> > > improvement for -rt, but the improvement isn't as drastic as the earlier
> > > j_state lock change, or the vfs scalability patchset.
> > 
> > Thanks for doing this quick test run!  I was expecting to see a more
> > dramatic difference, since the j_state_lock patch removed one of the
> > two global locks in jbd2_journal_stop, and the t_handle_lock patch
> > removed the second of the two global locks.  But I guess the
> > j_state_lock contention in start_this_handle() is still the dominating factor.
> > 
> > It's interesting that apparently the latest t_handle_lock patch
> > doesn't seem to make much difference unless the VFS scalability patch
> > is also applied.  I'm not sure why that makes a difference, but it's
> > nice to know that with the VFS scalability patch it does seem to help,
> > even if it doesn't help as much as I had hoped.
> 
> Well, its likely that with the -rt kernel and without the
> vfs-scalability changes, we're just burning way more time on vfs lock
> contention then we are on anything in the ext4 code. Just a theory, but
> I can try to verify with perf logs if you'd like.

I went ahead and generated perf data for the PREEMPT_RT cases that you
can find here:
http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.33-rt-ext4-atomic/

As a reminder the 2.6.33.5-rt23 kernel includes both the vfs-scalability
patches and the j_state locking change. The 2.6.33.6-rt26 kernel does
not include those changes. 

>From those logs you can see that the atomic change on top of the vfs
patch (ie: comparing the two 2.6.33.5-rt23 logs) pulls start_this_handle
down quite a bit.

With the non-vfs scalability patched kernels, we see that the j_state
lock and atomic changes pull start_this_handle out of the top contender
handle, but there is still quite a large amount of contention on the
dput paths.

So yea, the change does help, but its just not the top cause of
contention when aren't using the vfs patches, so we don't see as much
benefit at this point.

thanks
-john


