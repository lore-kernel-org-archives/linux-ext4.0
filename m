From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Sat, 07 Nov 2015 17:58:55 +0000
Message-ID: <bug-107301-13602-8EnFjt2BOt@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbbKGR66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Nov 2015 12:58:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 46652206A5
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2015 17:58:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A93EE2063A
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2015 17:58:55 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #6 from Laurent GUERBY <laurent@guerby.net> ---
Created attachment 192351
  --> https://bugzilla.kernel.org/attachment.cgi?id=192351&action=edit
Remove ext4 mbcache

Would this (untested/mechanical) patch be ok to test mbcache removal?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
