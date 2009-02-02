From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Mon,  2 Feb 2009 04:33:20 -0800 (PST)
Message-ID: <20090202123320.DA65B10800E@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbZBBMdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Feb 2009 07:33:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n12CXL0p008779
	for <linux-ext4@vger.kernel.org>; Mon, 2 Feb 2009 04:33:22 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #16 from tytso@mit.edu  2009-02-02 04:33 -------
Unfortunately the strace logs aren't complete because firefox multi-threaded,
and it looks like strace is only tracing one thread.   So we can see that the
thread which writes the downloaded file does a poll(2) for a set of file
descriptors, including fd 18, and then it reads a byte from fd 18, and then
writes a buffer to fd 54, which is the firefox-3.0.5.tar.bz2.part file.   But
it is always writing in 32k chunks, and it's not writing the last 2837 bytes,
as in the good strace.

It looks like the thread which reads from the network isn't signalling that the
last set of bytes isn't there, but why, I have no idea.

It also seems very strange that this is filesystem-specific; whatever it is,
there isn't anything in the file writing thread that would hint at this.   I
also can't duplicate it on my end.   I wonder if it's something stupid like the
writes are returning much faster, and this is triggering a race condition in
firefox.  Maybe some other thread is checking to see when the write is
completing by stat'ing the fd, or something stupid like that.

Something that might be worth trying is to chattr +S your downloads directory,
which will force a sync after every write, and see if that makes a difference
when you download the file from scratch.   You'll want to do a "chattr -S
downloads downloads/*" afterwards, since a sync after every writes does a real
number on performance.   But if that causes firefox to succeed, then it's
probably some wierd timing/race condition problem in firefox.

I'll note that I can't reproduce this on my firefox on my Ubuntu/Hardy system.

BTW, how many CPU's do you have, and which version of Firefox are you running?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
