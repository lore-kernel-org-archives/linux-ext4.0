From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 19 Feb 2011 12:36:37 GMT
Message-ID: <201102191236.p1JCabGf030251@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54145 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BSMgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 07:36:37 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1JCabq1030252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 19 Feb 2011 12:36:37 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #29 from rocko <rockorequin@hotmail.com>  2011-02-19 12:36:35 ---
2.6.38-rc5 seems particularly prone to this bug - I've crashed it three times
today without even suspending. The first time was when I accidentally power off
an attached USB drive; the second was when I removed an ext4 USB key; and the
third time was when I removed the USB key again while trying to get a log
output (it took about 10 goes doing this to get the crash). In all cases the
stored syslog only showed the USB disconnect, but in the last case I got a
partial bug dump on the tty console:

BUG: scheduling while atomic: kworker
RIP: 0010 [...] in tick_nohz_restart_sched_tick+0x55/0x180
...
Call trace:
cpu_idle+0xd7/0xf0
start_secondary+0x1bc/0x1c3

So might this be a scheduling problem rather than a file system problem?

In this last case I must have removed then reattached the USB key in the same
instance, because its light kept flashing ie indicating that something was
trying to read or write to it.

I notice that when a device is removed the kernel immediately re-mounts it in
read-only mode before presumably dismounting it again. So if you are trying to
copy to a device that is removed the first error that Gnome might report is
that the device is read-only, and when you press 'skip', the second error is
that the device has disappeared. Is this normal? It seems odd.

Does anyone have any more suggestions on how to debug this? It is really
annoying when the simple act of removing a USB file system completely crashes
the kernel (and trashes all your unsaved data).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
