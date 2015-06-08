From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Sun, 7 Jun 2015 23:18:37 -0400
Message-ID: <20150608031836.GA2842@thunk.org>
References: <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org>
 <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org>
 <20150606003323.GC26550@thunk.org>
 <mku6uc$kb2$1@ger.gmane.org>
 <20150606154209.GA15306@thunk.org>
 <mkvbl6$bdr$1@ger.gmane.org>
 <20150606194843.GB15306@thunk.org>
 <ml2mlm$uqs$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52067 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbFHDSl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jun 2015 23:18:41 -0400
Content-Disposition: inline
In-Reply-To: <ml2mlm$uqs$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 08, 2015 at 02:12:38AM +0200, U.Mutlu wrote:
> 
> I could be wrong but I think the DENY_ATTACH is under the control
> of the running app itself.
> Not sure if any other process can change that on behalf of the app.

Nope, the kernel can do anything; and indeed, the DENY_ATTACH flag is
in the process's task_struct, and the kernel can modify any process's
task_struct.

> >And root can cause the kernel to lie to client applications.
>
> User or his app could check the hash of the kernel file to be sure
> it's still the official kernel.

The root user can load a kernel module without modifying the kernel
file.  There is also no way userspace can confirm that a particular
kernel file corresponds to the kernel file which is currently running.

What part of "root can do ***anything***" don't you understand?  There
are a few things that SELinux can do to control a random root process,
but the system administrator is still going to have enough power to
modify SELinux policies, and there is no way userspace can determine
whether or not the SELinux policies or the kernel is what it should
be.

There are a few ways you can control what kernel is running --- this
is why Microsoft is pushing UEFI, which can control things such that
the UEFI BIOS will only boot a kernel signed by Microsoft.  But you
really have to lock down the system, and ultimately you have to trust
whoever has access to the UEFI keys.  In your original problem
statement, you said you didn't want to trust the system administrator.
It's possible to set up a system using UEFI keys that will only boot a
digitally signed kernel -- but this still has to be set up by the
system administrator.  And if you purchase a Microsoft Surface device,
it will be locked down so it will only boot a Microsoft signed
operating system (and so you can't boot Linux at all, so a number of
folks don't consider UEFI to be an unalloyed feature).

						- Ted

P.S.  Before I started working on Linux as my vocation, in a previous
life I had over a decade's experience working on computer security
issues.  I was the Tech Lead on the MIT Kerberos v5 development team,
and the working group chair for the IP Security Working Group and a
member of the Security Area Directorate at the Internet Engineerint
Task Force, the standards body for the Internet.  So trust me, I
really do know what I am talking about.

You might also want to read Ken Thompson's (one of the fathers of
Unix) paper, Reflections on Trusting Trust:

https://www.ece.cmu.edu/~ganger/712.fall02/papers/p761-thompson.pdf

... and medidate deeply on what this means.  This shows what can
happen when the C compiler doesn't do what you think it will do.  The
fact that you assume the kernel will always do what it documented to
do, and that it can't be modified to do something different is
extremely naive.
