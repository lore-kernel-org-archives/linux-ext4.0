From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Sun, 10 Jan 2010 10:46:04 GMT
Message-ID: <201001101046.o0AAk4PE002785@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37651 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0AJKqE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2010 05:46:04 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0AAk4Lf002786
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2010 10:46:04 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-10 10:46:03 ---
Reply-To: adilger@sun.com

On 2010-01-09, at 12:01, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15018
>
> While doing an rsync to an ext4 filesystem, suddenly the above  
> showed up in my dmesg:
>
> Jan  9 15:55:20 pannekake kernel: [61568.551238] Pid: 28573, comm:  
> rsync Not
> tainted 2.6.33-rc3 #2
> Jan  9 15:55:20 pannekake kernel: [61568.557085] Call Trace:
> Jan  9 15:55:20 pannekake kernel: [61568.559623]  [<ffffffffa0253aa1>]
> ext4_write_inode+0x4d/0xc7 [ext4]
>
> It showed up again ~20 minutes later, and since then I haven't seen  
> it. I'm a bit puzzled since I don't actually see any error messages  
> (just the backtrace), and I'm not able to find any ill effects  
> except for the traceback, but I guess it still shouldn't happen.
>
> FWIW, the ext4 is on an LVM whose one of the component RAID-5s was  
> resyncing at the time. I don't know if that is relevant or not.


In ext4_write_inode it has a dump_stack() in the case where  
ext4_journal_current_handle() is non-NULL.

This is a bug, because later on it calls ext4_force_commit(), which  
would end up blocking on the journal commit to finish, which is  
blocked waiting on the journal handle held by the selfsame thread that  
started the journal commit in the first place.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
