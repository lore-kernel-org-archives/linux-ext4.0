From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Tue, 16 Feb 2010 13:07:28 -0800
Message-ID: <20100216210728.GO29569@tux1.beaverton.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35503 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab0BPVHd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 16:07:33 -0500
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1GL3fQE013595
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 16:03:41 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1GL7UnC116534
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 16:07:30 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1GL7TAi017944
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 19:07:30 -0200
Content-Disposition: inline
In-Reply-To: <1263583812-21355-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 02:30:09PM -0500, Theodore Ts'o wrote:

> The plan is to merge this for 2.6.34.  I've looked this over pretty
> carefully, but another pair of eyes would be appreciated, especially if

I don't have a high speed disk but it was suggested that I give this patchset a
whirl anyway, so down the rabbit hole I went.  I created a 16GB ext4 image in
an equally big tmpfs, then ran the read/readall directio tests in ffsb to see
if I could observe any difference.  The kernel is 2.6.33-rc8, and the machine
in question has 2 Xeon E5335 processors and 24GB of RAM.  I reran the test
several times, with varying thread counts, to produce the table below.  The
units are MB/s.

For the dio_lock case, mount options were: rw,relatime,barrier=1,data=ordered.
For the dio_nolock case, they were: rw,relatime,barrier=1,data=ordered,dioread_nolock.

	dio_nolock	dio_lock
threads	read	readall	read	readall
1	37.6	149	39	159
2	59.2	245	62.4	246
4	114	453	112	445
8	111	444	115	459
16	109	442	113	448
32	114	443	121	484
64	106	422	108	434
128	104	417	101	393
256	101	412	90.5	366
512	93.3	377	84.8	349
1000	87.1	353	88.7	348

It would seem that the old code paths are faster with a small number of
threads, but the new patch seems to be faster when the thread counts become
very high.  That said, I'm not all that familiar with what exactly tmpfs does,
or how well it mimicks an SSD (though I wouldn't be surprised to hear
"poorly").  This of course makes me wonder--do other people see results like
this, or is this particular to my harebrained setup?

For that matter, do I need to have more patches than just 2.6.33-rc8 and the
four posted in this thread?

I also observed that I could make the kernel spit up "Process hung for more
than 120s!" messages if I happened to be running ffsb on a real disk during a
heavy directio write load.  I'll poke around on that a little more and write
back when I have more details.

For poweroff testing, could one simulate a power failure by running IO
workloads in a VM and then SIGKILLing the VM?  I don't remember seeing any sort
of powerfail test suite from the Googlers, but my mail client has been drinking
out of firehoses lately. ;)

--D
