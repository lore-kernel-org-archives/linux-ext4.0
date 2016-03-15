From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Tue, 15 Mar 2016 13:07:54 +0000
Message-ID: <bug-113041-13602-ucC1PugJpx@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965165AbcCONIA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 09:08:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 956DC201BC
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 13:07:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D0F1F20272
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 13:07:54 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

--- Comment #2 from Johnny <johnny+bugzilla@appdata.biz> ---
Unfortunately not, as I don't know how to reproduce the issue and it happened
in a production environment where we rely on the version that the CoreOS
distribution provides.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
