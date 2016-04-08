From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 08 Apr 2016 15:49:34 +0000
Message-ID: <bug-102731-13602-TPLfqRnOgK@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41115 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbcDHPtj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2016 11:49:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 145902021A
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 15:49:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 30F0F20306
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 15:49:36 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #45 from John Hughes <john@calva.com> ---
Sorry for my lack of reactivity, I've been a bit ill (had a terrible cough,
actually).

I've been running with a 4.2.3 kernel in the host since 19/1/2016 (around 80
days) with no problems.

Yesterday my host was rebooted (power cut) and ran with the 3.16 kernel for one
day and I saw the problem again.

Based on that, and Vaclav's superb research I am convinced that the problem is
in the host system, probably fixed by the patch he found.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
