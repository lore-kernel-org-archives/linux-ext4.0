From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Fri, 22 Apr 2011 15:00:19 GMT
Message-ID: <201104221500.p3MF0J9c020587@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37110 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1DVPAT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 11:00:19 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3MF0J7w020588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Apr 2011 15:00:19 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #64 from Theodore Tso <tytso@mit.edu>  2011-04-22 15:00:15 ---
I'm going to guess that your script depends on your desktop trying to access
(and possibly write to) your USB stick during the time that you are running
causing the unbind to happen?

A more useful test case would be one that works even if no desktop is running
(i.e., you're logged in via SSH, or the VT console, or the serial console), and
the script contains all of the commands which are accessing the USB storage
device.  Otherwise, it might be dependent on what desktop you are running, and
someone who is using fvwm or KDE (for example) if you happened to create the
test case while using the GNOME desktop (and then you have to answer the
question of which version of the GNOME desktop, and what desktop pacakges you
might have installed, etc.)

I very much doubt it has to do with when the file system was fsck'ed.  The real
question is what specific I/O pattern happened to be going on at the time when
the USB stick was yanked out.  And that might explain why I don't see it,
because normally I'm not crazy enough to yank out a device while it's actively
been accessed.  (And I don't like desktops that initiate a lot of I/O behind my
back.... since that generally means it's doing this at times when I might not
like it, such as when I'm running on battery and am trying to conserve
power....)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
