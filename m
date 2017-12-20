From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in rb_insert_color
Date: Wed, 20 Dec 2017 08:50:40 +0100
Message-ID: <CACT4Y+Y1ZP=q1DUDxWG4jLyLXGs5XkyTz=H+ozd3V6Az6Npjng@mail.gmail.com>
References: <94eb2c1170ce36bd770560ad6d3a@google.com> <20171219215906.GA12465@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+eb13811afcefe99cfe45081054e7883f569f949d@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171219215906.GA12465@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 19, 2017 at 10:59 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Tue, Dec 19, 2017 at 12:41:01AM -0800, syzbot wrote:
>> Hello,
>>
>> syzkaller hit the following crash on
>> 6084b576dca2e898f5c101baef151f7bfdbb606d
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached
>> Raw console output is attached.
>>
>> Unfortunately, I don't have any reproducer for this bug yet.
>>
>>
>> sctp: [Deprecated]: syz-executor6 (pid 4202) Use of int in max_burst
>> socket option.
>> Use struct sctp_assoc_value instead
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> sctp: [Deprecated]: syz-executor4 (pid 4240) Use of int in max_burst
>> socket option.
>> Use struct sctp_assoc_value instead
>> sctp: [Deprecated]: syz-executor4 (pid 4240) Use of int in max_burst
>> socket option.
>> Use struct sctp_assoc_value instead
>> IP: __rb_insert lib/rbtree.c:126 [inline]
>> IP: rb_insert_color+0x17/0x190 lib/rbtree.c:452
>> PGD 0 P4D 0
>> Oops: 0000 [#1] SMP
>> Dumping ftrace buffer:
>>    (ftrace buffer empty)
>> Modules linked in:
>> CPU: 0 PID: 4244 Comm: modprobe Not tainted 4.15.0-rc3-next-20171214+ #67
>> Hardware name: Google Google Compute Engine/Google Compute Engine,
>> BIOS Google 01/01/2011
>> RIP: 0010:__rb_insert lib/rbtree.c:126 [inline]
>> RIP: 0010:rb_insert_color+0x17/0x190 lib/rbtree.c:452
>> RSP: 0018:ffffc900010a7c08 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff814ddcb9
>> RDX: ffff8801ebedf988 RSI: ffff8801ebfd6400 RDI: ffff88021413a408
>> RBP: ffffc900010a7c08 R08: 000000000002bcf8 R09: ffff88021413a400
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021413a400
>> R13: ffff8801ebedf990 R14: 00000000a34fc52a R15: ffff8801ebedf988
>> FS:  00007f85a5155700(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000008 CR3: 00000001eaccd006 CR4: 00000000001606f0
>> DR0: 0000000020000000 DR1: 0000000020000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
>> Call Trace:
>>  ext4_htree_store_dirent+0x122/0x160 fs/ext4/dir.c:488
>>  htree_dirblock_to_tree+0x112/0x300 fs/ext4/namei.c:1019
>>  ext4_htree_fill_tree+0xdf/0x410 fs/ext4/namei.c:1096
>>  ext4_dx_readdir fs/ext4/dir.c:575 [inline]
>>  ext4_readdir+0x8cf/0xd70 fs/ext4/dir.c:122
>>  iterate_dir+0xb8/0x200 fs/readdir.c:51
>>  SYSC_getdents fs/readdir.c:231 [inline]
>>  SyS_getdents+0xcc/0x1b0 fs/readdir.c:212
>>  entry_SYSCALL_64_fastpath+0x1f/0x96
>> RIP: 0033:0x7f85a4a45575
>> RSP: 002b:00007ffc9b5be120 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
>> RAX: ffffffffffffffda RBX: 00007f85a4d23e98 RCX: 00007f85a4a45575
>> RDX: 0000000000008000 RSI: 00005633094701e0 RDI: 0000000000000000
>> RBP: 00007f85a4d23e40 R08: 00005633094701e0 R09: 00007f85a4d23e90
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00005633094701b0
>> R13: 0000000000018e21 R14: 0000000000000000 R15: 0000000000000004
>> Code: 48 85 d2 75 eb 5d c3 31 c0 5d c3 66 0f 1f 84 00 00 00 00 00 55
>> 48 8b 17 48 89 e5 48 85 d2 0f 84 4c 01 00 00 48 8b 02 a8 01 75 5e
>> <48> 8b 48 08 49 89 c0 48 39 d1 74 54 48 85 c9 74 09 f6 01 01 0f
>> RIP: __rb_insert lib/rbtree.c:126 [inline] RSP: ffffc900010a7c08
>> RIP: rb_insert_color+0x17/0x190 lib/rbtree.c:452 RSP: ffffc900010a7c08
>> CR2: 0000000000000008
>> BUG: unable to handle kernel paging request at 0000000100000001
>> ---[ end trace c403bd3ebad2ccb0 ]---
>
> The line number in lib/rbtree.c seems to be slightly off.  Looking at the
> disassembly:
>
>         ffffffff825b5ea0 <rb_insert_color>:
>         ffffffff825b5ea0:       55                      push   %rbp
>         ffffffff825b5ea1:       48 8b 17                mov    (%rdi),%rdx
>         ffffffff825b5ea4:       48 89 e5                mov    %rsp,%rbp
>         ffffffff825b5ea7:       48 85 d2                test   %rdx,%rdx
>         ffffffff825b5eaa:       0f 84 4c 01 00 00       je     ffffffff825b5ffc <rb_insert_color+0x15c>
>         ffffffff825b5eb0:       48 8b 02                mov    (%rdx),%rax
>         ffffffff825b5eb3:       a8 01                   test   $0x1,%al
>         ffffffff825b5eb5:       75 5e                   jne    ffffffff825b5f15 <rb_insert_color+0x75>
>         ffffffff825b5eb7:       48 8b 48 08             mov    0x8(%rax),%rcx
>
> It crashed on 'mov 0x8(%rax),%rcx' which corresponds to
> 'tmp = gparent->rb_right;' at lib/rbtree.c:131.  So 'parent' was the root node,
> but its color was red, while it is supposed to be black.
>
> No idea how that happened, but it's almost certainly not an ext4 bug.  In fact
> there is another report of this same crash that has a different call trace:
>
>         Call Trace:
>          key_alloc_serial security/keys/key.c:170 [inline]
>          key_alloc+0x54c/0x5b0 security/keys/key.c:319
>          keyring_alloc+0x4d/0xb0 security/keys/keyring.c:503
>          install_process_keyring_to_cred.part.3+0x38/0x80 security/keys/process_keys.c:192
>          install_process_keyring_to_cred security/keys/process_keys.c:634 [inline]
>          install_process_keyring security/keys/process_keys.c:217 [inline]
>          lookup_user_key+0x4ed/0x7c0 security/keys/process_keys.c:574
>          SYSC_add_key security/keys/keyctl.c:114 [inline]
>          SyS_add_key+0xec/0x260 security/keys/keyctl.c:62
>          entry_SYSCALL_64_fastpath+0x1f/0x96


My first hypothesis for an non-explainable, non-reproducible
corruption would be a data race. Is there all locking in place?
