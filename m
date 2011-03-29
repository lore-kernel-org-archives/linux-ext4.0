From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32082] ext4: oops when mounting intentionally corrupted
 filesystem
Date: Tue, 29 Mar 2011 09:05:19 GMT
Message-ID: <201103290905.p2T95Jn5025948@demeter2.kernel.org>
References: <bug-32082-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:37767 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1C2JFT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 05:05:19 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2T95JYL025949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 09:05:19 GMT
In-Reply-To: <bug-32082-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32082





--- Comment #2 from Sami Liedes <sliedes@cc.hut.fi>  2011-03-29 09:05:17 ---
Yes, seems to fix the panic. Thank you.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
