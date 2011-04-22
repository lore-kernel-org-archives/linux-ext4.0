From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Fri, 22 Apr 2011 13:42:06 GMT
Message-ID: <201104221342.p3MDg605012869@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54876 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1DVNmH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 09:42:07 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3MDg68l012871
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Apr 2011 13:42:07 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832


rocko <rockorequin@hotmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|kernel crashes upon resume  |kernel crashes when a
                   |if usb devices are removed  |mounted ext3/4 file system
                   |when suspended              |is physically removed




--- Comment #63 from rocko <rockorequin@hotmail.com>  2011-04-22 13:41:45 ---
2.6.39-rc4 is either _much_ harder to crash, or my script isn't as reliable at
crashing the kernel as I thought (until now I've mostly used the suspend/resume
method with multiple drives attached). I've now done over 200 bind/unbind
cycles of this external ext4 USB key without a crash. But I certainly did crash
it once earlier today.

An observation from earlier that might be relevant here: a couple of weeks ago
one of my drives got itself into a state that made it crash the kernel almost
every time I unplugged it, but after I did an fsck on it it became
significantly less likely to cause the crash. And after my last reboot there
was a lot of fsck'ing going on, probably including the external drive.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
