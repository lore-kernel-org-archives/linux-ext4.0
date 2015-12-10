From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 10 Dec 2015 02:51:52 +0000
Message-ID: <bug-107301-13602-OybNWXrkzg@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41249 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbLJCvz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2015 21:51:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D30B0204FB
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2015 02:51:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 64BB6204A0
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2015 02:51:52 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #21 from Andreas Gruenbacher <agruen@kernel.org> ---
As far as ceph is concerned, are there reasons for not using 512-byte inodes?
In-inode xattrs are generally much faster.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
