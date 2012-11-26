From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 10:30:13 +0000 (UTC)
Message-ID: <20121126103013.637D411FB81@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35750 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab2KZKaU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 05:30:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41C20201F9
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 10:30:15 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6CCAE201F2
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 10:30:13 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981





--- Comment #4 from Lukas Czerner <lczerner@redhat.com>  2012-11-26 10:30:13 ---
Yes, that's what I said XFS has its own read/write exclusion. However we're
reading/writing a single page here and page read/write shoud be atomic so we
should _not_ see page with mixed data. Basically the page should be locked when
we copy data from/to it,

-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
