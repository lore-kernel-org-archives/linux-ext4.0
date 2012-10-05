From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48431] [PATCH]ext4_fill_super() reports success even if
 ext4_mb_init() fails
Date: Fri,  5 Oct 2012 14:16:00 +0000 (UTC)
Message-ID: <20121005141600.1602511FC43@bugzilla.kernel.org>
References: <bug-48431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2JEOQL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 10:16:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D18F204F3
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 14:16:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6B796204EE
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 14:16:01 +0000 (UTC)
In-Reply-To: <bug-48431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48431


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
            Summary|ext4_fill_super() reports   |[PATCH]ext4_fill_super()
                   |success even if             |reports success even if
                   |ext4_mb_init() fails        |ext4_mb_init() fails




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-10-05 14:15:59 ---
Patches should be sent with a Signed-off-by: line to the relevant list (See
Documentation/SubmittingPatches)

In this case linux-ext4@vger.kernel.org

You don't need to be subscribed to submit to it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
