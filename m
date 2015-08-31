From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103731] timeout on SSD and kernel 4.1.3 and >
Date: Mon, 31 Aug 2015 16:02:46 +0000
Message-ID: <bug-103731-13602-oGOymer29V@https.bugzilla.kernel.org/>
References: <bug-103731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35596 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbbHaQCu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2015 12:02:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5ABEE206FF
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 16:02:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 84091206F8
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 16:02:46 +0000 (UTC)
In-Reply-To: <bug-103731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103731

Giuseppe <giudeluca88@hotmail.it> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |x86-64
            Product|File System                 |Platform Specific/Hardware

--- Comment #2 from Giuseppe <giudeluca88@hotmail.it> ---
(In reply to Eric Sandeen from comment #1)
> This behavior has nothing to do with ext4...

I agree with you. probably is a communication error between SSD and kernel. Do
I have to change the Component?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
