From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Fri, 28 Jan 2011 17:32:15 GMT
Message-ID: <201101281732.p0SHWF9o015985@demeter2.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35982 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1A1RcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jan 2011 12:32:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0SHWFRt015986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Jan 2011 17:32:15 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652





--- Comment #5 from Eric Sandeen <sandeen@redhat.com>  2011-01-28 17:32:13 ---
I could also be off base ;)  Is the filesystem under test created with the
lazy_itable_init feature?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
