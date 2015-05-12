From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98091] kernel/sched/core.c:7291 __might_sleep+0x87/0x90()
Date: Tue, 12 May 2015 00:51:48 +0000
Message-ID: <bug-98091-13602-3v2sIp6Kgp@https.bugzilla.kernel.org/>
References: <bug-98091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbbELAvv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2015 20:51:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C0563203A5
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2015 00:51:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F2C3E20390
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2015 00:51:48 +0000 (UTC)
In-Reply-To: <bug-98091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=98091

poma <pomidorabelisima@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |MD
            Product|File System                 |IO/Storage

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
