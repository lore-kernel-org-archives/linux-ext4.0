From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Sun, 20 Mar 2016 01:27:58 +0000
Message-ID: <bug-102731-13602-S3hROy35fQ@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48072 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbcCTB2C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Mar 2016 21:28:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E0B3B2034C
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 01:28:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E01052039C
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 01:27:58 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #41 from Theodore Tso <tytso@mit.edu> ---
I'm not sure we need to leave this bug open at all.  It sounds like it's some
combination of a buggy Intel CPU and a buggy kernel code in the
KVM/virtualization support.   The fix seems to be to update to a newer host
kernel (4.1 or newer).

This is problematic for Debian users, but at this point it's a bug for the
Debian kernel maintainers, and this bugzilla is for the upstream kernel....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
