From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Tue, 3 May 2011 02:19:44 GMT
Message-ID: <201105030219.p432JiW9005620@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45919 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab1ECCTp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 22:19:45 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p432JiKh005621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 02:19:44 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #79 from rocko <rockorequin@hotmail.com>  2011-05-03 02:19:42 ---
Created an attachment (id=56272)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=56272)
oops log for null pointer dereference 2.6.39-rc5

Still present in 2.6.39-rc5 (log attached).

Yes, I can readily reproduce this bug in a VM with my current ext4 USB test key
- the attached log is from a fresh install of Ubuntu 11.04 amd64 in VirtualBox
4.0.6, with the kernel upgraded to 2.6.39-rc5.

Fwiw, 2.6.39-rc5 behaved a bit differently from 2.6.38: the system reported
issues with eg /dev/sdb1 and I started seeing multiple mountpoints in the
desktop that I couldn't unmount (/media/disk, /media/disk_, /media/disk__).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
