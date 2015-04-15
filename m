From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] Oops in __d_lookup when accessing certain files
Date: Wed, 15 Apr 2015 13:57:28 +0000
Message-ID: <bug-96641-13602-rmWJpxvHjj@https.bugzilla.kernel.org/>
References: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbbDON5c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2015 09:57:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5ADA420328
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2015 13:57:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6F189202EB
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2015 13:57:28 +0000 (UTC)
In-Reply-To: <bug-96641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

--- Comment #2 from dann frazier <dannf@dannf.org> ---
Thanks Eric. Unfortunately I'm unable to reproduce the problem using an image
created by e2image - I've tried loop back mounting on both x86 and the same
arm64 system (image stored in tmpfs). That said, I'm happy to provide this
e2image to someone interested in looking at it (1.8G).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
