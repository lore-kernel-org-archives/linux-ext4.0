From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Thu, 17 Mar 2016 07:38:19 +0000
Message-ID: <bug-114821-13602-bvfWwfaqqt@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47240 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbcCQHiX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2016 03:38:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 93DEF20304
	for <linux-ext4@vger.kernel.org>; Thu, 17 Mar 2016 07:38:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8986E202EC
	for <linux-ext4@vger.kernel.org>; Thu, 17 Mar 2016 07:38:19 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #1 from Christian Kujau <lists@nerdbynature.de> ---
"the hard drive produces a distinct clunk every few seconds" sounds like
hardware problems. Other file systems have different access patterns and it may
not be vis^W audible with e.g. NTFS, but I wouldn't trust a hard disk that
makes "clunk" noises. That being said, there are crucial parts missing from
this report: syslog errors during the access problems (a full dmesg may be
helpful too); does it happen with a current vanilla kernel? Also: has this been
reported to the linux-ext4 mailing list prior opening this bug?

Also, this error seems to be rather common with Raspberry environments, see:

https://www.linuxquestions.org/questions/slackware-arm-108/raspberry-pi2-keeps-crashing-and-corrupting-disk-4175541613/
 (May 2015)

https://github.com/atom/atom/issues/8381 (Aug 2015)

https://unix.stackexchange.com/questions/269609/recurring-ext4-bad-header-invalid-magic-errors-on-a-healty-drive
(from 3 days ago, is that you?)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
