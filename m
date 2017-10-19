From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197315] ext4 filesystem does not use its badblock list fully
Date: Thu, 19 Oct 2017 03:27:01 +0000
Message-ID: <bug-197315-13602-aaZpphoipj@https.bugzilla.kernel.org/>
References: <bug-197315-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54180 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751646AbdJSD1K (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Oct 2017 23:27:10 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BA7E428C60
        for <linux-ext4@vger.kernel.org>; Thu, 19 Oct 2017 03:27:09 +0000 (UTC)
In-Reply-To: <bug-197315-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197315

--- Comment #3 from dima (mihailov-d-v@mail.ru) ---
Created attachment 260283
  --> https://bugzilla.kernel.org/attachment.cgi?id=260283&action=edit
related dmesg outputs

This output was received before the name of the disk was automatically changed
after reboot

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
