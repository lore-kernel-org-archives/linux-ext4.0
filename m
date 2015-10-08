From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Thu, 08 Oct 2015 09:16:56 +0000
Message-ID: <bug-102731-13602-eeX4cw92nw@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbbJHJRC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Oct 2015 05:17:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81A6C2064F
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2015 09:17:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 63C6C207BD
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2015 09:16:57 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #16 from John Hughes <john@calva.com> ---
Minor detail:

The ext4 decided the filesystem was corrupt on 7/10, but on 4/10 I'd run an
online check on it and it was OK.  (took a LVM snapshot, fsck'd that).

Oct  4 02:44:27 olympic online-check: .IN: Online fileystem check
/dev/olympic/olympic-home
Oct  4 02:52:00 olympic online-check: .NO: Volume /dev/olympic/olympic-home
checked OK
Oct  4 02:52:01 olympic online-check: .IN: Snapshot
/dev/olympic/olympic-home-snap used 0.10%

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
