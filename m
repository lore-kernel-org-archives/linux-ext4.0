From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] Mount command sees partition 2 and partition 7 as same
 partition
Date: Thu, 17 Jun 2010 17:34:00 GMT
Message-ID: <201006171734.o5HHY09F023281@demeter.kernel.org>
References: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39264 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab0FQReC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 13:34:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HHY0Gg023287
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 17:34:01 GMT
In-Reply-To: <bug-16227-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227





--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2010-06-17 17:33:57 ---
I was sorta hoping for /proc/mounts when you saw this problem of one mount
affecting the other; you only have /dev/cciss/c0d0p1 mounted there it seems.

My money is on mounting the same device to 2 mountpoints.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
