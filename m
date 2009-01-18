From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Sun, 18 Jan 2009 13:30:59 -0800 (PST)
Message-ID: <20090118213059.3A4AB10800C@picon.linux-foundation.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112AbZARVbC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 16:31:02 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0ILUx1T002887
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 13:31:00 -0800
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





------- Comment #3 from kernel-bugzilla@cygnusx-1.org  2009-01-18 13:30 -------
At least a related problem seems to have happened on another reboot. This
reboot was a hard reset, because of the system going into some mostly hung
state. I saw it somewhat respond a few times, ping still work, ssh would return
the comment string, and even managed to login once but it hung before the
shell.

On the next boot I found I seem to have a corrupt superblock. It sounds a lot
like this reboot.

http://kerneltrap.org/mailarchive/linux-ext4/2009/1/5/4598534


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
