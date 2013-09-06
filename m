From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Fri, 06 Sep 2013 07:35:59 +0000
Message-ID: <bug-40822-13602-hBdbfdoCtV@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab3IFHgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Sep 2013 03:36:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 629AC201CB
	for <linux-ext4@vger.kernel.org>; Fri,  6 Sep 2013 07:36:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F06F620201
	for <linux-ext4@vger.kernel.org>; Fri,  6 Sep 2013 07:35:59 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

Catalin(ux) M. BOIE <fedora@embedromix.ro> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fedora@embedromix.ro

--- Comment #3 from Catalin(ux) M. BOIE <fedora@embedromix.ro> ---
I am getting the same error.

I was running a Fedora 19 guest inside a Fedora 19 host.
At some moment, I had 0 free space on the partition were qcow2 guest image was.
qemu paused the machine I did press resume several times.
I made space and some time after I got this error.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
