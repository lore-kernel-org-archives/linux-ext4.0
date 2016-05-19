From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Thu, 19 May 2016 08:56:04 +0000
Message-ID: <bug-118401-13602-bp2vSBgVzI@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbcESI4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2016 04:56:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7787520225
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:56:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3C01B20219
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:56:05 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D118401

--- Comment #5 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Thanks for taking the time to comment :)

https://help.ubuntu.com/community/Kernel/Compile says /boot/config* are=
 the
kernel configurations used to create the .deb's of the kernel's (which =
I got
from http://kernel.ubuntu.com/~kernel-ppa/mainline/), so I attached tho=
se at
least. Maybe there's something relevant in the change from 4.2.8 to 4.3=
 (that
didn't change back in 4.6)?

I did find some tips on https://wiki.archlinux.org/index.php/Boot_debug=
ging and
http://elinux.org/Kernel_Debugging_Tips =E2=80=93 I'll try to figure ou=
t how to get a
detailed log of the failing boot, and see if there are other kernel ima=
ges that
might work.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
