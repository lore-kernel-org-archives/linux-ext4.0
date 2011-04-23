From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sat, 23 Apr 2011 00:32:35 GMT
Message-ID: <201104230032.p3N0WZU6031444@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:57461 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab1DWAcg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 20:32:36 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3N0WZaO031445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 00:32:35 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #65 from rocko <rockorequin@hotmail.com>  2011-04-23 00:32:32 ---
Yes, the crash only happens when I'm running a desktop (gdm in this case),
partly because this is what handles the auto-mounting of the USB drives. I
suppose we *could* tell people to just not use a desktop at all :)

I don't think users deliberately yank out mounted USB drives. I think the most
likely real-world scenarios that trigger this crash are (1) suspend, remove
drive, resume [ie how I first noticed this], (2) remove the wrong drive by
accident, (3) a power failure makes the drive suddenly go offline [I've seen
that, too].

Anyway, my test crash case using the script above that was working so reliably
for this ext4 USB key is no longer crashing the kernel in either 2.6.38.3 or
2.6.39-rc4 (I've done over a thousand bind/unbind cycles for each now). My
guess is that the suspend/resume test results in a higher likelihood of I/O
(especially if multiple drives are involved) and therefore triggering the bug.

I'm also still curious whether it's possible for the ext3/4 drive to somehow
get its format into a state that causes this to happen, given that yesterday it
crashed so reliably but not today. If so, couldn't it be possible that such a
state could be corrected by a fsck and therefore reduce the chances of this
mystery I/O pattern happening?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
