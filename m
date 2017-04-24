From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error (device sda1):
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 03:00:42 +0000
Message-ID: <bug-195561-13602-YVxYVgYouC@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51370 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1164358AbdDXDAr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 23:00:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 64D8323E64
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 03:00:46 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #5 from Mauro Rossi (issor.oruam@gmail.com) ---
Created attachment 255971
  --> https://bugzilla.kernel.org/attachment.cgi?id=255971&action=edit
Lustre HACK that avoids the ext4_error() and signals an ext4_warning() and
unproperly silences the errors

NOTE: Lustre hack was backported to kernel 4.4 for testing purposes
and it's not recommended as a correcton

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
