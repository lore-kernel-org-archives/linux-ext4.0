From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] ext2/ext4 filesystem "hangs" for a few seconds when
 trying to write a lot of data to a freshly RW mounted FS
Date: Sat,  4 Aug 2012 12:16:16 +0000 (UTC)
Message-ID: <20120804121616.9815D11FC24@bugzilla.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40760 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2HDMQY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 08:16:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7001A200B4
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 12:16:23 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A225E201BC
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 12:16:21 +0000 (UTC)
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380





--- Comment #11 from Prashant Shah <pshah.mumbai@gmail.com>  2012-08-04 12:16:16 ---
(In reply to comment #10)
> Didnt face this issue with 3.2.0-23-generic - 64 bit.

Sorry I was able to reproduce it under 3.2.0-23-generic - 64 bit

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
