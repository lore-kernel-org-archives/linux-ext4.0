From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 17:22:19 -0800 (PST)
Message-ID: <20081215012219.58E4310800F@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYLOBWu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 20:22:50 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBF1MJUB026681
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 17:22:20 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-12-14 17:22 -------
Reply-To: goswin-v-b@web.de

Eric Sandeen <sandeen@redhat.com> writes:

> maj,min cpu  seq  time           pid   act rwbs off+len
> 8,0      0    1   0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312
>
> ... etc
>
> I'm not sure it gives us enough info; all we see is that there was an IO
> on sdb (from sdb1)
>
> I might suggest
>
> # sysctl -w vm.block_dump=1
>
> to see if you get any info about inodes on sda1 being dirtied.

Like atime/diratime updates?

> (Also, I didn't see any info about sda1 in the posted fstab...)
>
> -Eric

MfG
        Goswin


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
