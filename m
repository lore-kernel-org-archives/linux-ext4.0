From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sat, 23 Apr 2011 04:12:31 GMT
Message-ID: <201104230412.p3N4CVUK029027@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42167 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1DWEMb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 00:12:31 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3N4CV2V029028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 04:12:31 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #66 from rocko <rockorequin@hotmail.com>  2011-04-23 04:12:30 ---
FYI, I reproduced it on the second attempt at suspend/resume with 2.6.38.4. I
was slightly hopeful it might be fixed as some of the patches seemed to be
addressing this kind of situation.

I had a thought about the consistency of the logs: I think the ones related to
this bug might be consistent, it's just that I've posted logs that might be due
to different bugs entirely. The ntfs/fuse one turned out to be another bug, for
instance. It's possible the logs from 2.6.36-rc1 were caused by a number of of
other bugs, rc1 being in all likelihood the least robust of any kernel release.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
