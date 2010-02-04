From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15230] New: oops on ext4 remount with -o barrier
Date: Thu, 4 Feb 2010 22:32:46 GMT
Message-ID: <bug-15230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45295 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab0BDWcr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 17:32:47 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14MWk6K013301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 22:32:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15230

               URL: http://lxr.linux.no/linux+v2.6.31/fs/ext4/super.c#L146
                    8
           Summary: oops on ext4 remount with -o barrier
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31.12
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: stephane_kernel@lesimple.fr
        Regression: No


I was going to post this on the Fedora bugzilla, but it is also reproductible
on Ubuntu. So, here it is:

When remounting an ext4 filesystem with -o barrier, the kernel oopses.
After a quick look at the kernel source code (
http://lxr.linux.no/linux+v2.6.31/fs/ext4/super.c#L1468 ), the oops seems to
happen when trying to parse the mount options, presumably because I specify
"barrier" and not "barrier=1" or "barrier=0".

On line 1469, if I'm not mistaken, a possible patch would be :
-if (match_int(&args[0], &option)) {
+if (!args[0] || match_int(&args[0], &option)) {

... absolutely untested. :)

Fedora: kernel-PAE-2.6.31.12-174.2.3.fc12.i686
Ubuntu: linux-image-2.6.31-14-generic

Steps to Reproduce:
1. dd if=/dev/zero of=/dev/shm/test bs=1M count=32
2. losetup /dev/loop5 /dev/shm/test
3. mkfs.ext4 /dev/loop5
4. mkdir /mnt/test
5. mount /dev/loop5 /mnt/test -o nobarrier # ok
7. mount /mnt/test -o remount,barrier # kernel oops

Actual results (on Fedora):
BUG: unable to handle kernel NULL pointer dereference at 00000001
IP: [<c05a5f47>] match_number+0x3c/0x8b
*pdpt = 0000000007755001 *pde = 00000000419bf067 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
Modules linked in: nls_utf8 fuse xt_multiport xt_comment iptable_security
iptable_mangle iptable_nat nf_nat iptable_raw cpufreq_stats cpufreq_powersave
cpufreq_conservative vboxnetadp vboxnetflt vboxdrv coretemp cpufreq_ondemand
acpi_cpufreq xt_physdev ip6t_REJECT ip6t_ipv6header nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 vfat fat ext2 dm_multipath kvm_intel kvm uinput
nvidia(P) snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_seq snd_seq_device mmc_block arc4 ecb snd_pcm
snd_timer snd iwl3945 sdhci_pci soundcore sdhci firewire_ohci iwlcore
snd_page_alloc mmc_core ricoh_mmc firewire_core iTCO_wdt mac80211 crc_itu_t
iTCO_vendor_support uvcvideo i2c_i801 cfg80211 videodev rfkill v4l1_compat tg3
i2c_core wmi joydev tpm_infineon compal_laptop aes_i586 aes_generic xts
gf128mul dm_crypt video output [last unloaded: scsi_wait_scan]

Pid: 2926, comm: mount Tainted: P           (2.6.31.12-174.2.3.fc12.i686.PAE
#1) N/A                                            
EIP: 0060:[<c05a5f47>] EFLAGS: 00210206 CPU: 0
EIP is at match_number+0x3c/0x8b
EAX: 0000000d EBX: cc83be7c ECX: 00000003 EDX: d14a1aa0
ESI: 00000001 EDI: d14a1aa0 EBP: cc83be58 ESP: cc83be3c
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process mount (pid: 2926, ti=cc83a000 task=c383b300 task.ti=cc83a000)
Stack:
00000000 cc83be94 d14a1aa0 c078fec4 edc0d800 edcd8000 cc83be7c cc83be60
<0> c05a5fbe cc83bea4 c0531e5b 0000000e 00000000 00000000 cb6ce012 00000000
<0> 00000001 0000000e c04a0cfa 00000000 036d8afe 00200246 edcd804c edc0d800
Call Trace:
[<c05a5fbe>] ? match_int+0xa/0xc
[<c0531e5b>] ? parse_options+0x437/0x69e
[<c04a0cfa>] ? generic_writepages+0x1e/0x28
[<c0534bd7>] ? ext4_remount+0xc3/0x38d
[<c049caf4>] ? filemap_write_and_wait+0x27/0x32
[<c0534b14>] ? ext4_remount+0x0/0x38d
[<c04ca408>] ? do_remount_sb+0xae/0xe5
[<c04dbee5>] ? do_mount+0x262/0x6e4
[<c04a0362>] ? __get_free_pages+0x24/0x26
[<c04dc3cd>] ? sys_mount+0x66/0x98
[<c040909c>] ? syscall_call+0x7/0xb
Code: 55 e8 ba d0 00 00 00 89 4d e4 8b 40 04 40 2b 03 e8 de ca f1

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
