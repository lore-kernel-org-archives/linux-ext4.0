From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 7 Feb 2011 03:11:29 GMT
Message-ID: <201102070311.p173BTD9019452@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46567 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1BGDLa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Feb 2011 22:11:30 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p173BUkt019453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 03:11:30 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #23 from rocko <rockorequin@hotmail.com>  2011-02-07 03:11:05 ---
Thanks for the info on how to use the sysrq functions. Those keys work nicely
normally. But unfortunately they don't work once it freezes with this bug - the
freeze is total, which I guess also explains the truncated stack traces.

I wasn't suggesting that memory was freed just because the device disappeared -
I was wondering if it is possible that the kernel could umount several missing
devices and free the memory pertaining to them (all good so far), but get
pointers to the freed memory mixed up, possibly through caching of the freed
memory pointer.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
