From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Thu, 19 Feb 2015 16:36:38 +0000
Message-ID: <bug-93491-13602-Y9HyOXzSIX@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbbBSQgl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 11:36:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0C7CD202AE
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:36:40 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AE8FD20272
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:36:38 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

--- Comment #2 from Ionut Radu <ionut.radu@gmail.com> ---
Created attachment 167571
  --> https://bugzilla.kernel.org/attachment.cgi?id=167571&action=edit
dmesg after reboot




I've attached dmesg after reboot.
A fedora bug was not filled by the abrt. Computer stalled and after reboot abrt 
tells there is not enough data to report a bug.

After computer stall and forced turn off, filesystem got corrupted and was
fixed via emergency disk with fsck.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
