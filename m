From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Mon, 02 Aug 2010 17:53:43 -0700
Message-ID: <1280796823.3966.74.camel@localhost.localdomain>
References: <1280753306-23871-1-git-send-email-tytso@mit.edu>
	 <1280790152.3966.14.camel@localhost.localdomain>
	 <20100803000609.GI25653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:43942 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab0HCAxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 20:53:52 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o730puW1001129
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 18:51:56 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o730rpLn153418
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 18:53:51 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o730vD1a007187
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 18:57:14 -0600
In-Reply-To: <20100803000609.GI25653@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-08-02 at 20:06 -0400, Ted Ts'o wrote:
> On Mon, Aug 02, 2010 at 04:02:32PM -0700, john stultz wrote:
> > >From these numbers, it looks like the atomic variables are a minor
> > improvement for -rt, but the improvement isn't as drastic as the earlier
> > j_state lock change, or the vfs scalability patchset.
> 
> Thanks for doing this quick test run!  I was expecting to see a more
> dramatic difference, since the j_state_lock patch removed one of the
> two global locks in jbd2_journal_stop, and the t_handle_lock patch
> removed the second of the two global locks.  But I guess the
> j_state_lock contention in start_this_handle() is still the dominating factor.
> 
> It's interesting that apparently the latest t_handle_lock patch
> doesn't seem to make much difference unless the VFS scalability patch
> is also applied.  I'm not sure why that makes a difference, but it's
> nice to know that with the VFS scalability patch it does seem to help,
> even if it doesn't help as much as I had hoped.

Well, its likely that with the -rt kernel and without the
vfs-scalability changes, we're just burning way more time on vfs lock
contention then we are on anything in the ext4 code. Just a theory, but
I can try to verify with perf logs if you'd like.

> OK, I guess we'll have to start working on the more aggressive
> scalability fix ups....

I'm generated mainline results w/ w/o Nick's current vfs-scalability
tree. So far any benefit from the atomic patch seems to be < 1% there,
but I'm probably not hitting much contention at only 8 cores:

2.6.35-rc6
Throughput 2345.72 MB/sec 8 procs
Throughput 1424.11 MB/sec 4 procs
Throughput 811.371 MB/sec 2 procs
Throughput 444.129 MB/sec 1 procs

2.6.35-rc6 + atomic
Throughput 2354.66 MB/sec 8 procs
Throughput 1427.64 MB/sec 4 procs
Throughput 794.961 MB/sec 2 procs
Throughput 443.464 MB/sec 1 procs

2.6.35-rc6-vfs
Throughput 2639.04 MB/sec 8 procs
Throughput 1583.28 MB/sec 4 procs
Throughput 858.337 MB/sec 2 procs
Throughput 452.774 MB/sec 1 procs

2.6.35-rc6-vfs + atomic
Throughput 2648.42 MB/sec 8 procs
Throughput 1586.68 MB/sec 4 procs
Throughput 851.545 MB/sec 2 procs
Throughput 453.106 MB/sec 1 procs


thanks
-john


