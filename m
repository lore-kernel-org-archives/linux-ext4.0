From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98091] kernel/sched/core.c:7291 __might_sleep+0x87/0x90()
Date: Wed, 13 May 2015 04:29:22 +0000
Message-ID: <bug-98091-13602-d3Fa5lM7Zy@https.bugzilla.kernel.org/>
References: <bug-98091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbbEME3Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 00:29:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CBA4620411
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 04:29:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0AFF12041C
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 04:29:23 +0000 (UTC)
In-Reply-To: <bug-98091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=98091

poma <pomidorabelisima@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|MD                          |ext4
            Product|IO/Storage                  |File System

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
