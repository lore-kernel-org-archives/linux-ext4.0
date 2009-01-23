From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12433] Oops while resizing an ext4 LVM2 volume
Date: Fri, 23 Jan 2009 14:00:37 -0800 (PST)
Message-ID: <20090123220037.8E36B10800C@picon.linux-foundation.org>
References: <bug-12433-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbZAWWAj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jan 2009 17:00:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0NM0bKs003215
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jan 2009 14:00:38 -0800
In-Reply-To: <bug-12433-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12433





------- Comment #2 from peter@kerwien.homeip.net  2009-01-23 14:00 -------
flex_bg is default on when creating ext4 on my Gentoo system.

Yeap, I found this in my log:
...
Jan 11 20:54:58 kerwien kernel: EXT4-fs: mounted filesystem dm-0 with ordered
data mode
Jan 11 20:56:41 kerwien kernel: EXT4-fs error (device dm-0):
ext4_get_group_desc: block_group >= groups_count -
 block_group = 401, groups_count = 401
Jan 11 20:56:41 kerwien kernel: BUG: unable to handle kernel NULL pointer
dereference at (null)
Jan 11 20:56:41 kerwien kernel: IP: [<ffffffffa01c6b59>]
ext4_block_bitmap+0x9/0x30 [ext4]
Jan 11 20:56:41 kerwien kernel: PGD 1a873067 PUD 3eded067 PMD 0 
...

I can try the patch and see if I can reproduce the problem again or not.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
