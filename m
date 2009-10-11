From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 19:07:10 GMT
Message-ID: <200910111907.n9BJ7ABR028050@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36677 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZJKTHr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 15:07:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9BJ7Asb028051
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 19:07:10 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #14 from Theodore Tso <tytso@mit.edu>  2009-10-11 19:07:10 ---
Holger, could you try running same test and see if you get similar results?

Alexey, when you say that the dmesg was the same for both kernels, was it
_identical_?   Was it always the same number of orphaned inodes which were
deleted, and were the inode numbers always the same?  And you're sure you
didn't see anything like:

EXT4-fs (dm-0): error: ext4_fill_super: journal transaction 4641626 is corrupt
EXT4-fs (dm-0: Mounting filesystem read-only

In Holger's report, he mentions that after the first reboot, the file system
turns read-only.   Holger, what do you see in your system logs after each
reboot, in particular before the filesystem gets mounted or remounted
read-only?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
