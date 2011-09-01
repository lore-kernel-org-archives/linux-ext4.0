From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Thu, 1 Sep 2011 01:30:18 GMT
Message-ID: <201109010130.p811UIUm023301@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45351 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab1IABaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 21:30:19 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p811UISj023302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Sep 2011 01:30:18 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #89 from rocko <rockorequin@hotmail.com>  2011-09-01 01:30:13 ---
Created an attachment (id=71072)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=71072)
usbonoff-with-mount.sh - script to reproduce the crash

For the record, it is very easy to reproduce the bug with the attached script,
which repeatedly mounts, forces an eject, then umounts the USB device until the
kernel eventually crashes. The procedure is:

1. Create a VirtualBox VM running Ubuntu 11.04 64-bit with the kernel being
tested and boot the VM in recovery mode, ie so no desktop is running.

2. Use the VirtualBox USB facility (right click on the USB icon in the status
bar) to attach an ext3/4 drive to the VM.

3. Run the attached script, specifying the target USB device as the argument
(the script lists possible devices if you don't supply an argument). There's a
commented-out option to redirect output to output to an external machine via
netconsole as well, ie to capture the crash log, which you can't fully see in
the VM window.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
