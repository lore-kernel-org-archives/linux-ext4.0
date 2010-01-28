From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Thu, 28 Jan 2010 17:19:20 GMT
Message-ID: <201001281719.o0SHJKBV026410@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57292 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab0A1RTV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 12:19:21 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SHJKut026411
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 17:19:20 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #45 from carlos.velasco@nimastelecom.com  2010-01-28 17:19:13 ---
Sorry about delay, I made further tests.
I think the patch is good and this is another problem.

The oops happened during TEST of the eglibc. This has been solved by the patch.
This second issue is related to the INSTALL of the eglibc.

After "make install" and reboot I always see an umount busy message for /.
This busy message was not seen before because we stepped into the oops
umounting /tmp, before umounting /.

I tried downgrading to linux kernel 2.6.28 but I couldn't, I receive an NMI
interrupt and system hang before testing with this kernel.

So I have issued a "ps -ef" and a lsof just before the umount all.

Looking output of ps, there are no user processes apart of these:
root     30920     1  0 17:50 ttyS1    00:00:00 init [6]  
root     30921 30920  0 17:50 ttyS1    00:00:00 /bin/bash /etc/rc.d/init.d/rc 6
root     31085 30921  0 17:50 ttyS1    00:00:00 /bin/bash
/etc/rc.d/rc6.d/S70mou

Umount command is:
"umount -a -d -r >/dev/null"

I ONLY see this error when installing eglibc. Rebooting the system without
installing eglibc is successful without errors.

Looking into LSOF, I have been looking into differences between a "good reboot"
and a "bad reboot - umount busy". I can only see that in the "bad reboot" the
SIZE/OFF columns are empty for the new installed eglibc files.

Bad:
COMMAND    PID USER   FD      TYPE DEVICE SIZE/OFF   NODE NAME
init          1 root  DEL       REG  253,1          887056
/lib64/libc-2.10.1.so
init          1 root  DEL       REG  253,1          887055 /lib64/ld-2.10.1.so

Good:
COMMAND    PID USER   FD      TYPE DEVICE SIZE/OFF   NODE NAME
init         1 root  mem       REG  253,1  1752309 887013 /lib64/libc-2.10.1.so
init         1 root  mem       REG  253,1   149463 887007 /lib64/ld-2.10.1.so

Not sure how to proceed from here. Not sure if this is an ext3 issue also...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
