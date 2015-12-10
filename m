From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 10 Dec 2015 16:51:43 +0000
Message-ID: <bug-107301-13602-pTBio41oqF@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbLJQvr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 11:51:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22CF4205E3
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2015 16:51:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 79214205B3
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2015 16:51:43 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #22 from Theodore Tso <tytso@mit.edu> ---
Using 512 byte inodes for Ceph is a really good idea.

Before folks go there, can people give Jan Kara's mbcache rewrite a try?

http://thread.gmane.org/gmane.comp.file-systems.ext4/51094

I'd really appreciate comments and any performance numbers you could give me on
your workloads.

Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
