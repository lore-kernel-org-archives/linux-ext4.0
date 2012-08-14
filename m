From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45941] BUG: soft lockup - CPU#1 stuck for 21s! [kworker/1:1:64]
 BUG: soft lockup - CPU#4 stuck for 22s! [flush-252:0:384]
Date: Tue, 14 Aug 2012 11:43:28 +0000 (UTC)
Message-ID: <20120814114328.9513D11FC6E@bugzilla.kernel.org>
References: <bug-45941-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2HNLnf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 07:43:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A000920236
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 11:43:34 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 989C320233
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 11:43:28 +0000 (UTC)
In-Reply-To: <bug-45941-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45941


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |ext4
     Kernel Version|Linux 3.5.1-030501-generic  |3.5.1
                   |#201208091310 SMP           |
         AssignedTo|other_other@kernel-bugs.osd |fs_ext4@kernel-bugs.osdl.or
                   |l.org                       |g
            Product|Other                       |File System




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-08-14 11:43:28 ---
This looks like an I/O never completed but it may be a pointer to something
else (eg sys_readahead/ext4 interaction). Assigning to the ext4 folk see if
they have any thoughts but thats half guesswork 8)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
