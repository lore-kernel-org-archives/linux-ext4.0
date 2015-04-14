From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] Oops in __d_lookup when accessing certain files
Date: Tue, 14 Apr 2015 19:09:47 +0000
Message-ID: <bug-96641-13602-Q1t1gKfZXz@https.bugzilla.kernel.org/>
References: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbbDNTJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Apr 2015 15:09:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 09D73201F4
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2015 19:09:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C2D1420212
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2015 19:09:47 +0000 (UTC)
In-Reply-To: <bug-96641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
Getting an e2image (with -r or -q) would be a way to preserve the filesystem
state for analysis, then you could run fsck on it...

-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
