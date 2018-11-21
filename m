Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39782 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbeKVECL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 23:02:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 774452C1E8
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 17:26:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 17:26:54 +0000
Message-ID: <bug-201685-13602-htU59uF5dr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Claude Heiland-Allen (claude@mathr.co.uk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #279431|0                           |1
        is obsolete|                            |

--- Comment #12 from Claude Heiland-Allen (claude@mathr.co.uk) ---
Created attachment 279569
  --> https://bugzilla.kernel.org/attachment.cgi?id=279569&action=edit
eiskaffee - logs and other info

I replaced my single dmesg attached with further information (as requested) in
a tarball.  Contains kernel configs, dmesg logs, tune2fs -l, lspci -vvv.  I
don't use LVM or MD on my machine (eiskaffee).  The file system corruption I
experienced was on the root partition on SSD.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
