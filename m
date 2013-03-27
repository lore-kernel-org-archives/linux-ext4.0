From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55821] New: kernel oops when unmounting ext3 fs
Date: Wed, 27 Mar 2013 11:38:15 +0000 (UTC)
Message-ID: <bug-55821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3C0LiV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 07:38:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7321720349
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 11:38:19 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C4C2C20345
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 11:38:15 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55821

           Summary: kernel oops when unmounting ext3 fs
           Product: File System
           Version: 2.5
    Kernel Version: 3.8.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com
        Regression: No


Hi,

i am doing some filesystems testing (aka fuzzing), got this issue on vanilla
3.8.4:

Mar 27 12:23:47 linux kernel: [  373.018889] WARNING: at fs/jbd/journal.c:470
__log_start_commit+0x94/0xb0()
Mar 27 12:23:47 linux kernel: [  373.018891] Hardware name: PowerEdge T420
Mar 27 12:23:47 linux kernel: [  373.018894] jbd: bad log_start_commit:
2801795176 2801795176 0 0
Mar 27 12:23:47 linux kernel: [  373.018895] Modules linked in: ipmi_devintf
ipmi_si ipmi_msghandler nls_iso8859_1 coretemp kvm_intel kvm
ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 sb_edac xts
edac_core gf128mul lp joydev mei gpio_ich microcode dcdbas lpc_ich parport
shpchp acpi_power_meter wmi mac_hid raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov hid_generic ahci libahci usbhid tg3 ptp hid
raid6_pq pps_core async_tx raid1 raid0 multipath linear
Mar 27 12:23:47 linux kernel: [  373.018935] Pid: 1924, comm: umount Tainted: G
       W    3.8.4 #1
Mar 27 12:23:47 linux kernel: [  373.018937] Call Trace:
Mar 27 12:23:47 linux kernel: [  373.018943]  [<ffffffff810589ef>]
warn_slowpath_common+0x7f/0xc0
Mar 27 12:23:47 linux kernel: [  373.018947]  [<ffffffff81058ae6>]
warn_slowpath_fmt+0x46/0x50
Mar 27 12:23:47 linux kernel: [  373.018950]  [<ffffffff8127c044>]
__log_start_commit+0x94/0xb0
Mar 27 12:23:47 linux kernel: [  373.018955]  [<ffffffff816b5a0e>] ?
_raw_spin_lock+0xe/0x20
Mar 27 12:23:47 linux kernel: [  373.018959]  [<ffffffff8127c496>]
log_start_commit+0x36/0x60
Mar 27 12:23:47 linux kernel: [  373.018964]  [<ffffffff8120e53f>]
ext3_evict_inode+0x26f/0x2c0
Mar 27 12:23:47 linux kernel: [  373.018968]  [<ffffffff811a5e36>]
evict+0xb6/0x1b0
Mar 27 12:23:47 linux kernel: [  373.018971]  [<ffffffff811a6649>]
iput+0x109/0x190
Mar 27 12:23:47 linux kernel: [  373.018975]  [<ffffffff8127bef7>]
journal_destroy+0x1a7/0x220
Mar 27 12:23:47 linux kernel: [  373.018978]  [<ffffffff8107e080>] ?
finish_wait+0x80/0x80
Mar 27 12:23:47 linux kernel: [  373.018983]  [<ffffffff8121c317>]
ext3_put_super+0x47/0x2a0
Mar 27 12:23:47 linux kernel: [  373.018988]  [<ffffffff8118dd91>]
generic_shutdown_super+0x61/0xf0
Mar 27 12:23:47 linux kernel: [  373.018992]  [<ffffffff8118de50>]
kill_block_super+0x30/0x80
Mar 27 12:23:47 linux kernel: [  373.018995]  [<ffffffff8118e247>]
deactivate_locked_super+0x57/0x80
Mar 27 12:23:47 linux kernel: [  373.018999]  [<ffffffff8118ee0e>]
deactivate_super+0x4e/0x70
Mar 27 12:23:47 linux kernel: [  373.019003]  [<ffffffff811aa881>]
mntput_no_expire+0x101/0x160
Mar 27 12:23:47 linux kernel: [  373.019007]  [<ffffffff811ab7dc>]
sys_umount+0x9c/0x3c0
Mar 27 12:23:47 linux kernel: [  373.019012]  [<ffffffff8106ed92>] ?
__set_current_blocked+0x52/0x70
Mar 27 12:23:47 linux kernel: [  373.019017]  [<ffffffff816be399>]
system_call_fastpath+0x16/0x1b
Mar 27 12:23:47 linux kernel: [  373.019019] ---[ end trace 7a9e3bafae5e7653
]---


how to reproduce:

*you need* to be root then issue the cmds below

mkdir /media/test
gunzip ext3.poc.img.gz
mount -t ext3 -o loop ext3.poc.img /media/test/
unmount /media/test

the unmount would never return, check the logs to see the backtrace.


best regards,

David Maciejak
Fortinet's FortiGuard Labs

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
