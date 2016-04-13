From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 13 Apr 2016 09:07:35 +0000
Message-ID: <bug-107301-13602-6dzSy4YBwy@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52559 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759551AbcDMJHk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2016 05:07:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0614320381
	for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2016 09:07:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 485512034C
	for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2016 09:07:36 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #27 from Jan Kara <jack@suse.cz> ---
(In reply to Philipp Matthias Hahn from comment #26)
> Can you be more specific on which change in 4.6-rc1 you're referencing?

Well, it is a series of changes, commits:
f9a61eb4e2471c56a63cd804c7474128138c38ac
82939d7999dfc1f1998c4b1c12e2f19edbdff272
be0726d33cb8f411945884664924bed3cb8c70ee
ecd1e64412d5242b8afdef58a714bab3c5464f79
c2f3140fe2eceb3a6c1615b2648b9471544881c6
f0c8b46238db9d51ef9ea0858259958d0c601cec
7a2508e1b657cfc7e1371550f88c7a7bc4288f32
2335d05f3a83f5290ec28c1ed30c1c742a37edc9
dc8d5e565f00c9442fa1cbf9acc115475628527c
3fd164629d25b04f291a79a013dcc7ce1a301269
6048c64b26097a0ffbd966866b599f990e674e9b

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
