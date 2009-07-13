From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Strange disk failure...could ext4 be the culprit?
Date: Mon, 13 Jul 2009 11:05:20 +0530
Message-ID: <20090713053520.GA5088@skywalker>
References: <loom.20090707T173457-377@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Evan King <f11n1@unb.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44896 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZGMFfc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jul 2009 01:35:32 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6D5ZH61022115
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 15:35:17 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6D5ZS6J536938
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 15:35:30 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6D5ZR0d013884
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 15:35:28 +1000
Content-Disposition: inline
In-Reply-To: <loom.20090707T173457-377@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 07, 2009 at 06:16:23PM +0000, Evan King wrote:
> Hello all,
> 
> I'm administering a small computing cluster on new off-the-shelf hardware.  The
> configuration is a master-slaves setup with the master serving nfs for the data
> synchronization and performing the data re-assembly process (as well as doing
> some slave work as well).
> 
> The workload produces a fairly steady I/O workload, but not particularly heavy.
>  While I originally pushed for specialized storage hardware or configurations,
> testing and benchmarking showed that the workload appeared quite manageable for
> a single disk.  I expected it might experience a short lifespan, but on the
> order of several months at least.  To spare the disk as much thrashing as
> possible, I opted for ext4.
> 
> In the first week of active deployment (and while I was on vacation), the master
> experienced a very strange form of catastrophic failure.  A job had failed after
> only a couple hours, and serious errors blocked further work.  Several core GNU
> tools in /bin were corrupted, such as: mv, rm, uname, hostname, pwd.  A couple
> 0-byte files existed in / with scrambled filenames, and plenty of Unicode
> characters splattered across the screen during reboot.  The reboot itself
> reached a login prompt, but wouldn't accept any input.  But this is where things
> get strange.
> 
> I used a liveCD to perform disk checks, and there were no filesystem errors of
> *any* kind.  The entire filesystem was and is in pristine condition.  While I'm
> aware of discussion and issues surrounding some of the design decisions made for
> ext4 (such as delayed write allocation), it doesn't seem possible that those
> issues could be related to this kind of failure (data written without permission
> or any attempt to do so).  The corrupted binaries were in fact corrupted on
> disk, not just in memory (also unreadable by readelf), and larger than the
> originals.  The software I was using runs from a user-level account and has an
> apache-served web interface with apache dropping permissions to that same user.
>  Nothing but the kernel itself had permission to write to the files that were
> corrupted, however the computing software does execute (I think all of) the
> commands that were corrupted.
> 
> I have saved copies of several of the corrupted files, but neglected to save any
> system logs before restoring a backup.  There are still some strange messages
> appearing during startup, but they fly by too quickly to see, and nothing seems
> amiss in the logs except that /var/log/messages seems extremely verbose with
> startup and has many references to initializing ext4 (but nothing sounds like an
> error).  I'm about to tell my users to start using it again and will be
> expecting and watching for a repeat performance.  The disk itself appears to be
> fine.
> 
> _____
> 
> So my questions are these:
> 
>  - How likely is it that some arcane bug in ext4 is responsible for the failure?

Can you check whether your kernel have this patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4

-aneesh
