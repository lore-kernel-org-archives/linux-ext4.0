From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Tue, 18 Jun 2013 01:14:52 +0000 (UTC)
Message-ID: <20130618011452.08FB511FB35@bugzilla.kernel.org>
References: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3FRBO4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 21:14:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 37E1C20348
	for <linux-ext4@vger.kernel.org>; Tue, 18 Jun 2013 01:14:55 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1AA402034D
	for <linux-ext4@vger.kernel.org>; Tue, 18 Jun 2013 01:14:52 +0000 (UTC)
In-Reply-To: <bug-59801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801


yyl810 <yang.yulin@zte.com.cn> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




--- Comment #5 from yyl810 <yang.yulin@zte.com.cn>  2013-06-18 01:14:51 ---
I totally understand you and appreciate your suggestion.

Actually yesterday I tried compiling 1.42.7 on my system, although it's
succeeded, but unfortunately there is crash, anyway I found a way to try.

Thanks again.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
