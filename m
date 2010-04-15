From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: EXT4_IOC_MOVE_EXT file corruption!
Date: Thu, 15 Apr 2010 12:17:24 -0700
Message-ID: <20100415191724.GW29604@tux1.beaverton.ibm.com>
References: <20100405220220.GT29604@tux1.beaverton.ibm.com> <4BC6CE06.3070302@rs.jp.nec.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49652 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0DOTR1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 15:17:27 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3FJ5Y0o023314
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 15:05:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3FJHQZf138584
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 15:17:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3FJHP5b023291
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 16:17:25 -0300
Content-Disposition: inline
In-Reply-To: <4BC6CE06.3070302@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 15, 2010 at 05:27:50PM +0900, Akira Fujita wrote:
> Hi Darrick,
>
> (2010/04/06 7:02), Darrick J. Wong wrote:
>> Hi all,
>>
>> I wrote a program called e4frag that deliberately tries to fragment an ext4
>> filesystem via EXT4_IOC_MOVE_EXT so that I could run e4defrag through its
>> paces.  While running e4frag and e4defrag concurrently on a kernel source tree,
>> I discovered ongoing file corruption.  It appears that if e4frag and e4defrag
>> hit the same file at same time, the file ends up with a 4K data block from
>> somewhere else.  "Somewhere else" seems to be a small chunk of binary gibberish
>> followed by contents from other files(!)  Obviously this isn't a good thing to
>> see, since today it's header files but tomorrow it could be the credit card/SSN
>> database. :)
>>
>> Ted asked me to send out a copy of the program ASAP, so the test program source
>> code is at the end of this message.  To build it, run:
>>
>> $ gcc -o e4frag -O2 -Wall e4frag.c
>>
>> and then to run it:
>>
>> (unpack something in /path/to/files)
>> $ cp -pRdu /path/to/files /path/to/intact_files
>> $ while true; do e4defrag /path/to/files&  done
>> $ while true; do ./e4frag -m 500 -s random /path/to/files&  done
>> $ while true; do diff -Naurp /path/to/intact_files /path/to/files; done
>>
>> ...and wait for diff to cough up differences.  This seems to happen on
>> 2.6.34-rc3, and only if e4frag and e4defrag are running concurrently.  Running
>> e4frag or e4defrag in a serial loop doesn't produce this corruption, so I think
>> it's purely a concurrent access problem.
>
> I couldn't reproduce this problem, somehow.
>
> My environment is:
> Arch: i386
> Kernel: 2.6.34-rc3
> e2fsprogs: 1.41.11
> Mount option: delalloc, data=ordered, async
> Block size: 4KB
> Partition size: 100GB
>
> Is there any difference in your case?
> And how long does this file corruption take to be detected?
>
> I ran below program all day long, but problem did not occur.

Hmm.  I was running with 2.6.34-rc3 on x86-64, same block size, though with a
2TB mdraid0.  It usually took a few hours to reproduce, though I've noticed
that if I kick off at least as many e4defrags and e4frags, it will show up much
sooner.  Thank you for trying this out!

> ---
> #!/bin/bash
>
> TARGET="/mnt/mp1/TEST/linux-2.6.34-rc3"
> ORIG="/mnt/mp1/TEST/linux-2.6.34-rc3-orig"
>
> cp -pRdu $TARGET $ORIG
> while true; do ./e4defrag -v $TARGET & done
> while true; do ./e4frag -m 500 -s random $TARGET & done
> while true; do diff -Naurp $ORIG $TARGET; done
> ---
>
> # The OOM killer sometimes runs while running this program
>   because this is a heavy load for system, though.

Hmm... I don't ever see the OOM killer.

