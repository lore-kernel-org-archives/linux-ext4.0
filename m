From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [BUG][data=journal] WARN_ON(PageChecked(page)) in ext4_releasepage()
 when we run xfstests #247
Date: Thu, 7 Mar 2013 20:33:57 +0800
Message-ID: <20130307123356.GD2800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40695 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3CGMSo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 07:18:44 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so433709pab.17
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2013 04:18:44 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I hit this WARN_ON in 3.8 kernel and dev branch.  The WARN_ON is hard to
be triggerred because I run test case 8 times to hit it.  Here is the
messages from dmesg.

*One Big Note*
Although we get the warning message, the test can pass.

wenqing: run xfstest 247
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Not tainted 3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d66 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d67 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d68 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d69 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d6a ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d6b ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d6c ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:2926 ext4_releasepage+0x74/0xa4 [ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6 dm_mirror 
dm_region_hash dm_log dm_mod parport_pc parport dcdbas acpi_cpufreq mperf 
serio_raw pcspkr i2c_i801 i2c_core sg ehci_pci ehci_hcd button e1000e ext3 
jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: Pid: 6063, comm: dd Tainted: G        W    3.8.0 #1
kernel: Call Trace:
kernel: [<ffffffff82031d68>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d9a>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa01fe8c8>] ext4_releasepage+0x74/0xa4 [ext4]
kernel: [<ffffffff820afb0e>] try_to_release_page+0x36/0x3f
kernel: [<ffffffff820baedf>] invalidate_inode_pages2_range+0x168/0x270
kernel: [<ffffffff820b14ea>] generic_file_direct_write+0xb8/0x16a
kernel: [<ffffffff820b17a5>] __generic_file_aio_write+0x209/0x2ef
kernel: [<ffffffffa01f8a49>] ext4_file_write+0x29e/0x38d [ext4]
kernel: [<ffffffff820edb2c>] do_sync_write+0x9d/0xda
kernel: [<ffffffff820ee574>] vfs_write+0xb3/0x138
kernel: [<ffffffff820ee6cd>] sys_write+0x54/0x7e
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 5372b37668057d6d ]---

......
[snip]

Regards,
                                                - Zheng
