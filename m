From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Wed, 13 Jul 2011 19:57:56 GMT
Message-ID: <201107131957.p6DJvu0j019738@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40761 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1GMT55 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jul 2011 15:57:57 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6DJvu2j019739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jul 2011 19:57:56 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072





--- Comment #9 from mkkot <marcin2006@gmail.com>  2011-07-13 19:57:55 ---
Okay, thanks to this patch most people agreed it's cron which triggers syslog
to write. I'm not convinced so since yesterday trying to compile kernel but had
some difficulties (first of all, thought it will take 15 minutes on my pc,
phew). Need some more time but I'm going to test this patch for sure.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
