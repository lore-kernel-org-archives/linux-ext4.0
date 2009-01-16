From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Fri, 16 Jan 2009 11:37:40 -0800 (PST)
Message-ID: <20090116193740.8202110804B@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbZAPTi0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 14:38:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0GJbevs027166
	for <linux-ext4@vger.kernel.org>; Fri, 16 Jan 2009 11:37:41 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #10 from folkert@vanheusden.com  2009-01-16 11:37 -------
Theodore,

> I can't tell how big the filesystem is (I'd need the output of dumpe2fs
> /dev/hdXXX) to detect that, but this:
> [92499.263311] Buffer I/O error on device dm-2, logical block 522133279

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1          31      248976   83  Linux
/dev/hda2              32        4865    38829105    5  Extended
/dev/hda5              32        4865    38829073+  8e  Linux LVM

38829073 < 522133279
so it tries to reach beyond the physical boundaries of the disk

> Indicates either a hardware error, or a corrected journal inode.

Possible as one of the errors that pop up is aborted journals, and journals
take off-line and what not.

> In the latter case, e2fsck would have detected the problem, and offered to 
> fix it.

e2fsck finds millions of issues, I always give fixing a try but after minutes
of pressing enter to fsck questions I give up and re-install debian (takes 15
minutes)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
