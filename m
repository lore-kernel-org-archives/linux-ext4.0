From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sun, 24 Apr 2011 01:35:54 GMT
Message-ID: <201104240135.p3O1Zs0T023357@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39499 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab1DXBf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 21:35:58 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3O1ZsHN023596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 01:35:54 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #68 from rocko <rockorequin@hotmail.com>  2011-04-24 01:35:15 ---
Created an attachment (id=55282)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=55282)
oops on USB unbind - unable to handle kernel paging request

> Just because *I* don't like desktops that initiate I/O at random times
> when I don't request doesn't mean that other users shouldn't use it.

Honest, I wasn't having a go, I meant it tongue-in-cheek!

I have managed to reproduce the crash on a VM and log the output via
netconsole. An important thing to note is that it made no difference when my
script was set to call sync just prior to the unbind. (In fact, it crashed on
the very first unbind when I did this.)

The VM was doing very little: I booted into the desktop, ran gnome-terminal,
ran the modprobe command to load netconsole, and then ran the unbind/rebind
script. The first crash happened on the fourth unbind.

I've attached the resulting log, which is for an 'unable to handle kernel
paging request' - hopefully it's sufficiently complete, but it doesn't look
much longer than some of the ones I captured manually earlier. Note that I
wasn't doing suspend/resume, just running the unbind/rebind script, and this
one is without sync being called.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
