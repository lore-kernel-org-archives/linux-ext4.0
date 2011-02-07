From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 7 Feb 2011 23:49:15 GMT
Message-ID: <201102072349.p17NnF0g006369@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:37877 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1BGXtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 18:49:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p17NnG6J006370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 23:49:16 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #28 from rocko <rockorequin@hotmail.com>  2011-02-07 23:49:14 ---
Actually, the lockup doesn't take place _immediately_ after resume - there is a
random interval of up to several seconds. A couple of times I even managed to
type my password in for the screensaver and get back to the desktop before the
freeze. So there is certainly time for a userspace process to try and access a
missing drive. 

And there is a process that umount drives when it detects they are missing (I
think it is udev?). They disappear from my Gnome desktop when I pull out the
drive or when I resume after removing the drives.

These (sample) messages after resume show it happening:

Feb  7 10:04:04 pegasus-maverick ntfs-3g[2745]: Unmounting /dev/sdf1 (My
Passport)
Feb  7 10:04:04 pegasus-maverick kernel: [  128.908709] JBD: I/O error detected
when updating journal superblock for sde1.
Feb  7 10:04:04 pegasus-maverick kernel: [  128.934868] scsi 9:0:0:1: rejecting
I/O to dead device
Feb  7 10:04:04 pegasus-maverick kernel: [  128.949322] EXT3-fs (sde1): I/O
error while writing superblock


The first message implies that a umount happens for at least missing ntfs
drives. The bug in comment #10 happened during a sys_umount call, which was
triggered by Gnome automatically in response to the missing drive.


The most confusing thing is how the sytem might have crashed when firefox was
trying to access a valid mounted ext4 partition. That's why I'm thinking it's
caused by a memory corruption or invalid pointer.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
