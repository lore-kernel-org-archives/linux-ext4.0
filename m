From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Tue, 17 Mar 2009 08:28:35 -0700 (PDT)
Message-ID: <20090317152835.8F38C10800E@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbZCQP3m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 11:29:42 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2HFSZPg011310
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 08:29:11 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|sandeen@redhat.com
             Status|NEW                         |ASSIGNED




------- Comment #21 from sandeen@redhat.com  2009-03-17 08:28 -------
(In reply to comment #20)
> As noted in attachments, I have applied the patch and completed my BitTorrent
> download (which was problematic without the patch).
> 
> linux-image-2.6.28-8-generic (Ubuntu): Download unable to complete due to EXT4
> error and non-responsive sync.
> 
> linux-image-2.6.28-9-generic (Ubuntu+potential fix patch), first try: Computer
> is found unresponsive and screen dark, power and capslock blinking.

That indicates a panic, but we'd need a lot more info, which you probably can't
gather at this time.  Getting panics visible when you're in X is tricky,
netconsole or serial console or similar may be needed.  So you paniced, but we
have no idea why, unfortunately.

> linux-image-2.6.28-9-generic (Ubuntu+potential fix patch), second try: Computer
> is normal, no errors in dmesg about EXT4, download is successful.

well, that sounds good ;)

> The failure on first try is a new behavior I have not seen before with this
> machine. I therefore am reporting inconclusively that the patch works for me.

Ok, thanks for the testing..  It's headed upstream in any case, I think, as it
seems pretty well correct from inspection and review.

Oh, re: the stat of that inode, for a 10G file that's a metric ton of
extents...  you should encourage whichever torrent client this is to use the
preallocation routines now available (fallocate(2)) - a syscall now, exposed by
glibc soon.

the file has 600+ extent tree *nodes* each of which holds an extent... you have
nearly 105000 extents.  That's ... impressive ... :)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
