From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12433] Oops while resizing an ext4 LVM2 volume
Date: Tue,  3 Feb 2009 10:49:15 -0800 (PST)
Message-ID: <20090203184915.C26FB11D108@picon.linux-foundation.org>
References: <bug-12433-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZBCStR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 13:49:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n13InGuB006426
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 10:49:17 -0800
In-Reply-To: <bug-12433-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12433





------- Comment #3 from peter@kerwien.homeip.net  2009-02-03 10:49 -------
I applied the patch to 2.6.29-rc1 and have resized an ext4 volume, both as
logical with lvm2 and a normal disk partition. I have experimented with both
online and offline resize to a larger size and offline resize to a smaller
size. I have done this approx. 15-20 times and so far no more oops.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
