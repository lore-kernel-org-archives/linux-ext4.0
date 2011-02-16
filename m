From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29212] noexec on file level (acl)
Date: Wed, 16 Feb 2011 15:35:04 GMT
Message-ID: <201102161535.p1GFZ4xR020006@demeter1.kernel.org>
References: <bug-29212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37172 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1BPPfF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 10:35:05 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1GFZ5AR020007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 15:35:05 GMT
In-Reply-To: <bug-29212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29212





--- Comment #2 from krzf83@gmail.com  2011-02-16 15:35:03 ---
Dissalowing access to binary programs like nmap, sendmail, perhaps ping is a
good practice on shared system. User can however put his own copies in his home
dir of these programs. If /home is mounted without noexec he can run those.
With noexec he can't. Of course scripting languages still can be actually used
but there are less of a treat for now.
(mounting /tmp and /dev/shm is also common security practice)
There are situations when it would be very wasteful and inconvenient to mount
whole filesystem with noexec. Perhaps you want to execute code in some
directories on /home, perhaps you want to allow some users to execute code od
/home or perhaps you want to disallow execution in some locations recursively
and still allow it in other locations. I'm not sure what is the best form of
setting and storing data for such functionality as I doubt anyone will catch
this and want to program it into kernel.
However more precise noexec for specific locations in filesystem, not just
whole filesystem, is what I've been looking for years now.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
