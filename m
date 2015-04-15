From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] Oops in __d_lookup when accessing certain files
Date: Wed, 15 Apr 2015 14:19:24 +0000
Message-ID: <bug-96641-13602-FJ76MiLuJg@https.bugzilla.kernel.org/>
References: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbbDOOT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2015 10:19:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A1FDB202FE
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2015 14:19:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4785F202FF
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2015 14:19:24 +0000 (UTC)
In-Reply-To: <bug-96641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

--- Comment #3 from dann frazier <dannf@dannf.org> ---
Link back to Ubuntu bug:
  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1440536

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
