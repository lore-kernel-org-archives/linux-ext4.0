From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Thu, 25 Aug 2011 10:28:05 GMT
Message-ID: <201108251028.p7PAS5KH001824@demeter2.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48274 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1HYK2H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 06:28:07 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7PAS50l001825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 10:28:05 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #4 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2011-08-25 10:28:03 ---
I also have CONFIG_EXT4_USE_FOR_EXT23=y , hower I use it only to mount /boot
(ext3), rest of file systems are ext4. So it XT4_USE_FOR_EXT23=y is not an
issue IMHO.

Your call trace is somehow similar that it is also in ext4_evict_inode code.
However deadlock is detected in simpler condition (single CPU, with some bug
due re-aquiring lock by same task).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
