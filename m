From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36262] ext3 umount: BUG: unable to handle kernel paging request
Date: Thu, 2 Jun 2011 11:44:02 GMT
Message-ID: <201106021144.p52Bi2To022649@demeter1.kernel.org>
References: <bug-36262-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49476 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab1FBLoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 07:44:04 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p52Bi2cY022650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jun 2011 11:44:03 GMT
In-Reply-To: <bug-36262-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36262





--- Comment #4 from Roger Luethi <rl@hellgate.ch>  2011-06-02 11:44:01 ---
(In reply to comment #3)
> Hmm, by any chance, was the USB disk pulled before the umount actually run?

I am pretty sure it was not.

However, the disk seems to have some sort of autosuspend feature: if unused for
some time, it spins down the disk. When used again, it comes up okay (after a
few seconds). That's all from memory, let me know if you need me to verify or
test.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
