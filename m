From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Fri, 08 Apr 2016 20:46:12 +0000
Message-ID: <bug-107301-13602-dYWvqZ7o64@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbcDHUqQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2016 16:46:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3B4B2202B8
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 20:46:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ABA4D202BE
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 20:46:12 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #25 from Jan Kara <jack@suse.cz> ---
Phillip, I see you are using some variant of 4.1 kernel. As comment 23
mentions, fixes for the problem have landed in 4.6-rc1. So is it possible for
you to test that kernel?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
