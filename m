From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 6 Mar 2011 10:25:47 GMT
Message-ID: <201103061025.p26APlm0018823@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52216 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1CFKZs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2011 05:25:48 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p26APlsq018824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 6 Mar 2011 10:25:47 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #38 from rocko <rockorequin@hotmail.com>  2011-03-06 10:25:46 ---
The syslog shows that, for whatever reason, sometimes processes do try and
access files on the drives after they are removed. Messages to this effect
typically appear if the kernel _doesn't_ crash.

Is it possible that there might be a sync/locking problem here that leads to
the crash? eg could the crash occur if a process tries to access the removed
drive while the kernel is in the process of unmounting it? Perhaps this would
explain why the crash is more likely to happen on resume (ie when many
processes are waking up and presumably more likely to try and access files) and
when multiple drives are removed (ie when the kernel is likely to be more busy
trying to unmount the missing drives).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