I've now seen this show up, just once:
[267630.741537] ------------[ cut here ]------------
[267630.746247] kernel BUG at /home/djwong/linux-2.6.34-rc3-fs/fs/ext4/extents.c:1922!
[267630.753903] invalid opcode: 0000 [#3] PREEMPT SMP 
[267630.758855] last sysfs file: /sys/devices/virtual/block/md0/md/metadata_version
[267630.766249] CPU 12 
[267630.768274] Modules linked in: ext4 mbcache jbd2 crc16 kvm_intel kvm eeprom i2c_dev ipmi_si ipmi_msghandler iptable_filter coretemp hwmon ip_tables x_tables i2c_scmi i2c_i801 cdc_ether usbnet i2c_core mousedev rtc_cmos evdev rtc_core serio_raw rtc_lib shpchp acpi_cpufreq pci_hotplug ioatdma button dca processor af_packet nfs lockd fscache nfs_acl auth_rpcgss sunrpc virtio_pci virtio_ring sd_mod crc_t10dif sg sr_mod cdrom usbhid hid raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod dm_mirror dm_region_hash dm_log dm_snapshot dm_mod virtio_net virtio bridge stp mptsas llc mptscsih lpfc mptbase fan ata_piix scsi_transport_fc ehci_hcd uhci_hcd scsi_transport_sas usbcore scsi_tgt fuse libata nls_base scsi_mod bnx2 ther
 mal [last unloaded: crc16]
[267630.842501] 
[267630.844091] Pid: 5938, comm: e4defrag Tainted: G      D W  2.6.34-rc3-fs64 #12 49Y6512     /System x3550 M2 -[7946AC1]-
[267630.854950] RIP: 0010:[<ffffffffa054d8c2>]  [<ffffffffa054d8c2>] ext4_ext_walk_space+0x14a/0x24a [ext4]
[267630.864462] RSP: 0018:ffff88011b047d78  EFLAGS: 00010246
[267630.869864] RAX: 0000000000000000 RBX: 0000000000000039 RCX: ffff880107a57228
[267630.877082] RDX: 00000000ffffffc6 RSI: 0000000000000038 RDI: 0000000000000039
[267630.884304] RBP: ffff88011b047df8 R08: 0000000000000001 R09: 00000000000002f4
[267630.891523] R10: 0000000000000000 R11: 0000000000001000 R12: ffff880377b2d800
[267630.898743] R13: ffff88016b305a58 R14: ffff88016b3058e0 R15: ffffffffa054ba01
[267630.905965] FS:  00007fa4dbf766f0(0000) GS:ffff880205e00000(0000) knlGS:0000000000000000
[267630.914137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[267630.919971] CR2: 000000000211e5f8 CR3: 0000000185793000 CR4: 00000000000006e0
[267630.927193] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[267630.934415] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[267630.941637] Process e4defrag (pid: 5938, threadinfo ffff88011b046000, task ffff8801f1c81460)
[267630.950156] Stack:
[267630.952259]  ffffea000591eab0 ffff880107a57228 ffff8801ffffffc6 ffff88011b047e88
[267630.959634] <0> ffff88016b3059d8 00000001ffffffff 0000000007aebdb8 0000000100000038
[267630.967482] <0> ffff880100000002 ffffffff810c8a2a ffff88011b047e28 ffff88016b305a58
[267630.975525] Call Trace:
[267630.978069]  [<ffffffff810c8a2a>] ? do_writepages+0x24/0x2d
[267630.983742]  [<ffffffffa054db04>] ext4_fiemap+0x142/0x14f [ext4]
[267630.989839]  [<ffffffff810c1f33>] ? filemap_fdatawait+0x21/0x23
[267630.995848]  [<ffffffff8111388f>] ioctl_fiemap+0x10f/0x16f
[267631.001424]  [<ffffffff81113d57>] do_vfs_ioctl+0x259/0x2cb
[267631.007000]  [<ffffffff81113e10>] sys_ioctl+0x47/0x6a
[267631.012146]  [<ffffffff81009d32>] system_call_fastpath+0x16/0x1b
[267631.018239] Code: c7 eb 22 66 41 81 f8 00 80 41 0f b7 f8 76 06 81 ef 00 80 00 00 01 f7 01 da b8 01 00 00 00 39 fa 0f 42 fa eb 02 31 c0 39 df 77 04 <0f> 0b eb fe 85 c0 75 19 29 df 89 5d b8 89 7d bc 48 c7 45 b0 00 
[267631.038581] RIP  [<ffffffffa054d8c2>] ext4_ext_walk_space+0x14a/0x24a [ext4]
[267631.045753]  RSP <ffff88011b047d78>
[267631.049404] ---[ end trace 0df9444f77ea4b61 ]---

Judging from the source code, some bitmap somewhere is getting corrupted,
because the test that triggers the bug is if end <= beginning while walking the
extent list.  I rebooted the box and ran fsck, and fsck complained about bitmap
errors.

--D
