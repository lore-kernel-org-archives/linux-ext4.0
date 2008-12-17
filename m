From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Tue, 16 Dec 2008 18:30:08 -0800 (PST)
Message-ID: <20081217023008.54CF111D108@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbYLQCaK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2008 21:30:10 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBH2U8ak017732
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2008 18:30:09 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #10 from csights@fastmail.fm  2008-12-16 18:30 -------
On Tuesday 16 December 2008 17:01:27 bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12224


> ------- Comment #9 from sandeen@redhat.com  2008-12-16 14:01 -------
> Are the laptop-mode tools doing remounts behind your back?
>
> The only way I see this is if I do "mount -o remount /"; then I see
> kjournald activity on other ext3 filesystems.  I'll dig into that.

I don't think so: I was able to reproduce this bug using an ext3 loopback 
mounted file.  laptop-mode-tools does not touch loopback devices as far as I 
can tell.  Here is my laptop-mode.conf:

> #
> # The drives that laptop mode controls.
> # Separate them by a space, e.g. HD="/dev/hda /dev/hdb". The default is a
> # wildcard, which will get you all your IDE and SCSI/SATA drives.
> #
> HD="/dev/[hs]d[abcdefgh]"

        And here is the loopback mount:

/tmp/ext3Image on /mnt/loop type ext3 
(rw,noatime,loop=/dev/loop/0,commit=1209600)

        (I set the commit=1209600 and noatime by hand on the loopback mounted
ext3 
image file.)

        Since I'm not a kernel hacker, I don't know how the code is structured.
 It 
feels like the kernel commit code is not fully separated by device (or 
partition). When the active partition's journal is "synced" it triggers 
activity on other partitions, even if the other partitions aren't active.

C.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
