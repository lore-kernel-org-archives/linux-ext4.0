From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Fri, 28 Jan 2011 17:15:02 GMT
Message-ID: <201101281715.p0SHF2uK028041@demeter2.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60424 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1RPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jan 2011 12:15:04 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0SHF2Wf028042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Jan 2011 17:15:02 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652





--- Comment #3 from Tao Ma <tm@tao.ma>  2011-01-28 09:51:52 ---
Just tested with 37+the 2 patches. Still the same error.
So it isn't a 38 problem really.


BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff8233dabb>] _raw_spin_lock_irqsave+0x11/0x22
PGD 122b58067 PUD 122594067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/virtual/misc/autofs/dev
CPU 1 
Modules linked in: ext4(-) jbd2 ipv6 autofs4 hidp rfcomm l2cap crc16 bluetooth
rfkill ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue
configfs cpufreq_ondemand acpi_cpufreq dm_mirror video output sbs sbshc battery
acpi_memhotplug ac lp sg snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss option usb_wwan snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss usbserial snd_mixer_oss snd_pcm snd_timer rtc_cmos
snd rtc_core tpm_tis tpm i2c_i801 shpchp parport_pc parport serio_raw button
soundcore rtc_lib tpm_bios pcspkr dcdbas e1000e i2c_core snd_page_alloc
dm_region_hash dm_log dm_mod usb_storage ahci libahci libata sd_mod scsi_mod
ext3 jbd uhci_hcd ohci_hcd ehci_hcd

Pid: 4717, comm: rmmod Not tainted 2.6.37+ #2 0V4W66/OptiPlex 780               
RIP: 0010:[<ffffffff8233dabb>]  [<ffffffff8233dabb>]
_raw_spin_lock_irqsave+0x11/0x22
RSP: 0018:ffff88011f7ade48  EFLAGS: 00010046
RAX: 0000000000000246 RBX: ffff88011f7ade98 RCX: 00000000c0000100
RDX: 0000000000000100 RSI: ffff88011f7ade98 RDI: 0000000000000020
RBP: ffff88011f7ade48 R08: ffff88011f7ac000 R09: ffff8800cfa0da70
R10: ffff8800cfa51a00 R11: ffff88011f7add48 R12: 0000000000000020
R13: 0000000000000002 R14: 00007fff3d3ad400 R15: 0000000000000880
FS:  00007fe07ff0e6e0(0000) GS:ffff8800cfa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 000000011ee14000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 4717, threadinfo ffff88011f7ac000, task ffff88012358f8d0)
Stack:
 ffff88011f7ade88 ffffffff82056d4e ffffffff8206a6e4 ffff88011f7ade98
 ffff88011f7ade98 ffffffffa0441500 0000000000000880 00007fff3d3ad400
 ffff88011f7aded8 ffffffffa0433428 0000000000000000 ffff88012358f8d0
Call Trace:
 [<ffffffff82056d4e>] prepare_to_wait+0x25/0x7b
 [<ffffffff8206a6e4>] ? __try_stop_module+0x0/0x3d
 [<ffffffffa0433428>] ext4_exit_fs+0x94/0x112 [ext4]
 [<ffffffff82056b4b>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff82069127>] sys_delete_module+0x1b5/0x218
 [<ffffffff820c26f9>] ? do_munmap+0x2e2/0x318
 [<ffffffff820767db>] ? audit_syscall_entry+0x1d6/0x209
 [<ffffffff82002aeb>] system_call_fastpath+0x16/0x1b
Code: 1f 44 00 00 b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6
c9 c3 55 48 89 e5 0f 1f 44 00 00 9c 58 fa ba 00 01 00 00 <f0> 66 0f c1 17 38 f2
74 06 f3 90 8a 17 eb f6 c9 c3 55 48 89 e5 
RIP  [<ffffffff8233dabb>] _raw_spin_lock_irqsave+0x11/0x22
 RSP <ffff88011f7ade48>
CR2: 0000000000000020
---[ end trace e0bdca5906fdcbe6 ]---

--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2011-01-28 17:15:01 ---
Is that last oops with or without the patches I pointed at?

That might be in here:

static void ext4_destroy_lazyinit_thread(void)
{
        /*
         * If thread exited earlier
         * there's nothing to be done.
         */
        if (!ext4_li_info)
                return;

        ext4_clear_request_list();

        while (ext4_li_info->li_task) {
                wake_up(&ext4_li_info->li_wait_daemon);
                wait_event(ext4_li_info->li_wait_task,
                           ext4_li_info->li_task == NULL);
        }
}

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000020

li_wait_task is 0x20 into the ext4_lazy_init struct... did ext4_li_info go
away?
It does get freed and set to NULL when the lazyinit thread exits.  I'm guessing
we need a little judicial application of ext4_li_mtx in the teardown thread.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
