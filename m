From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Sat, 2 Apr 2011 08:09:08 GMT
Message-ID: <201104020809.p32898qx029144@demeter2.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:50203 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1DBIJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 04:09:08 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p32898qE029145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 2 Apr 2011 08:09:08 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482





--- Comment #7 from Tom <egokillsall@gmail.com>  2011-04-02 08:09:06 ---
Oh well, just got a SIGSEGV from aptitude.. Reboot and everything is fine
again. Something can be incompatible with something in this laptop I feel..

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
