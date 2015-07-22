From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60788] xfstest generic/068 failure - kernel BUG at
 fs/buffer.c:3005!
Date: Wed, 22 Jul 2015 18:37:26 +0000
Message-ID: <bug-60788-13602-05j9uy3fpC@https.bugzilla.kernel.org/>
References: <bug-60788-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36793 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbbGVShb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2015 14:37:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 206F3206AA
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2015 18:37:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9D61D206D7
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2015 18:37:27 +0000 (UTC)
In-Reply-To: <bug-60788-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60788

Eric Whitney <enwlinux@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #2 from Eric Whitney <enwlinux@gmail.com> ---
This bug is a duplicate of #60786.

A patch included in 4.2-rc1 has resolved this problem: "ext4: fix race between
truncate and __ext4_journalled_writepage()" (bdf96838aea6)

The method used to force the bug to occur in the past was to make repeated runs
of generic/068 on a test filesystem mounted with the data=journal option.  The
test system would typically hang with a few tens of runs at the most.

1000 test runs completed normally both on x86_64 and 32 bit ARM running 4.2-rc1
kernels.  Regular regression runs containing generic/068 have also completed
normally using 4.2-rc2 and -rc3 kernels on the same architectures.

*** This bug has been marked as a duplicate of bug 60786 ***

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
