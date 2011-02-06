From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 6 Feb 2011 06:43:00 GMT
Message-ID: <201102060643.p166h03p004662@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54192 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1BFGnC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Feb 2011 01:43:02 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p166h0vb004663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 6 Feb 2011 06:43:00 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #20 from rocko <rockorequin@hotmail.com>  2011-02-06 06:42:59 ---
It's a *lot* harder to repeat it with just one drive attached. Over 20
suspend/resume cycles I only managed to repeat the freeze once with a single
drive attached (with the 500GB drive attached in this case).

I doubt very much that a particular program is accessing the external
partitions. In my testing I just allow Gnome to mount the partitions and once
it has settled I run the sleep command. A "lsof|grep media" after the
partitions are mounted doesn't show anything accessing the external file
systems.

Is it relevant that when I start the suspend cycle but before suspend occurs
there are some kernel messages saying that the external partitions are being
remounted? I would have thought that they would be unmounted without a remount
before suspend.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
