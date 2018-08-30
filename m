From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: stack-out-of-bounds Read in __schedule
Date: Thu, 30 Aug 2018 07:19:12 -0700
Message-ID: <CACT4Y+b7-oJCecsigTsN=OERGpMMQx+8GFNvD7JhN1vbNt4e+A@mail.gmail.com>
References: <000000000000fef39305748083ae@google.com> <20180829134620.GD7369@quack2.suse.cz>
 <CAG_fn=VMcHaGrFs_YvtBttmfuz8Rr1C_dfmKRibvPrbqeKFGCA@mail.gmail.com>
 <CACT4Y+a2bwVvDRfL=wg=5bnOv6S7RrJYoh4ygaizqVm3JpNu1A@mail.gmail.com> <279041ab-d449-1bfb-a05d-2d8b0d5c601b@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Alexander Potapenko <glider@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        syzbot+45a34334c61a8ecf661d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <279041ab-d449-1bfb-a05d-2d8b0d5c601b@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2018 at 2:52 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following crash on:
>>>>>
>>>>> HEAD commit:    5b394b2ddf03 Linux 4.19-rc1
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14f4d8e1400000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=49927b422dcf0b29
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=45a34334c61a8ecf661d
>>>>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13127e5a400000
>>>>>
>>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>>> Reported-by: syzbot+45a34334c61a8ecf661d@syzkaller.appspotmail.com
>>>>>
>>>>> IPv6: ADDRCONF(NETDEV_UP): veth1: link is not ready
>>>>> IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
>>>>> IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
>>>>> 8021q: adding VLAN 0 to HW filter on device team0
>>>>> ==================================================================
>>>>> BUG: KASAN: stack-out-of-bounds in schedule_debug kernel/sched/core.c:3285
>>>>> [inline]
>>>>> BUG: KASAN: stack-out-of-bounds in __schedule+0x1977/0x1df0
>>>>> kernel/sched/core.c:3395
>>>>> Read of size 8 at addr ffff8801ad090000 by task syz-executor0/4718
>>>>
>>>> Weird, can you please help me decipher this? So here KASAN complains about
>>>> wrong memory access in the scheduler.
>>
>> This looks like a result of a previous bad silent memory corruption.
>>
>> The KASAN report says there is a stack out-of-bounds in scheduler. And
>> that if followed by slab corruption report in another task.
>>
>> fs/jbd2/transaction.c happens to be the first meaningful file in this
>> crash, and so that's where it is attributed to.
>>
>> Rerunning the reproducer several times can maybe give some better
>> glues, or maybe not, maybe they all will look equally puzzling.
>>
>> This part of the repro looks familiar:
>>
>> r1 = bpf$MAP_CREATE(0x0, &(0x7f0000002e40)={0x12, 0x0, 0x4, 0x6e, 0x0,
>> 0x1}, 0x68)
>> bpf$MAP_UPDATE_ELEM(0x2, &(0x7f0000000180)={r1, &(0x7f0000000000),
>> &(0x7f0000000140)}, 0x20)
>>
>> We had exactly such consequences of a bug in bpf map very recently,
>> but that was claimed to be fixed. Maybe not completely?
>> +bpf maintainers
>
> Looks like syzbot found this in Linus tree with HEAD commit 5b394b2ddf03 ("Linux 4.19-rc1")
> one day later net PR got merged via 050cdc6c9501 ("Merge git://git.kernel.org/pub/...").
>
> This PR contained a couple of fixes I did on sockmap code during audit such as:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b845c898b2f1ea458d5453f0fa1da6e2dfce3bb4
>
> Looking at the reproducer syzkaller found it contains:
>
>   r1 = bpf$MAP_CREATE(0x0, &(0x7f0000002e40)={0x12, 0x0, 0x4, 0x6e, 0x0, 0x1}, 0x68)
>                                                     ^^^
>
> So it found the crash with map type of sock hash and key size of 0x0 (which is invalid),
> where subsequent map update triggered the corruption. I just did a 'syz test' and it
> wasn't able to trigger the crash anymore.
>
> #syz fix: bpf, sockmap: fix sock_hash_alloc and reject zero-sized keys


Thanks.

I am again trying to figure out how/why this causes such bad failure modes.
Looking at sock_hash_ctx_update_elem it seems that all of
htab_map_hash/lookup_elem_raw/alloc_sock_hash_elem should handle
key_size=0 fine hashing/comparing/updating 0 bytes. Do you have any
ideas as to what could have gone wrong?
