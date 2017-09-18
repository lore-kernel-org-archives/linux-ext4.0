From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Mon, 18 Sep 2017 20:59:11 +0000
Message-ID: <bug-89511-13602-lDORXjdt0Q@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58070 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750714AbdIRVAC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Sep 2017 17:00:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C9B1428CDA
        for <linux-ext4@vger.kernel.org>; Mon, 18 Sep 2017 21:00:01 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #73 from Alan Stern (stern@rowland.harvard.edu) ---
I don't know.  The email thread at
<https://marc.info/?t=143498500900006&r=1&w=2> just died out, with no
resolution.  As far as I know, nothing has been done to fix this.

I can take care of the usb-storage driver, but the underlying issues affect the
SCSI and filesystem layers, which means other maintainers will have to be
involved.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
