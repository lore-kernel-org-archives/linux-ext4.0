From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] EXT4 causes corrupt BitTorrent downloads
Date: Sun, 10 Apr 2011 16:18:14 GMT
Message-ID: <201104101618.p3AGIEwh001112@demeter2.kernel.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:57063 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1DJQSP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 12:18:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3AGIEol001113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 10 Apr 2011 16:18:14 GMT
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32972





--- Comment #2 from Damien Grassart <damien@grassart.com>  2011-04-10 16:18:13 ---
Hi, thanks for the quick response. I've just tested and confirmed that your fix
works.

Also, should that comment inside the conditional be updated (or moved up) as
well? Otherwise it seems to be out of sync with the code.

Thanks,
-Damien

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
