From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Fri, 05 Feb 2016 23:11:44 +0000
Message-ID: <bug-111961-13602-jrTXa1uxaz@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48504 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbcBEXLr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 18:11:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6001D203E6
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 23:11:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0548A203B4
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 23:11:45 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #5 from Sebastian <info@dynpages.de> ---
Created attachment 203011
  --> https://bugzilla.kernel.org/attachment.cgi?id=203011&action=edit
journalctl | grep ext4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
