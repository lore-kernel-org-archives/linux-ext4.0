From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Thu, 30 Aug 2012 09:06:52 +0000 (UTC)
Message-ID: <20120830090652.B717B11FB3C@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44698 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab2H3JHB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 05:07:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 783232027B
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 09:07:00 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 252F62029B
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 09:06:55 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #11 from Mirek Rusin <mirek@me.com>  2012-08-30 09:06:52 ---
It should happen sometime today, will let you know, on ubuntu it's just:

     echo w > /proc/sysrq-trigger

as root, right?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
