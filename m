From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Mon, 31 Jan 2011 16:08:28 GMT
Message-ID: <201101311608.p0VG8SnU011274@demeter1.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36094 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab1AaQI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Jan 2011 11:08:29 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0VG8So1011275
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 16:08:28 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652





--- Comment #11 from Eric Sandeen <sandeen@redhat.com>  2011-01-31 16:07:56 ---
Seems we have about 4 regressions all tracked in 1 bugzilla, sadly.  1 bug per
regression would work better... though partly my fault for getting OT on the
original bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
