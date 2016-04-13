From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Wed, 13 Apr 2016 20:35:35 +0000
Message-ID: <bug-109331-13602-3X1W9miyDD@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53146 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbcDMUfl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2016 16:35:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 67D482037E
	for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2016 20:35:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 19AF820380
	for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2016 20:35:36 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

Erik Quaeghebeur <kernelbugs@equaeghe.nospammail.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernelbugs@equaeghe.nospamm
                   |                            |ail.net

--- Comment #7 from Erik Quaeghebeur <kernelbugs@equaeghe.nospammail.net> ---
(In reply to KernelBug from comment #6)
>
> I was just wondering why I was now getting this msg I'd never seen before.

FYI: You can get rid of it by informing the kernel about the root fs type, by
adding

  rootfstype=ext4

to the kernel command line.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
