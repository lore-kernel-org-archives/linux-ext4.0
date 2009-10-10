From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 10 Oct 2009 19:54:59 GMT
Message-ID: <200910101954.n9AJsxmo011198@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45449 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807AbZJJTzf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Oct 2009 15:55:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9AJsxRa011199
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2009 19:54:59 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #10 from Theodore Tso <tytso@mit.edu>  2009-10-10 19:54:58 ---
>1. crash (reset or poweroff) 2.6.32-rc3 kernel,
>2. start again in 2.6.32-rc3
>3. run fsck it well looks clean.. but some progrums will lost it setting.

Are you running fsck with the -f option, or not?   

>4. reboot and start with 2.6.31 kernel

This is a clean shutdown or a crash?

> 5. run fsck and this will find that ext4 is brocken.

Again, is this an fsck -f (forced fsck), or just a normal fsck?  What arguments
are you using to fsck each time?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
