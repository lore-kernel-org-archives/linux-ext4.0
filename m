From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 11 Nov 2015 14:53:10 +0000
Message-ID: <bug-107301-13602-bAQvW8mTOD@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbbKKOxN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2015 09:53:13 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E4DE8206DB
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 14:53:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5F8AE20672
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 14:53:10 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #17 from Jan Kara <jack@suse.cz> ---
Ultimately it is Ted's call but your argument is like (randomly taken out of
top of my head): "Proper locking to protect from hole punching costs us some
performance and our workload doesn't use hole punching so let's create mount
option to disable the locking". Sure it can be done and it will benefit your
workload but how much you gain? And how many users need this? This has to be
weighted against the cost of the new mount option in terms of testing and
usability (and code complexity but that is fairly small in this case so I'm not
that concerned).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
