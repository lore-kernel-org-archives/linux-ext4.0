From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17872] ext4 does not honour chattr +s attribute
Date: Mon, 6 Sep 2010 03:16:44 GMT
Message-ID: <201009060316.o863Gis7008268@demeter1.kernel.org>
References: <bug-17872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35842 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab0IFDQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Sep 2010 23:16:45 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o863Gj05008269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Sep 2010 03:16:45 GMT
In-Reply-To: <bug-17872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17872





--- Comment #4 from Rob Fortune <usedonlytosignup@gmail.com>  2010-09-06 03:16:43 ---
And apologies for the spammy third reply but a three to five pass random wipe
before zeroing them would be a much better feature than just zeroing them
anyway.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
