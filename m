From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Thu, 13 Nov 2014 14:24:56 +0000
Message-ID: <bug-86471-13602-gR4SGHtNXT@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbaKMOY7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 09:24:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 132512021A
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:24:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B88AF2020E
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:24:56 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86471

JPT <j-p-t@gmx.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |j-p-t@gmx.net

--- Comment #9 from JPT <j-p-t@gmx.net> ---
Hi, 

I am exeriencing exactly the same bug with selfbuilt kernel 3.17.2 on an arm
machine. 
I fear it's killing my SSD. 

What does it mean the bug is "solved"?
Where is the patch, which version of the kernel source contains the solution?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
