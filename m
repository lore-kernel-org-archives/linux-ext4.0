From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Wed, 9 Jun 2010 18:31:31 GMT
Message-ID: <201006091831.o59IVVhS022607@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60632 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0FISbd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 14:31:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o59IVVRx022609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 18:31:31 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #11 from Larry Finger <Larry.Finger@lwfinger.net>  2010-06-09 18:31:02 ---
I have the 2.6.34 kernel from wireless-testing, which should be the same a
mainline, except for the wireless part. I never see this WARNING with that
kernel, only from 2.6.35-rc1 onward.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
