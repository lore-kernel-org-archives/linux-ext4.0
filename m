From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118511] Corruption of VM qcow2 image file on EXT4 with crypto
 enabled
Date: Tue, 24 May 2016 14:50:49 +0000
Message-ID: <bug-118511-13602-PIWBKwFAHC@https.bugzilla.kernel.org/>
References: <bug-118511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbcEXOux (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 10:50:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BF829203AC
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 14:50:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DD2B820351
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 14:50:49 +0000 (UTC)
In-Reply-To: <bug-118511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118511

Navin <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #1 from Navin <navinp1912@gmail.com> ---
Can you check the memory state of Host/Hypervisor if is full around the range
[596476,596478.]  so that 596477.535490 when ext4_bio_write_page is not able to
get memory ? 

If your hypervisor is using encryption then this patch may help (already
present in 4.6 mainline)

https://patchwork.ozlabs.org/patch/602204/

If that doesn't work then ,You need to your system stats logged and check and
check when ENOMEM is returned. It could genuinely out of memory or there could
be something wrong with code.

Hypervisor/Host cannot write/commit/allocate buffers because it is out of
memory. 

Hence your guest is in a transient state where the change are not committed and
most probably journal is aborted.


[[Hypervisor]]
[596477.535490] ext4_bio_write_page: ret = -12

http://lxr.free-electrons.com/source/include/uapi/asm-generic/errno-base.h#L15

 15 #define ENOMEM          12      /* Out of memory */

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
