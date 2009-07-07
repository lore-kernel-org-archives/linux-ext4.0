From: Evan King <f11n1@unb.ca>
Subject: Strange disk failure...could ext4 be the culprit?
Date: Tue, 7 Jul 2009 18:16:23 +0000 (UTC)
Message-ID: <loom.20090707T173457-377@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54862 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZGGSUI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jul 2009 14:20:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MOFGt-0007E3-4s
	for linux-ext4@vger.kernel.org; Tue, 07 Jul 2009 18:20:03 +0000
Received: from h2cluster.chem.unb.ca ([131.202.54.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jul 2009 18:20:03 +0000
Received: from f11n1 by h2cluster.chem.unb.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jul 2009 18:20:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

I'm administering a small computing cluster on new off-the-shelf hardware.  The
configuration is a master-slaves setup with the master serving nfs for the data
synchronization and performing the data re-assembly process (as well as doing
some slave work as well).

The workload produces a fairly steady I/O workload, but not particularly heavy.
 While I originally pushed for specialized storage hardware or configurations,
testing and benchmarking showed that the workload appeared quite manageable for
a single disk.  I expected it might experience a short lifespan, but on the
order of several months at least.  To spare the disk as much thrashing as
possible, I opted for ext4.

In the first week of active deployment (and while I was on vacation), the master
experienced a very strange form of catastrophic failure.  A job had failed after
only a couple hours, and serious errors blocked further work.  Several core GNU
tools in /bin were corrupted, such as: mv, rm, uname, hostname, pwd.  A couple
0-byte files existed in / with scrambled filenames, and plenty of Unicode
characters splattered across the screen during reboot.  The reboot itself
reached a login prompt, but wouldn't accept any input.  But this is where things
get strange.

I used a liveCD to perform disk checks, and there were no filesystem errors of
*any* kind.  The entire filesystem was and is in pristine condition.  While I'm
aware of discussion and issues surrounding some of the design decisions made for
ext4 (such as delayed write allocation), it doesn't seem possible that those
issues could be related to this kind of failure (data written without permission
or any attempt to do so).  The corrupted binaries were in fact corrupted on
disk, not just in memory (also unreadable by readelf), and larger than the
originals.  The software I was using runs from a user-level account and has an
apache-served web interface with apache dropping permissions to that same user.
 Nothing but the kernel itself had permission to write to the files that were
corrupted, however the computing software does execute (I think all of) the
commands that were corrupted.

I have saved copies of several of the corrupted files, but neglected to save any
system logs before restoring a backup.  There are still some strange messages
appearing during startup, but they fly by too quickly to see, and nothing seems
amiss in the logs except that /var/log/messages seems extremely verbose with
startup and has many references to initializing ext4 (but nothing sounds like an
error).  I'm about to tell my users to start using it again and will be
expecting and watching for a repeat performance.  The disk itself appears to be
fine.

_____

So my questions are these:

 - How likely is it that some arcane bug in ext4 is responsible for the failure?
 - If ext4 is exonerated, are there any possible explanations aside from disk
failure and newbie mistakes?
 - What would be an appropriate way to stress-test the disk if I wanted to
intentionally induce the error, and what output should I be watching?
 - What can I do to track the occurrence of this bug, its source, and/or the
conditions that may trigger it?  (Note that iostat shows nothing of interest, as
the actual I/O load isn't particularly unusual.)
 - Should I seriously consider using an SSD?  (NFS will not share memory-mapped
directories, which thwarted the last of my 'better' plans, and the software's
scratch directory can potentially grow to several gigs over the span of a few
days/weeks.)


Thanks in advance for any light you may be able to shed on the issue.
 - Evan

