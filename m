From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42052] kernel BUG at
 build/buildd/linux-2.6.38/kernel/timer.c:668
Date: Tue, 30 Aug 2011 15:08:29 GMT
Message-ID: <201108301508.p7UF8T0U013399@demeter1.kernel.org>
References: <bug-42052-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:43102 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1H3PI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 11:08:29 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7UF8TDP013400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 15:08:29 GMT
In-Reply-To: <bug-42052-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42052





--- Comment #3 from sanjeev mk <sanjeevmk4890@gmail.com>  2011-08-30 15:08:27 ---
Created an attachment (id=70902)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=70902)
The backtrace printed on mounting the ext4 image

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
