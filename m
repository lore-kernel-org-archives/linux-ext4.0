From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2428!
Date: Tue, 22 Nov 2016 16:00:15 +0200
Message-ID: <8c47de93-88b2-77e0-532e-b295f3ace11a@kyup.com>
References: <c2a82d58-c696-33f5-1187-ea79df0f9dc8@kyup.com>
 <20161114134929.GJ2524@quack2.suse.cz>
 <090c368c-8141-0a28-4104-56d0ee683f8a@kyup.com>
 <20161121142723.GF8207@quack2.suse.cz>
 <093b94ca-0e61-fddd-db6a-97456b50b6cc@kyup.com>
 <20161122133452.GF3973@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38315 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933140AbcKVOAT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Nov 2016 09:00:19 -0500
Received: by mail-wm0-f44.google.com with SMTP id f82so26781306wmf.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2016 06:00:17 -0800 (PST)
In-Reply-To: <20161122133452.GF3973@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/22/2016 03:34 PM, Jan Kara wrote:
> On Mon 21-11-16 16:42:09, Nikolay Borisov wrote:
>>
>>
>> On 11/21/2016 04:27 PM, Jan Kara wrote:
>>> On Mon 14-11-16 16:46:51, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 11/14/2016 03:49 PM, Jan Kara wrote:
>>>>> Hello,
>>>>>
>>>>> On Mon 14-11-16 12:15:16, Nikolay Borisov wrote:
>>>>>> So I hit the following BUG_ON on 3 separate servers: 
>>>>>>
>>>>>> [1387898.597939] sh (14886): drop_caches: 3
>>>>>> [1387945.259613] ------------[ cut here ]------------
>>>>>> [1387945.259791] kernel BUG at fs/ext4/inode.c:2428!
>>>>>> [1387945.259964] invalid opcode: 0000 [#1] SMP 
>>>>>> [1387945.263921] CPU: 9 PID: 8987 Comm: kworker/u24:23 Tainted: P           O    4.4.26-clouder1 #3
>>>>>> [1387945.264213] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
>>>>>> [1387945.264512] Workqueue: writeback wb_workfn (flush-253:8)
>>>>>> [1387945.264780] task: ffff880287ca5280 ti: ffff8800064dc000 task.ti: ffff8800064dc000
>>>>>> [1387945.265073] RIP: 0010:[<ffffffff8122a3ac>]  [<ffffffff8122a3ac>] mpage_prepare_extent_to_map+0x29c/0x2d0
>>>>>> [1387945.265426] RSP: 0018:ffff8800064df960  EFLAGS: 00010246
>>>>>> [1387945.265596] RAX: 02fffc0000030039 RBX: ffff8800064dfad0 RCX: 0000000000000537
>>>>>> [1387945.265881] RDX: 000000000000231b RSI: 0000000000000000 RDI: ffffffff81a052a6
>>>>>> [1387945.266165] RBP: ffff8800064dfa28 R08: 0000000000000000 R09: 0000000000000000
>>>>>> [1387945.266450] R10: 0000000000000001 R11: 0000000000000100 R12: ffff8800064df980
>>>>>> [1387945.266734] R13: 0000000000003400 R14: ffffffffffffffff R15: ffffea000686fbc0
>>>>>> [1387945.267024] FS:  0000000000000000(0000) GS:ffff88047fd20000(0000) knlGS:0000000000000000
>>>>>> [1387945.267315] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>> [1387945.267487] CR2: ffffffffff600400 CR3: 00000004555ff000 CR4: 00000000000406e0
>>>>>> [1387945.267765] Stack:
>>>>>> [1387945.267925]  0000000000000000 ffff88015b3c2be0 ffff8800064df980 0000000000000538
>>>>>> [1387945.268386]  0000000000000001 0000000000000000 ffffea000686fbc0 ffff88046bce1800
>>>>>> [1387945.268850]  ffff8800064df9e8 ffffffff81274777 ffffffff02400040 0fd000086bce6800
>>>>>> [1387945.269319] Call Trace:
>>>>>> [1387945.269489]  [<ffffffff81274777>] ? jbd2__journal_start+0xe7/0x200
>>>>>> [1387945.269663]  [<ffffffff8122e581>] ? ext4_writepages+0x3a1/0xcd0
>>>>>> [1387945.269839]  [<ffffffff8125ba8d>] ? __ext4_journal_start_sb+0x6d/0x100
>>>>>> [1387945.270013]  [<ffffffff8122e5b2>] ext4_writepages+0x3d2/0xcd0
>>>>>> [1387945.270207]  [<ffffffffa07f878b>] ? leaf_space_used+0xcb/0x100 [btrfs]
>>>>>> [1387945.270382]  [<ffffffff810823a1>] ? sched_clock_cpu+0xa1/0xb0
>>>>>> [1387945.270556]  [<ffffffff8107beb4>] ? check_preempt_curr+0x54/0x90
>>>>>> [1387945.270730]  [<ffffffff8107c07d>] ? ttwu_do_activate.constprop.92+0x5d/0x70
>>>>>> [1387945.270905]  [<ffffffff8113735e>] do_writepages+0x1e/0x30
>>>>>> [1387945.271076]  [<ffffffff811c6c85>] __writeback_single_inode+0x45/0x370
>>>>>> [1387945.271250]  [<ffffffff811c74d2>] writeback_sb_inodes+0x252/0x570
>>>>>> [1387945.271423]  [<ffffffff811c7879>] __writeback_inodes_wb+0x89/0xc0
>>>>>> [1387945.271596]  [<ffffffff811c7bb8>] wb_writeback+0x268/0x300
>>>>>> [1387945.271766]  [<ffffffff811c83e6>] wb_workfn+0x2d6/0x400
>>>>>> [1387945.271938]  [<ffffffff81614ea8>] ? _raw_spin_lock_irqsave+0x18/0x50
>>>>>> [1387945.272112]  [<ffffffff8106bf89>] process_one_work+0x159/0x450
>>>>>> [1387945.272285]  [<ffffffff8106c639>] worker_thread+0x69/0x490
>>>>>> [1387945.272456]  [<ffffffff8106c5d0>] ? rescuer_thread+0x350/0x350
>>>>>> [1387945.272630]  [<ffffffff810717bf>] kthread+0xef/0x110
>>>>>> [1387945.272803]  [<ffffffff810716d0>] ? kthread_park+0x60/0x60
>>>>>> [1387945.272975]  [<ffffffff816156bf>] ret_from_fork+0x3f/0x70
>>>>>> [1387945.273146]  [<ffffffff810716d0>] ? kthread_park+0x60/0x60
>>>>>> [1387945.273322] Code: d2 e4 ff e8 67 6f 3e 00 48 8b 85 50 ff ff ff 49 39 c6 0f 83 15 fe ff ff 31 c0 eb a7 4c 89 ff e8 3b e8 ef ff e9 b8 fe ff ff 0f 0b <0f> 0b 48 8d bd 58 ff ff ff 89 85 48 ff ff ff e8 50 f8 f0 ff 8b 
>>>>>> [1387945.276751] RIP  [<ffffffff8122a3ac>] mpage_prepare_extent_to_map+0x29c/0x2d0
>>>>>> [1387945.277089]  RSP <ffff8800064df960>
>>>>>>
>>>>>> So a user triggers drop_caches and ext4 crashes due to it trying to 
>>>>>> write a page that isn't fs-owned. ffffffff8122a3ac is : head = page_buffers(page);
>>>>>> which has this: BUG_ON(!PagePrivate(page)); 
>>>>>>
>>>>>> page.flags is flags = 216168384067469369 (in binary: 0000001011111111111111000000000000000000000000110000000000111001) 
>>>>>> so the 11th bit (PG_private) is not set, triggering the BUG_ON. The flags are 
>>>>>> (PG_LOCKED|PG_UPTODATE|PG_DIRTY|MAPPEDTODISK|PG_RECLAIM). Do these flags seem 
>>>>>> corrupt - uptodate and dirty being set at the same time? Maybe the page struct
>>>>>> is being corrupted?
>>>>>>
>>>>>> page.private is actually NULL. The page does have an associated address_space 
>>>>>> mapping. I've validated this since address_space.host is the same as the 
>>>>>> inode member of the passed mpd. 
>>>>>
>>>>> Interesting. I didn't see this yet. What mount options does the filesystem
>>>>> use? The file where this happened is a regular file I assume, right? What
>>>>> is blocksize and page size for the filesystem?
>>>>
>>>> s_blocksize_bits = 12,
>>>> s_blocksize = 4096,
>>>>
>>>> And this is x86_64 so pagesize is also 4k. Unfortunately I cannot
>>>> re-mount the file system since it has been converted to btrfs. However
>>>> here are the options: rw,relatime,discard,stripe=32,data=ordered, these
>>>> have been taken from an analogous mount. This is how it's supposed to
>>>> have been created: mkfs.ext4 -b 4096 -K -E nodiscard,lazy_itable_init=1
>>>> -O has_journal,large_file,resize_inode,sparse_super,uninit_bg
>>>>
>>>> Since those values are from the system which supposedly created those,
>>>> here are the raw values form the ext4_sb_info->s_mount_opt* members:
>>>> s_mount_opt = 3892496400,
>>>> s_mount_opt2 = 2,
>>>>
>>>> And from ext4_super_block->s_feature_*:
>>>>
>>>>   s_feature_compat = 0,
>>>>   s_feature_incompat = 61267,
>>>>   s_feature_ro_compat = 0,
>>>
>>> This looks strange - COMPAT and RO_COMPAT features definitely should not be
>>> zero (e.g. has_journal and sparse_super should be set), also INCOMPAT
>>> features look weird - e.g. bit 0x800 is not used but it is set in incompat
>>> features. Did you get the sb pointer right?
> 
> You did not respond to this... Can you show full ext4_super_block contents
> as well?

crash> struct mpage_da_data ffff8800064dfad0
struct mpage_da_data {
  inode = 0xffff88015b3c2a78,
  wbc = 0xffff8800064dfc00,
  first_page = 1335,
  next_page = 1336,
  last_page = 18446744073709551615,
  map = {
    m_pblk = 18446612145925311300,
    m_lblk = 105773856,
    m_len = 0,
    m_flags = 2164768893
  },
  io_submit = {
    io_wbc = 0xffff8800064dfc00,
    io_bio = 0x0,
    io_end = 0xffff88010ce72510,
    io_next_block = 18446612132419992536
  }
}
crash> struct inode.i_sb 0xffff88015b3c2a78
  i_sb = 0xffff88046bce6800
crash> struct super_block.s_fs_info 0xffff88046bce6800
  s_fs_info = 0xffff88046bce7800


Here is the output of 'struct ext4_super_block 0xffff88046bce7800':
http://sprunge.us/DdEA

And the flags now look different than what I have posted previously,
very strange. I must have misread something somewhere.

Unfortunately I cannot apply the patch  you sent since the workload has
already been migrated to btrfs. I hoped the info the crash dump would be
enough to track it and fix it. The actual workload was just a bunch of
ext4 filesystems created inside a loop file and doing rsyncs into those
loop devices. So nothing special really.

> 
>>>>> The page flags actually look rather consistent. The only thing that is
>>>>
>>>> Why is UPTODATE and DIRTY set simultaneously. Don't they contradict each
>>>> other?
>>>
>>> They can be set simultaneously - 'uptodate' means page has at least as new
>>> data as is on disk, 'dirty' means page has strictly newer data than on
>>> disk.
>>>
>>> What is page->index and how large is the inode (inode->i_size)?
>>
>> So here is the full page struct for reference:
> 
> <snip>
> 
> All the structures look sane and consistent except for page->private being
> NULL...
> 
>> Also I just had the same issue happen on 2 more physical servers. This
>> excludes the possibility of a random memory corruption.
> 
> OK, any idea how reproducible it is? Attached debug patch could tell us
> more and it can be easily used in production as well, just I'm not sure to
> how many machined you'd have to deploy this to catch the problem...
> 
> Also can you check whether there are not any warnings from ext4 before this
> fatal failure in the kernel logs? Because my current suspicion is that the
> machines are getting close to OOM, some allocation in the writeback path
> fails somewhere and we do not properly recover from the failed writeback
> (i.e. we redirty the page but not corresponding buffers) or something like
> that.
> 
> 								Honza
> 
