From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15349] New: kernel BUG at fs/ext4/inode.c:1853!
Date: Thu, 18 Feb 2010 20:53:32 GMT
Message-ID: <bug-15349-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58016 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0BRUxd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2010 15:53:33 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1IKrW5j015969
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 18 Feb 2010 20:53:32 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15349

           Summary: kernel BUG at fs/ext4/inode.c:1853!
           Product: File System
           Version: 2.5
    Kernel Version: Linux muser 2.6.31.12-desktop-1mnb #1 SMP Tue Jan 26
                    03:35:36 EST 2010 i686 Pentium(R) Dual-Core  CPU
                    E6500  @ 2.93GHz GNU/Linux
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bas@bmail.ru
        Regression: No


Hello!

Here is a bug report. The hard drive subsystem was heavily used by IO
operations (torrent), at the same time I was unraring an archive.

After this problem happened, load average started increasing dramatically, and
the system became unresponsive. Processes couldn't be killed, system couldn't
even be rebooted. So i had to reset it manually.

Feb 18 22:30:33 muser klogd: ------------[ cut here ]------------
Feb 18 22:30:33 muser klogd: kernel BUG at fs/ext4/inode.c:1853!
Feb 18 22:30:33 muser klogd: invalid opcode: 0000 [#1] SMP
Feb 18 22:30:33 muser klogd: last sysfs file:
/sys/devices/platform/it87.656/temp2_alarm
Feb 18 22:30:33 muser klogd: Modules linked in: sch_tbf cls_u32 sch_ingress
ppp_deflate zlib_deflate bsd_comp sha1_generic arc4 ecb ppp_mppe xt_owner
ipt_REDIR
ECT xt_DSCP ppp_async crc_ccitt ppp_generic slhc xt_HL xt_TCPMSS ipt_MASQUERADE
ipt_REJECT xt_state xt_multiport xt_tcpudp iptable_mangle iptable_nat iptable
_filter ip_tables x_tables nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 af_packet it87
hwmon_
vid coretemp ipv6 binfmt_misc quota_v1 loop dm_mirror dm_region_hash dm_log
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table
kvm_int
el kvm rng_core iTCO_wdt iTCO_vendor_support uhci_hcd processor pcspkr ehci_hcd
i2c_i801 8139cp 8139too mii sky2 evdev sr_mod button fan thermal serio_raw sg
 usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ahci
ata_piix libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16 i915 drm
i2c_algo_bit i2c_
core video output [last unloaded: scsi_wait_scan]
Feb 18 22:30:33 muser klogd:
Feb 18 22:30:33 muser klogd: Pid: 24632, comm: unrar Not tainted
(2.6.31.12-desktop-1mnb #1) SK45
Feb 18 22:30:33 muser klogd: EIP: 0060:[<f818d411>] EFLAGS: 00010297 CPU: 0
Feb 18 22:30:33 muser klogd: EIP is at ext4_da_get_block_prep+0x301/0x310
[ext4]
Feb 18 22:30:33 muser klogd: EAX: 0000004b EBX: d0b0ef5c ECX: 0000004b EDX:
0000004c
Feb 18 22:30:33 muser klogd: ESI: 00000000 EDI: d0b0ed20 EBP: cd0bdc90 ESP:
cd0bdc40
Feb 18 22:30:33 muser klogd:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb 18 22:30:33 muser klogd: Process unrar (pid: 24632, ti=cd0bc000
task=e68531c0 task.ti=cd0bc000)
Feb 18 22:30:33 muser klogd: Stack:
Feb 18 22:30:33 muser klogd:  00025241 00000000 00000001 cc950100 00000000
d0b0eda8 00000000 cd0bdc7c
Feb 18 22:30:33 muser klogd: <0> ffff0000 ffffffff 00000001 f651c800 d0b0ed20
00000000 d0b0eda8 d0b0ef5c
Feb 18 22:30:33 muser klogd: <0> 00000000 00025241 00000000 00000000 cd0bdcf4
c0201132 cc950100 00000001
Feb 18 22:30:33 muser klogd: Call Trace:
Feb 18 22:30:33 muser klogd:  [<c0201132>] ? __block_prepare_write+0x152/0x3b0
Feb 18 22:30:33 muser klogd:  [<c01ac869>] ? add_to_page_cache_lru+0x49/0x80
Feb 18 22:30:33 muser klogd:  [<c0201543>] ? block_write_begin+0x53/0xf0
Feb 18 22:30:33 muser klogd:  [<f818d110>] ? ext4_da_get_block_prep+0x0/0x310
[ext4]
Feb 18 22:30:33 muser klogd:  [<f8190950>] ? ext4_da_write_begin+0x170/0x310
[ext4]
Feb 18 22:30:33 muser klogd:  [<f818d110>] ? ext4_da_get_block_prep+0x0/0x310
[ext4]
Feb 18 22:30:33 muser klogd:  [<c01acc16>] ?
generic_file_buffered_write+0xf6/0x2f0
Feb 18 22:30:33 muser klogd:  [<c01ae7b3>] ?
__generic_file_aio_write_nolock+0x203/0x510
Feb 18 22:30:33 muser klogd:  [<c01aebce>] ? generic_file_aio_write+0x5e/0xd0
Feb 18 22:30:33 muser klogd:  [<f8186411>] ? ext4_file_write+0x51/0x180 [ext4]
Feb 18 22:30:33 muser klogd:  [<c01dd1f4>] ? do_sync_write+0xc4/0x100
Feb 18 22:30:33 muser klogd:  [<c0158200>] ? autoremove_wake_function+0x0/0x50
Feb 18 22:30:33 muser klogd:  [<c0250144>] ? security_file_permission+0x14/0x20
Feb 18 22:30:33 muser klogd:  [<c01dd392>] ? rw_verify_area+0x62/0xd0
Feb 18 22:30:33 muser klogd:  [<c0146dab>] ? __do_softirq+0xeb/0x1b0
Feb 18 22:30:33 muser klogd:  [<c01dd4a2>] ? vfs_write+0xa2/0x190
Feb 18 22:30:33 muser klogd:  [<c01dd130>] ? do_sync_write+0x0/0x100
Feb 18 22:30:33 muser klogd:  [<c01ddf92>] ? sys_write+0x42/0x70
Feb 18 22:30:33 muser klogd:  [<c0103dbb>] ? sysenter_do_call+0x12/0x28
Feb 18 22:30:33 muser klogd: Code: 00 00 8b 4d 08 89 51 1c 8b 55 d0 8b 4d d4 8b
5d 08 89 53 0c 89 4b 10 8b 40 0c 89 43 14 f0 80 0b 40 f0 80 4b 01 02 e9 97 fd
ff ff <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 76 00 55 89 e5 83 ec 20
Feb 18 22:30:33 muser klogd: EIP: [<f818d411>]
ext4_da_get_block_prep+0x301/0x310 [ext4] SS:ESP 0068:cd0bdc40
Feb 18 22:30:33 muser klogd: ---[ end trace 06999a64cf21fa09 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
