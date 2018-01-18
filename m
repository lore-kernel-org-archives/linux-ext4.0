From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Thu, 18 Jan 2018 06:24:51 +0000
Message-ID: <bug-198187-13602-2ZYJ1WrLdq@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53320 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752062AbeARGYx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Jan 2018 01:24:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A04F421BED
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2018 06:24:52 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

Alexander A. (dralex2004@yandex.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dralex2004@yandex.ru

--- Comment #7 from Alexander A. (dralex2004@yandex.ru) ---
Created attachment 273661
  --> https://bugzilla.kernel.org/attachment.cgi?id=273661&action=edit
dmesg dump

This output was taken from dmesg after sending a command echo w
>/proc/sysrq-trigger

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
