From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 18 May 2016 16:02:34 +0000
Message-ID: <bug-118401-13602-y8cHFktNi8@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44330 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbcERQCi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2016 12:02:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CE7AA20376
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2016 16:02:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8A67E2035D
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2016 16:02:34 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
This is not an ext4 issue.

It could be a problem with how the kernel was configured.   It could be a
hardware issue; it could be many things.  But the problem seems to be that the
root device is not getting detected, so this is before the file system gets
involved.

Part of the problem is that hardware support issues are one of the things that
take a quite a lot of time to try to resolve remotely, especially if the user
doesn't know how to get the necessary debugging information, and upstream
developers are all volunteers when it comes to giving support to random end
users.   Normally this is work that gets done by distributions, especially if
they are getting paid support $$$.   But they don't want to support anything
other than their standard kernel.

You can find kernel folks who also have a particular hardware, or something
similar, and they will help on a volunteer basis.  The problem is while many of
us will have Thinkpads (for example), many fewer kernel developers are likely
to have come across an All-in-one Lenovo A740 desktop.

This sort of problem is much better handled by someone who knows how to get the
necessary debugging information (the kernel configuration used to build the
kernel image you are trying to use, and the kernel dmesg messages during the
boot process, etc.).  So if you are near a local Linux User's Group, that might
be a good place to try to ask for help.

I will say that my Haswell-based Lenovo Thinkpad T540p works just fine with
upstream kernels, so my guess is that it's mostly a kernel configuration issue,
possibly combined with needing to make changes in the BIOS settings.  So
there's a good chance this isn't a kernel bug at all.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
