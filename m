From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50021] ext4 discard option not working on journal dissabled
 filesystem
Date: Mon,  5 Nov 2012 18:00:08 +0000 (UTC)
Message-ID: <20121105180008.AD29811F8EC@bugzilla.kernel.org>
References: <bug-50021-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55271 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab2KESAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2012 13:00:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3552B2022A
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 18:00:11 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BC1A32019D
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 18:00:08 +0000 (UTC)
In-Reply-To: <bug-50021-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50021





--- Comment #4 from Gregory Krzystek <ninex@o2.pl>  2012-11-05 18:00:08 ---
Thanks guys! :D
This patch works for me.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
