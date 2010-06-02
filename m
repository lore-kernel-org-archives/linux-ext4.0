From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 16:44:10 GMT
Message-ID: <201006021644.o52GiAlL009713@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58197 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab0FBQoL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 12:44:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52GiArs009714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 16:44:10 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #8 from lkolbe@techfak.uni-bielefeld.de  2010-06-02 16:44:04 ---
Created an attachment (id=26619)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26619)
root-filesystem borkage

Hm. After a reset, both 9TB-Filesystems were normal (journal replayed. But a
few minutes after the boot, we got really strange errors (see attachment) and
could only resurrect the root-filesystem with a live-cd and it's fsck, as grub
wouldn't detect a filesystem anymore. fsck fixed it, though (broken superblock
and some minor fixes). The system boots as I write this, and I'll continue the
same backup-tests but this time without barriers on both filesystems.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
