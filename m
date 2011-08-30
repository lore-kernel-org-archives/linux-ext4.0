From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42052] kernel BUG at
 build/buildd/linux-2.6.38/kernel/timer.c:668
Date: Tue, 30 Aug 2011 15:05:24 GMT
Message-ID: <201108301505.p7UF5Oqm029156@demeter2.kernel.org>
References: <bug-42052-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40129 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab1H3PFZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 11:05:25 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7UF5Ooh029157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 15:05:24 GMT
In-Reply-To: <bug-42052-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42052





--- Comment #2 from sanjeev mk <sanjeevmk4890@gmail.com>  2011-08-30 15:05:24 ---
(From update of attachment 70892)
Mounting the attached image exposes the said bug

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
