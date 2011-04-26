From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Tue, 26 Apr 2011 01:22:54 GMT
Message-ID: <201104260122.p3Q1Ms1X009789@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36075 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1DZBWz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 21:22:55 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3Q1MsDW009790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 01:22:54 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #75 from rocko <rockorequin@hotmail.com>  2011-04-26 01:22:52 ---
Created an attachment (id=55522)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=55522)
null pointer deference hit while running without a desktop

I just now managed to crash the kernel *without* a desktop running. Running the
VM in recovery mode (ie console with no desktop), I tried two ways:

a) I modified the script to mount the device after binding it. With no other
modifications, the kernel did not crash with around 50 bind/mount/unbind
attempts (which is not conclusive but seems a reasonable number of tests to
try). Note that with this setup, the device kept getting a new drive letter on
each bind, ie /dev/sdb, /dev/sdc, /dev/sdd, etc, whereas with a desktop running
it is assigned each time to /dev/sdb.

b) I modified the script to umount the device immediately after the subsequent
unbind, ie the process is bind, mount on /tmp/usb, unbind, umount /tmp/usb. It
crashed with the null pointer dereference first time (log attached just in
case).

So the umount might be the key to the issue. I should think desktop's
auto-mounting code would also be trying to umount devices once it realises
they're no longer there.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
