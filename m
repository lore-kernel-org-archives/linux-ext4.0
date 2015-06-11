From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 11 Jun 2015 02:01:28 +0000
Message-ID: <bug-89511-13602-u26LrKyU7g@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbbFKCBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:01:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8D92420632
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 02:01:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 69E122062F
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 02:01:29 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

matt <vickm78@hotmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vickm78@hotmail.com

--- Comment #57 from matt <vickm78@hotmail.com> ---
Created attachment 179581
  --> https://bugzilla.kernel.org/attachment.cgi?id=179581&action=edit
lsusb -v seagate expansion

I've been experiencing the same issue. The 'temporary write through' workaround
has helped on Arch but didn't seem to work on Ubuntu LTS with kernel 3.10.
Adding my device's lsusb -v in the hope that it helps.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
