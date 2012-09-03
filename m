From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Mon,  3 Sep 2012 10:24:40 +0000 (UTC)
Message-ID: <20120903102440.33F4011FB29@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2ICKYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 06:24:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0CEF720363
	for <linux-ext4@vger.kernel.org>; Mon,  3 Sep 2012 10:24:47 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 447902036A
	for <linux-ext4@vger.kernel.org>; Mon,  3 Sep 2012 10:24:46 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #16 from Jan Kara <jack@suse.cz>  2012-09-03 10:24:39 ---
And just for record. the problem is the same... Mirek, if upgrading the kernel
is an option for you, trying the latest stable kernel from 3.5 might be worth a
shot. I didn't find anything that should fix your oops but there are some
changes in the extent code so maybe your problem will get fixed as a side
effect.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
