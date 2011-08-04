From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40512] EXT4_IOC_MIGRATE is dangerous on directories
Date: Thu, 4 Aug 2011 13:26:34 GMT
Message-ID: <201108041326.p74DQYpw032704@demeter2.kernel.org>
References: <bug-40512-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:59483 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1HDN0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Aug 2011 09:26:35 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p74DQYR3032705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 13:26:34 GMT
In-Reply-To: <bug-40512-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40512





--- Comment #2 from Benjamin Peterson <benjamin@python.org>  2011-08-04 13:26:33 ---
When I ran e2fsck on the partition, it reported EXTENTS_FL was not set.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
