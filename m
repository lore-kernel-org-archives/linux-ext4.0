From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195757] WARNING: CPU: 0 PID: 761 at
 /home/kernel/COD/linux/fs/super.c:1281 super_setup_bdi_name+0xcf/0xe0
Date: Sun, 14 May 2017 18:10:19 +0000
Message-ID: <bug-195757-13602-VtLzQJ0U4F@https.bugzilla.kernel.org/>
References: <bug-195757-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49176 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753458AbdENSKV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 May 2017 14:10:21 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A867828961
        for <linux-ext4@vger.kernel.org>; Sun, 14 May 2017 18:10:20 +0000 (UTC)
In-Reply-To: <bug-195757-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195757

Cristian Aravena Romero (caravena@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |Other

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
