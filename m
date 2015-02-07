From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] ext4: fix indirect punch hole corruption
Date: Fri, 06 Feb 2015 18:35:58 -0600
Message-ID: <54D55DEE.6020509@canonical.com>
References: <cf81509853ecdbef7d738d8d39abe786f41193ec.1423169101.git.osandov@osandov.com> <54D3E107.9030501@canonical.com> <20150207002859.GA9536@mew>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150207002859.GA9536@mew>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/06/2015 06:28 PM, Omar Sandoval wrote:
> On Thu, Feb 05, 2015 at 03:30:47PM -0600, Chris J Arges wrote:
>> On 02/05/2015 02:50 PM, Omar Sandoval wrote:
>>> Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
>>> mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
>>> mapping. However, the case where the punch happens within one level of
>>> indirection is incorrect. It assumes that the partial branches returned
>>> from ext4_find_shared will have the same depth, but this is not
>>> necessarily the case even when the offsets have the same depth. For
>>> example, if the last block occurs at the beginning of an indirect group
>>> (i.e., it has an offset of 0 at the end of the offsets array), then
>>> ext4_find_shared will return a shallower chain. So, let's handle the
>>> mismatch and clean up that case. Tested with generic/270, which no
>>> longer leads to an inconsistent filesystem like before.
>>>
>>> Signed-off-by: Omar Sandoval <osandov@osandov.com>
>>
>>
>> Omar,
>>
>> Tried running this with my original reproducer (qcow2 snapshotting and
>> rebooting) and got the following:
>> ------------[ cut here ]------------
>> kernel BUG at fs/ext4/indirect.c:1488!
>> invalid opcode: 0000 [#1] SMP
>> <snip>
>> CPU: 4 PID: 9771 Comm: qemu-img Tainted: G        W   E
>> 3.19.0-rc7-b164aa5 #22
>> Hardware name: XXX
>> task: ffff880243a34aa0 ti: ffff880240f3c000 task.ti: ffff880240f3c000
>> RIP: 0010:[<ffffffff812a38e7>]  [<ffffffff812a38e7>]
>> ext4_ind_remove_space+0x737/0x740
>> RSP: 0018:ffff880240f3fc98  EFLAGS: 00010246
>> RAX: ffff880240f3fd98 RBX: ffff880240f3fd98 RCX: ffff880098c684dc
>> RDX: ffff880098c684d4 RSI: ffff880240f3fd08 RDI: ffff880098c684e0
>> RBP: ffff880240f3fdf8 R08: ffff880098c684e0 R09: 0000000000000000
>> R10: ffff880240f3faa0 R11: 0000000000000038 R12: ffff88009bb65810
>> R13: 0000000000000003 R14: ffff880240f3fd08 R15: ffff880240f3fd68
>> FS:  00007f7ad84ad700(0000) GS:ffff88024e500000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f7ae19a78ff CR3: 0000000241c52000 CR4: 00000000003427e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Stack:
>>  ffffea0002596600 ffff88009bb65960 0000000000000050 0000000000000100
>>  ffff8802447a2900 0000000000000003 ffff880240f3fd08 ffff88009b96c030
>>  ffff880240f3fd08 000000000000024b 000000000000000d ffff880000000034
>> Call Trace:
>>  [<ffffffff8129ccdc>] ? ext4_discard_preallocations+0x16c/0x480
>>  [<ffffffff8126982f>] ext4_punch_hole+0x3bf/0x430
>>  [<ffffffff81293c9e>] ext4_fallocate+0x16e/0x8c0
>>  [<ffffffff811e4849>] ? __sb_start_write+0x49/0xf0
>>  [<ffffffff811df3cf>] vfs_fallocate+0x12f/0x250
>>  [<ffffffff810eda41>] ? SyS_futex+0x71/0x150
>>  [<ffffffff811e0408>] SyS_fallocate+0x48/0x80
>>  [<ffffffff8177cc2d>] system_call_fastpath+0x16/0x1b
>> Code: 40 4c 8d 0c c5 e8 ff ff ff 49 c1 f9 03 45 69 c9 ab aa aa aa e8 6b
>> e2 ff ff 48 8b 85 10 ff ff ff c7 00 00 00 00 00 e9 fd fa ff ff <0f> 0b
>> 0f 0b 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41
>> RIP  [<ffffffff812a38e7>] ext4_ind_remove_space+0x737/0x740
>>  RSP <ffff880240f3fc98>
>> ---[ end trace 05f053fdd5d908a8 ]---
>>
>> So this is hitting the BUG_ON you added.
>> --chris
>>
> 
> Chris,
> 
> Would you mind sending over your exact reproduction steps? I've cooked
> up a patch which appears to be working, but I want to test it out a bit
> more before I send it out.
> 
> Thanks,
> 

Omar,

To reproduce this issue do the following:
1) Setup ext4 ^extents, or ext3 filesystem with CONFIG_EXT4_USE_FOR_EXT23=y
2) Create and install a VM using a qcow2 image and store the file on the
filesystem
3) Snapshot the image with qemu-img
4) Boot the image and do some disk operations (fio,etc)
5) Shutdown image and delete snapshot
6) Repeat 3-5 until VM no longer boots due to image corruption,
generally this takes a few iterations depending on disk operations.

I have the reproducer ready to go on my system to feel free to send me a
preliminary patch and I'll test it again over the weekend.
Thanks,
--chris j arges
