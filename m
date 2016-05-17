From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118041] My tricky script involving zram and device mapper hangs
 on "mount"
Date: Tue, 17 May 2016 16:27:24 +0000
Message-ID: <bug-118041-13602-ORyYGKzzKU@https.bugzilla.kernel.org/>
References: <bug-118041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbcEQQ11 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 12:27:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5A55B20351
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 16:27:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2973620328
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 16:27:25 +0000 (UTC)
In-Reply-To: <bug-118041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118041

Navin <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #1 from Navin <navinp1912@gmail.com> ---
What is cryptie4-ff ? it is linear or raid setup for dmsetup.
What is hashed_update.
Seems like only part of the script is posted. 
Can you please get a working standalone independent script ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
