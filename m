From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Sat, 05 Jul 2014 08:28:32 +0000
Message-ID: <bug-42723-13602-GtZ9nXoZ9p@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54629 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbaGEI2g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 04:28:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B05E020429
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 08:28:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2465A2041B
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 08:28:33 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

mai ling <mai.ling.lists.35@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mai.ling.lists.35@gmail.com

--- Comment #17 from mai ling <mai.ling.lists.35@gmail.com> ---
I am seeing this on all these debian kernel versions:
ii  linux-image-3.14-0.bpo.1-686-pae          3.14.7-1~bpo70+1                 
 i386         Linux 3.14 for modern PCs
ii  linux-image-3.15-trunk-686-pae            3.15.3-1~exp1                    
 i386         Linux 3.15 for modern PCs
ii  linux-image-3.2.0-4-686-pae               3.2.57-3+deb7u2                  
 i386         Linux 3.2 for modern PCs
Debian kernel reporting howto instructs me to report this upstream here when
the issue is reproductible with latest upstream version.

[  308.192011] EXT4-fs (md124): error count: 1
[  308.192063] EXT4-fs (md124): initial error at 1404174299:
ext4_mb_generate_buddy:739
[  308.192143] EXT4-fs (md124): last error at 1404174299:
ext4_mb_generate_buddy:739

Is this the same bug or should I file a new issue in bugzilla?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
