From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43305] Deleting a folder with 500 000 small files causes
 deadlock in start_this_handle.irsa.7
Date: Tue, 29 May 2012 15:43:16 +0000 (UTC)
Message-ID: <20120529154316.B5D3E11FD19@bugzilla.kernel.org>
References: <bug-43305-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53429 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2E2PnS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 11:43:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F40B203B0
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 15:43:17 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id BA6F620254
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 15:43:16 +0000 (UTC)
In-Reply-To: <bug-43305-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43305





--- Comment #3 from Aigars Mahinovs <aigarius@gmail.com>  2012-05-29 15:43:16 ---
I reproduced the problem like this (in an empty folder):

for i in {0..500000}; do echo 1234567890 > $i; done;
ls | xargs -n 100 -P 100 rm

Got the lock-up on the third try.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
