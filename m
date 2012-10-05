From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  5 Oct 2012 18:20:46 +0000 (UTC)
Message-ID: <20121005182046.40E4011FB37@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737Ab2JESV3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 14:21:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B7BE205B9
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 18:21:05 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 58DD020594
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 18:20:51 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #11 from Eric Sandeen <sandeen@redhat.com>  2012-10-05 18:20:45 ---
Agreed.  Random people on gentoo forums notwithstanding, I see no evidence that
this device needs help from the kernel to function properly.  All SSDs have
larger structures in use internally, and firmware to manage the fact that they
expect to get smaller IOs from the OS.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
