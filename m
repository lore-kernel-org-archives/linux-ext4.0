From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] Mount command sees partition 2 and partition 7 as same
 partition
Date: Thu, 17 Jun 2010 17:42:32 GMT
Message-ID: <201006171742.o5HHgWZJ025199@demeter.kernel.org>
References: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49910 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509Ab0FQRmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 13:42:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HHgWbf025201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 17:42:32 GMT
In-Reply-To: <bug-16227-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227





--- Comment #5 from Eugene Blanchard <eugene.blanchard@sait.ca>  2010-06-17 17:42:29 ---
After booting to parition p2 root / (p1 is /boot, p3 is swap)

I created the following directories:

/mnt/p5
/mnt/p6
/mnt/p7

Then mounted using the following commands:

mount /dev/cciss/c0d0p5 /mnt/p5
mount /dev/cciss/c0d0p5 /mnt/p6
mount /dev/cciss/c0d0p5 /mnt/p7

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
