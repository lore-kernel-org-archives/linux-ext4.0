From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] oops: fs/ext4/ext4_jbd2.c
Date: Tue, 26 Nov 2013 21:30:50 +0000
Message-ID: <bug-65701-13602-OJJd9w1Ilc@https.bugzilla.kernel.org/>
References: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43460 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3KZVax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Nov 2013 16:30:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D1EEC204DF
	for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 21:30:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3F00D204B5
	for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 21:30:51 +0000 (UTC)
In-Reply-To: <bug-65701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|Linux 3.11.9-gentoo #1 SMP  |3.11.9-gentoo
                   |Sun Nov 24 16:53:58 CET     |
                   |2013 x86_64 Intel(R)        |
                   |Xeon(R) CPU X5650 @ 2.67GHz |
                   |GenuineIntel GNU/Linux      |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
