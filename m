From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Tue, 12 Apr 2016 12:52:24 +0000
Message-ID: <bug-107301-13602-Xu5jD3YIde@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbcDLMw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2016 08:52:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A065720383
	for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2016 12:52:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A625120361
	for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2016 12:52:24 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #26 from Philipp Matthias Hahn <pmhahn@pmhahn.de> ---
(In reply to Jan Kara from comment #25)
> Phillip, I see you are using some variant of 4.1 kernel. As comment 23
> mentions, fixes for the problem have landed in 4.6-rc1. So is it possible
> for you to test that kernel?

As that problem happend in production, I'm unwilling to install an -rc kernel
there.
Currently I don't have the time to try to reproduce it in my development
environment, but that may change if that lockup happens again.
Can you be more specific on which change in 4.6-rc1 you're referencing?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
