From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 15018] New: ext4 backtraces out of nowhere
Date: Sun, 10 Jan 2010 03:45:59 -0700
Message-ID: <B8C511D7-3653-4CC4-9BCC-B03B8E422791@sun.com>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:32896 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0AJKqD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2010 05:46:03 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0AAk1Tv019268
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2010 02:46:01 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KW100K001PPMO00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 10 Jan 2010 02:46:00 -0800 (PST)
In-reply-to: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

