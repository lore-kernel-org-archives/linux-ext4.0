From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Thu, 24 Mar 2011 23:06:07 GMT
Message-ID: <201103242306.p2ON67HC025785@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35131 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783Ab1CXXGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 19:06:08 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2ON67dP025786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2011 23:06:07 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #50 from rocko <rockorequin@hotmail.com>  2011-03-24 23:06:05 ---
For a time I thought I had tracked the problem down to a single 500 GB ext4
hard drive, because it became possible to able to reliably and quickly
reproduce the crash in my VM by simply simulating USB plug/unplug - it was
crashing on the third or fourth simulated unplug. Then after I ran fsck on the
drive it was much harder to reproduce the crash (I didn't manage to reproduce
it in ten separate attempts, each with hundreds of plugs/unplugs). 

I removed the drive completely from the system and had no crashes for over a
week, until this morning when 2.6.38.1 crashed upon resume (of course after I
had removed the drives during suspend).

Is it possible something in the ext4 drivers would try to access a removed
drive that is has some sort of misconfiguration (ie one that is fixed by an
fsck) and cause the crash? ie Seeing as how an fsck made the problem apparently
'go away' for a while? It would explain why more drives increase the chances of
a crash.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
