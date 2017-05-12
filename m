From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195729] JBD2: Spotted dirty metadata buffer (dev = sda1,
 blocknr = 1766784).There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 12 May 2017 14:54:17 +0000
Message-ID: <bug-195729-13602-XhKOe0NuqL@https.bugzilla.kernel.org/>
References: <bug-195729-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43478 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932315AbdELOyS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 10:54:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1A19F28833
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 14:54:18 +0000 (UTC)
In-Reply-To: <bug-195729-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195729

--- Comment #3 from jqiaoulk@gmail.com ---
This is the root cause, which is pretty straightforward:

The spin lock is firstly acquired at the following function:

OutputResults CSTmMasterOutput::Start(const stm_display_mode_t* pModeLine) {
vibe_os_lock_resource(m_lock);

if(!this->SetOutputFormat(m_ulOutputFormat)) {
TRC;
goto stop_and_exit;
}

vibe_os_unlock_resource(m_lock);
}

and this->SetOutputFormat will eventually call vibe_os_clk_set_parent() as
below:

bool CSTmClockLLA::Enable {
vibe_os_clk_set_parent(output, source);
}

Based on the callstack, we know vibe_os_clk_set_parent will call
clk_set_parent().
clk_set_parent() is a basic kernel API that would potentially go to sleep,
based on the call stack in the log.

Therefore, CSTmMasterOutput::Start would potentially go to sleeps while holding
spin_Lock().

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
