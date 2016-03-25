From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 25 Mar 2016 16:55:03 +0000
Message-ID: <bug-102731-13602-xFh7ucgu5n@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbcCYQzI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Mar 2016 12:55:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 55AEF2034A
	for <linux-ext4@vger.kernel.org>; Fri, 25 Mar 2016 16:55:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4873F20340
	for <linux-ext4@vger.kernel.org>; Fri, 25 Mar 2016 16:55:04 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #44 from cwseys@physics.wisc.edu ---
Any ideas why ext4 in guests with kernel version 3.2.x (Wheezy) did not go 
read-only, but guests with 3.16.x (Jessie) did?

I suppose running a vmhost with kernel 3.16 and bisecting the guest's kernel 
from 3.2 to 3.16 would give us this answer.

But not sure how interesting it would be given that the root cause is KVM not 
simulating real machine correctly.

C.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
