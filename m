From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Wed, 19 Aug 2015 16:13:38 +0000
Message-ID: <bug-103111-13602-YqaTeZcFnx@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbbHSQNk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2015 12:13:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CE265207BB
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2015 16:13:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6B368207B7
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2015 16:13:38 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
2.6.39 is 4 years old at this point.  Have you tested upstream?

> Actual results: File is having zero-length after abnormal reboot(power outage).

How long after your sample code runs do you cut the power?

Which "file?"  Do you see "example.txt" or "example.txt1" post-reboot?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
