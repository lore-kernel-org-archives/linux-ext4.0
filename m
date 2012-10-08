From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: A warning from 3.6+ with bigalloc and delalloc when running xfstest
Date: Mon, 8 Oct 2012 22:59:34 +0800
Message-ID: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33219 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2JHO7f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 10:59:35 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so4030904pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 07:59:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

When I run xfstest to do some tests in upstream kernel (commit id:
d43b7167), I get a warning from dmesg.  The warning is as below:

Oct  8 22:39:45 lz-desktop kernel: EXT4-fs (sda1):
ext4_da_update_reserve_space: ino 21, allocated 1 with only 0 reserved
metadata blocks
Oct  8 22:39:45 lz-desktop kernel:
Oct  8 22:39:45 lz-desktop kernel: ------------[ cut here ]------------
Oct  8 22:39:45 lz-desktop kernel: WARNING: at fs/ext4/inode.c:362
ext4_da_update_reserve_space+0x116/0x224 [ext4]()
Oct  8 22:39:45 lz-desktop kernel: Hardware name: OptiPlex 780
Oct  8 22:39:45 lz-desktop kernel: Modules linked in: ext4(O) jbd2
crc16 autofs4 cpufreq_ondemand acpi_cpufreq mperf ipv6 dm_mirror
dm_region_hash dm_log dm_mod dcdbas pcspkr serio_raw i2c_i801 i2c_core
sg parport_pc parport snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc
e1000e button ext3 jbd sd_mod ahci libahci libata scsi_mod ehci_hcd
uhci_hcd
Oct  8 22:39:45 lz-desktop kernel: Pid: 9239, comm: fsx Tainted: G
   W  O 3.6.0+ #23
Oct  8 22:39:45 lz-desktop kernel: Call Trace:
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff8203212e>]
warn_slowpath_common+0x85/0x9d
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff82032160>]
warn_slowpath_null+0x1a/0x1c
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa0299c63>]
ext4_da_update_reserve_space+0x116/0x224 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa02c0a5d>]
ext4_ext_map_blocks+0xd42/0xf36 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa029a66e>] ?
ext4_map_blocks+0x10c/0x1f8 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa029a66e>] ?
ext4_map_blocks+0x10c/0x1f8 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa029a6a0>]
ext4_map_blocks+0x13e/0x1f8 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa029af29>]
mpage_da_map_and_submit+0x117/0x497 [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa029ba55>]
ext4_da_writepages+0x37d/0x52b [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff8205fef5>] ?
sched_clock_local+0x1c/0x82
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff820ca586>] do_writepages+0x23/0x2c
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff820c2eb6>]
__filemap_fdatawrite_range+0x53/0x55
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff820c2ee8>]
filemap_write_and_wait_range+0x30/0x59
Oct  8 22:39:45 lz-desktop kernel: [<ffffffffa0292916>]
ext4_sync_file+0x9a/0x35c [ext4]
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff82060057>] ? local_clock+0x2b/0x3c
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff82071b1f>] ?
lock_release_holdtime+0x1c/0x11f
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff821261ff>]
vfs_fsync_range+0x1d/0x26
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff82126224>] vfs_fsync+0x1c/0x1e
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff820e7b3a>] sys_msync+0x116/0x190
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff821cc7de>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Oct  8 22:39:45 lz-desktop kernel: [<ffffffff823a5492>]
system_call_fastpath+0x16/0x1b
Oct  8 22:39:45 lz-desktop kernel: ---[ end trace f6002ce762f77c1e ]---
...

This warning is printed when test case #127 and #225 are being run
with bigalloc and delalloc.  You could use the following commands to
reproduce it using xfstest.

1. mkfs.ext4 -O bigalloc /dev/XXX1
2. mkfs.ext4 -O bigalloc /dev/XXX2
3. export MKFS_OPTIONS="-O bigalloc"
4. export MOUNT_OPTIONS="-o acl,user_xattr"
5. ./check 127

I notice that the warning is from ext4_da_update_reserve_space(), and
in this function a new 'if' statement is added (commit id: 97795d2a).
Hopefully it is useful to fix this problem.  Thanks.

Regards,
Zheng
