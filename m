From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use
 non-ext4 partition with ext4
Date: Tue, 29 Dec 2009 16:20:09 GMT
Message-ID: <200912291620.nBTGK9a1006559@demeter.kernel.org>
References: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38049 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZL2QUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 11:20:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBTGKAUm006561
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 16:20:10 GMT
In-Reply-To: <bug-14936-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936





--- Comment #2 from Rafael J. Wysocki <rjw@sisk.pl>  2009-12-29 16:20:08 ---
On Tuesday 29 December 2009, Gene Heskett wrote:
> On Tuesday 29 December 2009, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.32.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
> >Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4
> > partition with ext4 Submitter	: Gene Heskett <gene.heskett@verizon.net>
> >Date		: 2009-12-26 14:13 (4 days old)
> >References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
> >		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4
> >
> I would assume its still valid.  Even though I have rebuilt 2.6.33-rc2 3 
> times now, it is so unstable, and so much stuff doesn't "Just Work" that I 
> haven't rebooted to it, or to 2.6.32.2 in about a week now.  USB and 
> bluetooth are somewhat busted in 2.6.32.2.  2.6.32 final seems bulletproof 
> here.  The first thing that pops its ugly head up during either a 2.6.32.2, 
> or a 2.6.33-rc2 boot is that it cannot find the firmware patch that is 
> sitting in /lib/firmware for my phenom X4 cpu.  The load attempt, it looks 
> like, has been moved forward in the boot cycle, before it has actually able 
> to access a file by the /lib/firmware path known after the filesystems are 
> mounted.  And a make xconfig no longer has the ability to edit the firmware 
> inclusions in the kernel, so that is 2 bugs even before we get to the 
> numerous oopsen that will bring it down in 15 minutes or so.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.