From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75881] lazyinit failure on new mdadm raid5 & encrypted array
Date: Sun, 11 May 2014 19:05:54 +0000
Message-ID: <bug-75881-13602-IjaLGhcsR3@https.bugzilla.kernel.org/>
References: <bug-75881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbaEKTF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 15:05:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 064B22020F
	for <linux-ext4@vger.kernel.org>; Sun, 11 May 2014 19:05:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 96C02201F2
	for <linux-ext4@vger.kernel.org>; Sun, 11 May 2014 19:05:54 +0000 (UTC)
In-Reply-To: <bug-75881-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75881

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Is this something you can reliably reproduce?  The log doesn't tell us anything
useful, and it's not clear whether the problem is with the dm-crypt (i.e.,
LUKS) layer, or with the ext4 layer.   All the log tells us is that we are
waiting forever for a block I/O operation to finish in the jbd2 commit thread,
and this is causing the lazyinit thread to give a soft lockup warning (meaning
that two minutes has gone by without any forward progress taking place).

I suspect the problem is in an interaction between the dm-crypt and md raid5
code, which is being tickled by the I/O patterns that you've described.  But
before we kick this over to the the device mapper developers, the first
question is whether you can reliably reproduce the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
