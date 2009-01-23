From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12433] Oops while resizing an ext4 LVM2 volume
Date: Fri, 23 Jan 2009 13:02:45 -0800 (PST)
Message-ID: <20090123210245.0D5AB10800F@picon.linux-foundation.org>
References: <bug-12433-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbZAWVDO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jan 2009 16:03:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0NL2jhv031196
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jan 2009 13:02:46 -0800
In-Reply-To: <bug-12433-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12433





------- Comment #1 from cascardo@holoscopio.com  2009-01-23 13:02 -------
Have you enabled flex_bg recently? Have you kept the log? Any message
indicating an error like this one?

Jan 23 14:20:42 vespa kernel: [  463.027499] EXT4-fs error (device dm-11):
ext4_get_group_desc: block_group >= groups_count - block_group = 11,
groups_count = 11

I've hit this bug and fixed it. The patch was sent to linux-ext4 and is
available at
http://holoscopio.com/patches/0001-ext4-fix-oops-when-online-resizing-a-filesystem-wit.patch.
Could you, please, test it?

Regards,
Cascardo.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
