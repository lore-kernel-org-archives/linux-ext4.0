Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50426 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbeLBTUe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 14:20:34 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 46F602A6DE
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 19:20:33 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 19:20:32 +0000
Message-ID: <bug-201685-13602-ISmYnaiNUx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #160 from Guenter Roeck (linux@roeck-us.net) ---

Another update: I hit the problem almost immediately with the reverts from
#156.

[ 1826.738686] EXT4-fs error (device sda1): ext4_iget:4796: inode #7633436:
comm borg: bad extra_isize 28534 (inode size 256)
[ 1826.740744] Aborting journal on device sda1-8.
[ 1826.747339] EXT4-fs (sda1): Remounting filesystem read-only

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
