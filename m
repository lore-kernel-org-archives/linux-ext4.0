From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72181] ext4_mb_generate_buddy:22764 clusters in bitmap, 22762
 in gd
Date: Tue, 18 Mar 2014 02:40:52 +0000
Message-ID: <bug-72181-13602-oYj8bXnA8l@https.bugzilla.kernel.org/>
References: <bug-72181-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38152 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaCSRx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 13:53:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 39378202D1
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 02:40:53 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 832BA202A1
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 02:40:52 +0000 (UTC)
In-Reply-To: <bug-72181-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72181

WeiZhang <zweiustc@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|ext4_mb_generate_buddy:free |ext4_mb_generate_buddy:2276
                   |block calculation seems to  |4 clusters in bitmap, 22762
                   |overflow                    |in gd

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
