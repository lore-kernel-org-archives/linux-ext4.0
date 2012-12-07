From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 18:04:22 +0000 (UTC)
Message-ID: <20121207180422.7E64A11FB81@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53936 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423611Ab2LGSE0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 13:04:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6CB0520388
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 18:04:25 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B8E4A2037E
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 18:04:23 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2012-12-07 18:04:22 ---
Well, I was using a 64-bit kernel and a 32-bit mount program, so that
replicates what you are doing, and a "mount -o nodev" will use MS_NODEV.  And
I'm using a stock 3.2.29 kernel.

At this point I don't know what to tell you.  I can't duplicate the problem
here.  If you can give me an easy reproduction that you can run by hand, great.
 Otherwise, I'm going to have to close this out as not reproducible.

The other possibility is this is an Ubuntu bug.  Are you using a stock kernel,
or is this a kernel with Ubuntu's "value added patches"?   If this is not a
stock kernel, I'd advise that you submit this bug to Ubuntu.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
