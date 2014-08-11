From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Mon, 11 Aug 2014 03:08:49 +0000
Message-ID: <bug-61601-13602-zVUEkdJEPI@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37773 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaHKDIw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 23:08:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4C631201EC
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 03:08:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 07B1A201BC
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 03:08:50 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

James Campbell <james.campbell@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |james.campbell@yahoo.com

--- Comment #7 from James Campbell <james.campbell@yahoo.com> ---
Created attachment 146181
  --> https://bugzilla.kernel.org/attachment.cgi?id=146181&action=edit
call trace screen print - kernel 3.16

kernel panic occurs with rootflags=noatime in kernel command line
boots ok without rootflags=noatime

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
