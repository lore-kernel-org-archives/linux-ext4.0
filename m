From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sat, 20 Feb 2016 10:15:12 +0000
Message-ID: <bug-112631-13602-5TGx1bppap@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427571AbcBTKPQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Feb 2016 05:15:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8EAEF2055B
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 10:15:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CB2FE20529
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 10:15:12 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

Manu Bourguin <kernel@chezmanu.eu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@chezmanu.eu

--- Comment #4 from Manu Bourguin <kernel@chezmanu.eu> ---
I confirm same issue, with same error messages with Raspbian Jessie (lite) on
Raspberry Pi 2 (ARMv7).
Everything is OK with 4.1.17, unable to unlock crypted volume since upgrade to
4.1.18.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
