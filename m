From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195729] JBD2: Spotted dirty metadata buffer (dev = sda1,
 blocknr = 1766784).There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 12 May 2017 14:53:17 +0000
Message-ID: <bug-195729-13602-WUxri8Xkcp@https.bugzilla.kernel.org/>
References: <bug-195729-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43390 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932315AbdELOxT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 10:53:19 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8B6CD28833
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 14:53:18 +0000 (UTC)
In-Reply-To: <bug-195729-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195729

--- Comment #1 from jqiaoulk@gmail.com ---
It tells us that clk_set_parent() will potentially goes to sleep under some
circumstances(in this case, to acquire the mutex lock).

Therefore,with regard to the Driver caller routine shown below, it must
incorrect runs in critical section, which possible call spin_lock() or other
related functions which disable the preemption. Since it is not in the IRQ
context, it is very likely spink lock is called in this failure case. Looking
into the Driver code, should give the clue.

[Fri May 05 05:26:09.992 2017] [40636.613352] [<7eea79ec>]
(vibe_os_clk_set_parent+0x34/0xb0 [vibe_os]) from [<7eec3cd0>]
(_ZN12CSTmClockLLA6EnableE29stm_clk_divider_output_name_t31stm_clk_divider_output_source_t31stm_clk_divider_output_divide_t+0xd4/0xf0
[stmcore_display_stiH407])
[Fri May 05 05:26:10.017 2017] [40636.635408] [<7eec3cd0>]
(_ZN12CSTmClockLLA6EnableE29stm_clk_divider_output_name_t31stm_clk_divider_output_source_t31stm_clk_divider_output_divide_t+0xd4/0xf0
[stmcore_display_stiH407]) from [<7eec8c2c>]
(_ZN16CSTmMainTVOutput15SetOutputFormatEj+0xc8/0x1b0 [stmcore_display_stiH407])
[Fri May 05 05:26:10.036 2017] [40636.660506] [<7eec8c2c>]
(_ZN16CSTmMainTVOutput15SetOutputFormatEj+0xc8/0x1b0 [stmcore_display_stiH407])
from [<7eebbd40>]
(_ZN16CSTmMasterOutput5StartEPK18stm_display_mode_s+0x1b8/0x1f8
[stmcore_display_stiH407])
[Fri May 05 05:26:10.069 2017] [40636.679522] [<7eebbd40>]
(_ZN16CSTmMasterOutput5StartEPK18stm_display_mode_s+0x1b8/0x1f8
[stmcore_display_stiH407]) from [<7eeba0ac>]
(stm_display_output_start+0x6c/0xb4 [stmcore_display_stiH407])
[Fri May 05 05:26:10.069 2017] [40636.697123] [<7eeba0ac>]
(stm_display_output_start+0x6c/0xb4 [stmcore_display_stiH407]) from
[<7f444650>] (dil_blender_output_start+0x8c/0x17c [stm_cdi_dvb])
[Fri May 05 05:26:10.079 2017] [40636.711321] [<7f444650>]
(dil_blender_output_start+0x8c/0x17c [stm_cdi_dvb]) from [<7f45717c>]
(cdi_hdmi_exit+0xb64/0xbc4 [stm_cdi_dvb])
[Fri May 05 05:26:10.092 2017] [40636.723660] [<7f45717c>]
(cdi_hdmi_exit+0xb64/0xbc4 [stm_cdi_dvb]) from [<7f4578a4>]
(dil_hdmi_set_video_code+0x4c/0x1d4 [stm_cdi_dvb])
[Fri May 05 05:26:10.104 2017] [40636.735912] [<7f4578a4>]
(dil_hdmi_set_video_code+0x4c/0x1d4 [stm_cdi_dvb]) from [<7f44ed74>]
(hdmi_release+0x316c/0x781c [stm_cdi_dvb])
[Fri May 05 05:26:10.151 2017] [40636.748251] [<7f44ed74>]
(hdmi_release+0x316c/0x781c [stm_cdi_dvb]) from [<7f4539a0>]
(hdmi_ioctl+0x57c/0x2d40 [stm_cdi_dvb])
[Fri May 05 05:26:10.152 2017] [40636.759631] [<7f4539a0>]
(hdmi_ioctl+0x57c/0x2d40 [stm_cdi_dvb]) from [<800fd4dc>] (vfs_ioctl+0x28/0x3c)
[Fri May 05 05:26:10.152 2017] [40636.769137] [<800fd4dc>]
(vfs_ioctl+0x28/0x3c) from [<800fdf48>] (do_vfs_ioctl+0x4b0/0x560)
[Fri May 05 05:26:10.152 2017] [40636.777484] [<800fdf48>]
(do_vfs_ioctl+0x4b0/0x560) from [<800fe02c>] (SyS_ioctl+0x34/0x60)
[Fri May 05 05:26:10.152 2017] [40636.785836] [<800fe02c>]
(SyS_ioctl+0x34/0x60) from [<8000dbc0>] (ret_fast_syscall+0x0/0x30)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
