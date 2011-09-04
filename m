From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sun, 4 Sep 2011 03:53:20 GMT
Message-ID: <201109040353.p843rK51019911@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52894 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1IDDxX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Sep 2011 23:53:23 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p843rMC7019912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 4 Sep 2011 03:53:22 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #90 from rocko <rockorequin@hotmail.com>  2011-09-04 03:53:16 ---
BTW, CONFIG_NETCONSOLE=y doesn't make any difference for me (it still crashes
the kernel), although I didn't really expect it to since I had it compiled in
as a module and was specifically loading it prior to running the test that
crashes the kernel.

So I have a reproducible test case (which, even better, works in VirtualBox
VM), but the error information generated in the crash log isn't sufficient for
tracking down this problem. Where do I go from here?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
