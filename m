From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Tue, 24 Aug 2010 23:59:46 GMT
Message-ID: <201008242359.o7ONxkim027123@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38866 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0HXX7r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 19:59:47 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7ONxkpm027125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 24 Aug 2010 23:59:46 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711





--- Comment #3 from John Johansen <john.johansen@canonical.com>  2010-08-24 23:59:41 ---
Tobias,

can you try booting with the kernel parameter of apparmor=0

If apparmor is causing the problem then, this wil disable apparmor and cause
the kernel to fall back to just DAC.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
