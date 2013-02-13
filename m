From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53741] Used block count in df output
Date: Wed, 13 Feb 2013 05:21:01 +0000 (UTC)
Message-ID: <20130213052101.5F5F011FF3E@bugzilla.kernel.org>
References: <bug-53741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57793 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab3BMFVE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 00:21:04 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2581E2028C
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 05:21:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 68CA020275
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2013 05:21:01 +0000 (UTC)
In-Reply-To: <bug-53741-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53741


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2013-02-13 05:21:01 ---
Specifically, I think this is a problem with the overhead calculations done in
the default "bsddf" freespace reporting, which tries to not count the
fundamental filesystem metadata blocks as "used".  With mount -o minixdf, which
is the straightforward "report all blocks used as used" mode, the df output
makes sense.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
