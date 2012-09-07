From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  7 Sep 2012 18:12:05 +0000 (UTC)
Message-ID: <20120907181205.628C411FC3E@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47071 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2IGSMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2012 14:12:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2D576204A8
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:12:07 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 698912048D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:12:05 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2012-09-07 18:12:05 ---
(In reply to comment #0)
> Sandisk support says that its 480GB SSDs have a block size of 8KB instead of
> the usual 4KB. Thus in order to use that SSD we would have to format with a
> block size of 8KB.

Do you have one of these devices?  I'd be a little surprised if it's really not
formattable with 4k blocks.  If you have the device, this might be interesting:

# blockdev --getss --getpbsz --getiomin --getioopt --getbsz /dev/sdX

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
