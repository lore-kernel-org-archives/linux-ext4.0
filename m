From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118041] My tricky script involving zram and device mapper hangs
 on "mount"
Date: Tue, 17 May 2016 16:48:43 +0000
Message-ID: <bug-118041-13602-BW2VrKYgyo@https.bugzilla.kernel.org/>
References: <bug-118041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50483 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbcEQQss (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 12:48:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CCFE220165
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 16:48:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5281E202EC
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 16:48:44 +0000 (UTC)
In-Reply-To: <bug-118041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118041

--- Comment #2 from _Vi <vi0oss@gmail.com> ---
cryptie4-ff: 0 3072000 linear 251:0 672802816

Maybe I'll try to make special stand-alone script for demonstrating the
problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
