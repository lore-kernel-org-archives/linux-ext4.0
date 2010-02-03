From: tytso@mit.edu
Subject: Re: OOPS BUG at fs/ext4/inode.c:1853
Date: Tue, 2 Feb 2010 21:54:22 -0500
Message-ID: <20100203025422.GC16384@thunk.org>
References: <7897FA4C-4600-4872-A003-BBB6B099785D@infogears.com>
Reply-To: linux-ext4@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Rusty Conover <rconover@infogears.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0BCCyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 21:54:24 -0500
Content-Disposition: inline
In-Reply-To: <7897FA4C-4600-4872-A003-BBB6B099785D@infogears.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 02, 2010 at 08:25:44PM -0500, Rusty Conover wrote:
> Hi,
> 
> Here is a kernel oops using the latest fedora 12 kernel.  Machine is
> a Intel(R) Xeon(R) CPU E5430 @ 2.66GHz, running in 32bit mode,
> normal SATA disks.  Filesystem was created in fedora 10, and machine
> upgraded via yum to Fedora 12.  Is reproducible using "stress-1.0.2"
> from http://weather.ou.edu/~apw/projects/stress/

Thanks for the bug report!

Can you send us the output of dumpe2fs -h on the filesystem in
question, and the exact Fedora 12 kernel version?  This is a quad-core
machine, right?  How much memory did you have installed in the
machine?

How long did you you have to run the script before the oops triggered?
I haven't been able to trigger it using the latest ext4 tree running
under KVM (but that's only emulating two, not four cores).  Next up is
the mainline tree, and then stock 2.6.32.6....  Eric can probably test
F12 kernel faster than I can (I do have an F12 machine that Red Hat
has graciously lent me, but due to travel and a new job it hasn't been
hooked up yet, and I can only use it when I'm at home; so I probably
won't have time to test on that machine until the weekend).

Regards,

       	         	       	     	      - Ted

> 
> Command line to reproduce was:  ./stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --hdd 1  
> 
> Please cc any reply to me, and all help is appreciated.
> 
> Cheers,
> 
> Rusty
> --
> Rusty Conover
> rconover@infogears.com
> InfoGears Inc / GearBuyer.com / FootwearBuyer.com
> http://www.infogears.com
> http://www.gearbuyer.com
> http://www.footwearbuyer.com
> 
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/inode.c:1853!
> invalid opcode: 0000 [#1] SMP 
> last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> Modules linked in: w83793 w83627hf hwmon_vid i5k_amb coretemp ipmi_msghandler i2c_core ipt_LOG xt_multiport nf_conntrack_ftp cpufreq_ondemand acpi_cpufreq ipv6 pp
> _pc i5000_edac edac_core e1000e serio_raw parport raid1 dm_multipath [last unloaded: i2c_i801]
> 
> Pid: 27992, comm: stress Not tainted (2.6.31.12-174.2.3.fc12.i686.PAE #1) X7DVL-3
> EIP: 0060:[<c0527a75>] EFLAGS: 00010297 CPU: 3
> EIP is at ext4_da_get_block_prep+0xef/0x246
> EAX: 00000023 EBX: 0003a325 ECX: 00000023 EDX: 00000024
> ESI: 00000000 EDI: d0bf6600 EBP: ed86bc90 ESP: ed86bc58
> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process stress (pid: 27992, ti=ed86a000 task=ea8db300 task.ti=ed86a000)
> Stack:
> df5c9cc0 df5c9cc0 f649b400 ffff0000 ffffffff 00000000 d0bf683c d0bf6600
> <0> 00000000 d0bf6688 00000000 0003a325 00000000 c84f6500 ed86bce0 c04e4b1a
> <0> df5c9cc0 00000001 ed86bcd4 df5c9cc0 d0bf6688 00001000 00000000 00000000
> Call Trace:
> [<c04e4b1a>] ? __block_prepare_write+0x11b/0x26d
> [<c04e4de0>] ? block_write_begin+0x73/0xd8
> [<c0527986>] ? ext4_da_get_block_prep+0x0/0x246
> [<c049bc1f>] ? add_to_page_cache_lru+0x4f/0x58
> [<c05276d1>] ? ext4_da_write_begin+0x1c8/0x252
> [<c0527986>] ? ext4_da_get_block_prep+0x0/0x246
> [<c049c497>] ? generic_file_buffered_write+0xd4/0x263
> [<c049ca64>] ? __generic_file_aio_write_nolock+0x258/0x289
> [<c049cd5e>] ? generic_file_aio_write+0x5f/0xb0
> [<c051f809>] ? ext4_file_write+0xa3/0x11a
> [<c04c8ae1>] ? do_sync_write+0xae/0xe9
> [<c056f065>] ? file_has_perm+0x89/0xa3
> [<c0450db9>] ? autoremove_wake_function+0x0/0x34
> [<c056f355>] ? selinux_file_permission+0x49/0x4d
> [<c056867f>] ? security_file_permission+0x14/0x16
> [<c04c8ca2>] ? rw_verify_area+0x9d/0xc0
> [<c04c8a33>] ? do_sync_write+0x0/0xe9
> [<c04c907c>] ? vfs_write+0x85/0xe4
> [<c04cf7ee>] ? path_put+0x1a/0x1d
> [<c04c9179>] ? sys_write+0x40/0x62
> [<c0408fbb>] ? sysenter_do_call+0x12/0x28
> Code: 00 89 45 e0 8b 45 e0 e8 45 34 25 00 8b 4d e4 8b 45 ec 8b 91 2c 02 00 00 42 e8 75 bd ff ff 8b 7d e4 8b 97 30 02 00 00 39 d0 73 04 <0f> 0b eb fe 29 d0 89 45 d
> 
> EIP: [<c0527a75>] ext4_da_get_block_prep+0xef/0x246 SS:ESP 0068:ed86bc58
> ---[ end trace 156dd7e7b61aac87 ]---
> 
> 
> # dumpe2fs -h /dev/md2
> dumpe2fs 1.41.9 (22-Aug-2009)
> Filesystem volume name:   <none>
> Last mounted on:          /
> Filesystem UUID:          ec711783-a186-466e-a175-ac1fb30dddf7
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              28835840
> Block count:              115340656
> Reserved block count:     5767032
> Free blocks:              96094336
> Free inodes:              27927481
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      996
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> Flex block group size:    16
> Filesystem created:       Mon Jan  5 16:15:36 2009
> Last mount time:          Tue Feb  2 16:17:09 2010
> Last write time:          Tue Feb  2 16:17:08 2010
> Mount count:              29
> Maximum mount count:      -1
> Last checked:             Mon Jan  5 16:15:36 2009
> Check interval:           0 (<none>)
> Lifetime writes:          1158 MB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:		            256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> First orphan inode:       101263
> Default directory hash:   half_md4
> Directory Hash Seed:      dd38dd1a-5e43-4e35-8c96-db5ac377591b
> Journal backup:           inode blocks
> Journal size:             128M
> 
> [root@site-18 ~]# mount
> /dev/md2 on / type ext4 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> tmpfs on /dev/shm type tmpfs (rw)
> /dev/md1 on /boot type ext3 (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> 
> [root@site-18 ~]# cat /proc/mdstat 
> Personalities : [raid1] 
> md1 : active raid1 sda1[0] sdb1[1]
>       10241280 blocks [2/2] [UU]
>       
> md2 : active raid1 sda3[0] sdb3[1]
>       461362624 blocks [2/2] [UU]
>       
> md0 : active raid1 sda2[0] sdb2[1]
>       16779776 blocks [2/2] [UU]
>       
> unused devices: <none>
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
