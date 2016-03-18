From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 18 Mar 2016 22:20:08 +0000
Message-ID: <bug-102731-13602-j2gVy47fTQ@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60099 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbcCRWUM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2016 18:20:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E4972039C
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 22:20:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8EBA620396
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 22:20:08 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

Vaclav Ovsik <vaclav.ovsik@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vaclav.ovsik@gmail.com

--- Comment #39 from Vaclav Ovsik <vaclav.ovsik@gmail.com> ---
Hello,
please take a look on
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=818502
IMO the problem is in the hypervisor in 3.16 and older Intel CPU.
Currently I'm testing hypervisor 4.1 and it seems to be OK.
-- 
Zito

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
