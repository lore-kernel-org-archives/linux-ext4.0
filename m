From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Mon, 04 Jul 2016 10:46:25 +0000
Message-ID: <bug-121371-13602-iYF87qhJzU@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59216 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbcGDKq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jul 2016 06:46:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8D9172021A
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jul 2016 10:46:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0FAA520172
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jul 2016 10:46:26 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

Grief <iamgrief@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|INVALID                     |---

--- Comment #5 from Grief <iamgrief@gmail.com> ---
I think that there still could be a bug since I am not able to read directory
attributes:
http://askubuntu.com/questions/794371/lsattr-permission-denied-while-reading-flags-on-directory

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
