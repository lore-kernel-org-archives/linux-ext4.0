From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 12:17:52 +0000 (UTC)
Message-ID: <20121126121752.F383511FB80@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39437 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2KZMSA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 07:18:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ADD4A20251
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 12:17:54 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0224B2023C
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 12:17:53 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981





--- Comment #8 from Alan <alan@lxorguk.ukuu.org.uk>  2012-11-26 12:17:52 ---
(retagged for 3.7-rc as per Lukas email, otherwise my scripts will keep wanting
to close it as RHEL and not for upstream)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
