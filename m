From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 15 Oct 2009 15:07:47 GMT
Message-ID: <200910151507.n9FF7lqT005812@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39816 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZJOPIX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 11:08:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9FF7leN005814
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 15:07:47 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #54 from Brian Rogers <brian@xyzw.org>  2009-10-15 15:07:41 ---
A few times recently I had corruption very similar to what's reported here,
with Ext4 on an ordinary disk partition with no DM or anything fancy.

Personally I'm suspicious of the new boot scripts in Karmic. In trying to be as
concurrent as possible, maybe it's doing something really bad like running
twice and starting two concurrent instances of fsck on the same partition, or
running fsck while the partition is already mounted with write access.

I can confirm an issue where it doesn't reboot after directing you to manually
run a disk check and instead it tries to remount the root partition as rw,
reported here:
https://bugs.launchpad.net/ubuntu/+source/mountall/+bug/452196

But that doesn't explain the disk getting corrupted in the first place.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
