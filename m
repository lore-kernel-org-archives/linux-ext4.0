From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Wed, 8 Sep 2010 08:24:03 GMT
Message-ID: <201009080824.o888O3t0030734@demeter1.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33698 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0IHIYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 04:24:05 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o888O3oL030736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 8 Sep 2010 08:24:04 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #28 from Tejun Heo <tj@kernel.org>  2010-09-08 08:23:54 ---
Ah, okay, now I remember this one.  Jan, what do you think about comment#25? 
The patch would prevent udev from triggering the problem automatically but it's
still broken.

Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
