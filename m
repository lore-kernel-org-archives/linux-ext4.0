From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20992] Data corruption triggers ext4 oops
Date: Sat, 23 Oct 2010 14:58:49 GMT
Message-ID: <201010231458.o9NEwnsc027853@demeter2.kernel.org>
References: <bug-20992-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:48039 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0JWO6u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Oct 2010 10:58:50 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9NEwo4d027854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Oct 2010 14:58:50 GMT
In-Reply-To: <bug-20992-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20992





--- Comment #2 from Bart Van Assche <bart.vanassche@gmail.com>  2010-10-23 14:58:48 ---
Created an attachment (id=34542)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=34542)
Kernel oops

Attached backtrace.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
