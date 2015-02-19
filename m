From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Thu, 19 Feb 2015 16:45:56 +0000
Message-ID: <bug-93491-13602-XizmbkLUZD@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47218 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbBSQp7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 11:45:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F51920295
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:45:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 32D9E2022A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:45:57 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

--- Comment #3 from Eric Sandeen <sandeen@redhat.com> ---
dmesg after reboot won't be helpful, I'm afraid.

If the fs was corrupt and fixed, but output not saved, and no further
information is available from the crash, this will be very hard to resolve.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
