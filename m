From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Wed, 27 Jan 2010 20:23:45 GMT
Message-ID: <201001272023.o0RKNjVN018515@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43845 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab0A0UXs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 15:23:48 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0RKNjkQ018516
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 20:23:45 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #5 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-01-27 20:23:43 ---
On Wed, Jan 27, 2010 at 07:35:11PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> Sorry for not getting back to you right away; I've been doing a huge amount of
> travel right during January.   Can you tell me something about the file system
> workload on your machine?  What does it do?  NFS, rsync server, backups, ...?  
IIRC this was a file system that was mainly used for video storage and
transcoding -- I think I was encoding a video with x264 to it when it
crashed. Apart from that the machine spends most of its I/O time doing web
serving from relatively large (1-2TB) data sets, and occasionally rtorrent.

It was recently online expanded, so I thought that might be related, but the
problem persisted after a reboot and a forced fsck, so there was no on-disk
corruption involved.

> And do you know what it might be doing right before it crashed?   How easily
> can you reproduce this?  I take it since you had to stop using 2.6.33-rcX you
> could reproduce it easily?

It crashed two times in two days or something after I upgraded to 2.6.33-rcX.
Not a statistically huge sample, I'm afraid.

> If you are willing to try a 2.6.33-rcX kernel, I'd suggest seeing if "echo 0 >
> /sys/fs/ext4/<dev>/max_writeback_mb_bump" makes the crashes go away.

I'm afraid it's not so easy for me to do reboots into new kernels on this
machine; kernel upgrades generally happen when the machine is booted for some
other reason. :-/

/* Steinar */

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
