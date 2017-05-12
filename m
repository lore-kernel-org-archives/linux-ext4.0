From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195729] JBD2: Spotted dirty metadata buffer (dev = sda1,
 blocknr = 1766784).There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 12 May 2017 14:53:51 +0000
Message-ID: <bug-195729-13602-zHVWZWx6Wd@https.bugzilla.kernel.org/>
References: <bug-195729-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43422 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932315AbdELOxw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 10:53:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 44A0328833
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 14:53:52 +0000 (UTC)
In-Reply-To: <bug-195729-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195729

--- Comment #2 from jqiaoulk@gmail.com ---
So briefly speaking, one following call must incorrect call spin_lock or other
functions that disable the preemption in this failure case:

For example:

Failure case:

stm_display_output_start()
spin_lock()
_ZN16CSTmMasterOutput5StartEPK18stm_display_mode_s  -------> We can't sleep
here since it is in the critical section !!!
spin_unlock()
Call Sequence:

(1) vibe_os_clk_set_parent

(2)
_ZN12CSTmClockLLA6EnableE29stm_clk_divider_output_name_t31stm_clk_divider_output_source_t31stm_clk_divider_output_divide_t

(3) _ZN16CSTmMainTVOutput15SetOutputFormatEj

(4) _ZN16CSTmMasterOutput5StartEPK18stm_display_mode_s

(5) stm_display_output_start()

(6) dil_blender_output_start

(7) cdi_hdmi_exit

(8) dil_hdmi_set_video_code

(9) hdmi_release

(10) hdmi_ioctl()

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
