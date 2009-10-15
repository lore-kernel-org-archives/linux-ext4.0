From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 15 Oct 2009 23:40:48 GMT
Message-ID: <200910152340.n9FNemvs030841@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60141 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbZJOXlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 19:41:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9FNemS5030842
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 23:40:48 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #58 from Theodore Tso <tytso@mit.edu>  2009-10-15 23:40:47 ---
Alexey, where you doing anything in particular when you did the "echo c >
/proc/sysrq-trigger"?  Does it reproduce for you every single time?  

I did ("echo c > /proc/sysrq-trigger") while running a "make -j4" in an
e2fsprogs source tree, and after the reboot, both on the root logical volume
(where I have a ccache directory on an SSD drive) and my build logical volume
(where I have an e2fsprogs source and build tree) were just fine after
rebooting.

As I said, I'm having a devil of a time reproducing this.  I've tried power
failures (removing the battery and pulling the power cord) while the build was
taking place, suspending the system and then forcing a cold restart, suspending
the system and then pulling the power, using "echo c >  /proc/sysrq-trigger",
etc.   After each time, I've used e2croncheck to verify the sanity of my ssd
root partition, and (in case the problem is the ext4 journal replay), mounting
and then unmounting /kbuild, and then running e2fsck -f /dev/closure/kbuild.

In all cases, I've not had any file system inconsistencies.  (using 2.6.32-rc1,
2.6.32-rc3, and most recently, 2.6.32-rc4). I really need some help reproducing
this!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
