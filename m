From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Fri, 26 Dec 2008 06:16:21 -0800 (PST)
Message-ID: <20081226141621.6F4F7108042@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbYLZOQs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Dec 2008 09:16:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBQEGLeA018992
	for <linux-ext4@vger.kernel.org>; Fri, 26 Dec 2008 06:16:22 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #2 from tytso@mit.edu  2008-12-26 06:16 -------
What does e2fsck report when you try running e2fsck on the filesystem?   Most
of the errors indicate filesystem corruption which e2fsck should have
complained vociferously about, and which it should have been able to fix if run
manually.

I can't tell how big the filesystem is (I'd need the output of dumpe2fs
/dev/hdXXX) to detect that, but this:

[92499.263311] Buffer I/O error on device dm-2, logical block 522133279

Indicates either a hardware error, or a corrected journal inode.   In the
latter case, e2fsck would have detected the problem, and offered to fix it.  In
the former case, this isn't a kernel bug, but rather a hardware problem....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
