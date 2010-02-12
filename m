From: Rusty Conover <rconover@infogears.com>
Subject: Re: OOPS BUG at fs/ext4/inode.c:1853
Date: Fri, 12 Feb 2010 07:51:34 -0500
Message-ID: <472BEE5F-AAA3-49F3-8D78-77D4A1A5873A@infogears.com>
References: <7897FA4C-4600-4872-A003-BBB6B099785D@infogears.com> <20100203025422.GC16384@thunk.org> <D4C80345-358A-4065-9591-2B25F1E5C71E@infogears.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.infogears.com ([69.51.90.143]:44858 "EHLO
	mail.infogears.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0BLMvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Feb 2010 07:51:38 -0500
In-Reply-To: <D4C80345-358A-4065-9591-2B25F1E5C71E@infogears.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> On Tue, Feb 02, 2010 at 08:25:44PM -0500, Rusty Conover wrote:
>>> Hi,
>>> 
>>> Here is a kernel oops using the latest fedora 12 kernel.  Machine is
>>> a Intel(R) Xeon(R) CPU E5430 @ 2.66GHz, running in 32bit mode,
>>> normal SATA disks.  Filesystem was created in fedora 10, and machine
>>> upgraded via yum to Fedora 12.  Is reproducible using "stress-1.0.2"
>>> from http://weather.ou.edu/~apw/projects/stress/
>> 
>> Thanks for the bug report!
> 


Hi All,

We did a full raid resync, with e2fsck and was still able to get another OOPS after about a week of running "stress".

Unfortunately this report didn't get everything, but hopefully its still helpful.

The kernel version is the same as Fedora 12 hasn't yet released an update.

Thanks,

Rusty


------------[ cut here ]------------ 
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/0-002f/beep_enable 
Process stress (pid: 15814, ti=e8a16000 task=e99a0cc0 task.ti=e8a16000) 
Stack: 
Call Trace: 
ESI: 00000000 EDI: f0bef6a0 EBP: e8a17c90 ESP: e8a17c58 
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 
Process stress (pid: 15814, ti=e8a16000 task=e99a0cc0 task.ti=e8a16000) 
Stack: 
d5d747c0 d5d747c0 f6796c00 ffff0000 ffffffff 00000000 f0bef8dc f0bef6a0 
<0> 00000000 f0bef728 00000000 00018904 00000000 c8df8280 e8a17ce0 c04e4b1a 
<0> d5d747c0 00000001 e8a17cd4 d5d747c0 f0bef728 00001000 00000000 00000000 
Call Trace: 
[<c04e4b1a>] ? __block_prepare_write+0x11b/0x26d 
[<c04e4de0>] ? block_write_begin+0x73/0xd8 
[<c0527986>] ? ext4_da_get_block_prep+0x0/0x246 
[<c049bc1f>] ? add_to_page_cache_lru+0x4f/0x58 
[<c05276d1>] ? ext4_da_write_begin+0x1c8/0x252 
[<c0527986>] ? ext4_da_get_block_prep+0x0/0x246 
[<c049c497>] ? generic_file_buffered_write+0xd4/0x263 
[<c049ca64>] ? __generic_file_aio_write_nolock+0x258/0x289 
[<c049cd5e>] ? generic_file_aio_write+0x5f/0xb0 
[<c051f809>] ? ext4_file_write+0xa3/0x11a 
[<c04c8ae1>] ? do_sync_write+0xae/0xe9 
[<c056f065>] ? file_has_perm+0x89/0xa3 
[<c0450db9>] ? autoremove_wake_function+0x0/0x34 
[<c056f355>] ? selinux_file_permission+0x49/0x4d 
[<c056867f>] ? security_file_permission+0x14/0x16 
[<c04c8ca2>] ? rw_verify_area+0x9d/0xc0 
[<c04c8a33>] ? do_sync_write+0x0/0xe9 
[<c04c907c>] ? vfs_write+0x85/0xe4 
[<c04cf7ee>] ? path_put+0x1a/0x1d 
[<c04c9179>] ? sys_write+0x40/0x62 
[<c0408fbb>] ? sysenter_do_call+0x12/0x28 
Code: 00 89 45 e0 8b 45 e0 e8 45 34 25 00 8b 4d e4 8b 45 ec 8b 91 2c 02 00 00 42 e8 7 
 d0 73 04 <0f> 0b eb fe 29 d0 89 45 dc 8b 45 e0 f0 fe 00 8b 55 ec 31 f6 8b  
EIP: [<c0527a75>] ext4_da_get_block_prep+0xef/0x246 SS:ESP 0068:e8a17c58 
---[ end trace 7449c5aa814e4d05 ]---

--
Rusty Conover
rconover@infogears.com
InfoGears Inc / GearBuyer.com / FootwearBuyer.com / BabyGearBuyer.com
http://www.gearbuyer.com
http://www.footwearbuyer.com
http://www.babygearbuyer.com







