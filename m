From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 21 Feb 2011 04:08:12 GMT
Message-ID: <201102210408.p1L48C7x029525@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54271 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1BUEIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Feb 2011 23:08:12 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1L48CPO029526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 04:08:12 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #33 from rocko <rockorequin@hotmail.com>  2011-02-21 04:08:10 ---
Created an attachment (id=48512)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48512)
syslog from VM which is hanging for 10-15 seconds at a time

In case it is useful... I also tried reproducing the freeze running Ubuntu
11.04 (running 2.6.38-rc4) in VirtualBox and repeatedly assigning/unassigning
the test USB key to it (which used to have a good chance of freezing the host,
but not now). I didn't get a total freeze, but I did start getting freezes for
maybe 10-15 seconds. The USB access light started flashing permanently so I
seem to have recreated the situation where some process has crashed trying to
access the drive, or perhaps just crashed the drive itself, but the kernel
doesn't completely crash, just completely pause temporarily. The key still
shows up in an ls as attached to 1-1:1.0, but I can't bind/unbind it anymore -
it gives write errors (no such device) and "device offlined" errors.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
