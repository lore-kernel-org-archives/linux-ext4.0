From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Mon, 29 Jun 2015 20:31:38 +0800
Message-ID: <CACVXFVOP1sFCeUy2O0_jLmC9aMjzkb79Za1M-H6tJ-ug40Rs7g@mail.gmail.com>
References: <20150625034626.GA21682@thunk.org>
	<CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 27, 2015 at 11:05 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jun 24, 2015 at 8:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> A very large number of cleanups and bug fixes --- in particular for
>> the ext4 encryption patches, which is a new feature added in the last
>> merge window.  Also fix a number of long-standing xfstest failures.
>> (Quota writes failing due to ENOSPC, a race between truncate and
>> writepage in data=journalled mode that was causing generic/068 to
>> fail, and other corner cases.)
>>
>> Also add support for FALLOC_FL_INSERT_RANGE, and improve jbd2
>> performance eliminating locking when a buffer is modified more than
>> once during a transaction (which is very common for allocation
>> bitmaps, for example), in which case the state of the journalled
>> buffer head doesn't need to change.
>
> I think this is very broken.
>
> I just got this while compiling:
>
>    ------------[ cut here ]------------
>    kernel BUG at fs/jbd2/transaction.c:1325!
>    invalid opcode: 0000 [#1] SMP
>    Modules linked in: bnep bluetooth fuse ip6t_rpfilter ip6t_REJECT
> nf_reject_ipv6 nf_conntrack_ipv6 ...
>    CPU: 7 PID: 5509 Comm: gcc Not tainted 4.1.0-10944-g2a298679b411 #1
>    Hardware name:                  /DH87RL, BIOS
> RLH8710H.86A.0327.2014.0924.1645 09/24/2014
>    task: ffff8803bf866040 ti: ffff880308528000 task.ti: ffff880308528000
>    RIP: jbd2_journal_dirty_metadata+0x237/0x290
>    Call Trace:
>      __ext4_handle_dirty_metadata+0x43/0x1f0
>      ext4_handle_dirty_dirent_node+0xde/0x160
>      ? jbd2_journal_get_write_access+0x36/0x50
>      ext4_delete_entry+0x112/0x160
>      ? __ext4_journal_start_sb+0x52/0xb0
>      ext4_unlink+0xfa/0x260
>      vfs_unlink+0xec/0x190
>      do_unlinkat+0x24a/0x270
>      SyS_unlink+0x11/0x20
>      entry_SYSCALL_64_fastpath+0x12/0x6a
>    Code: ff f3 90 48 8b 16 f7 c2 00 00 80 00 75 f3 e9 f4 fe ff ff b8
> 8b ff ff ff e9 8e fe ff ff 31 c0 e9 3a ff ff ff 31 ff e9 26 ff ff ff
> <0f> 0b 41 83 7c 24 0c 01 0f 84 e4 fe ff ff 0f 0b 0f 0b 4d 85 c9
>    RIP  jbd2_journal_dirty_metadata+0x237/0x290
>    ---[ end trace ae033ebde8d080b4 ]---
>
> followed by basically a dead machine (SIGSEGV's, unresponsive X etc).
> I assume it died with some major jbd2 or ext4 lock held.
>
> The most obvious candidate for a culprit would seem to be
>
>    2143c1965a76 "jbd2: speedup jbd2_journal_dirty_metadata()"
>
> which is the commit that introduced the assert that triggers. Ted? Jan?
>
> Nothing particularly odd was going on. I was reading email in a
> browser while doing an allmodconfig build with "make -j16". That's
> literally all I ever tend to do.

BTW, the similar trace stack can be triggered easily by xfstests
generic 269, see the following trace, and looks the revert does fix it.

[ 2391.200871] run fstests generic/269 at 2015-06-28 16:21:32^M
[ 2391.606047] EXT4-fs (sda): mounted filesystem with ordered data
mode. Opts: acl,user_xattr^M
[ 2395.489941] ------------[ cut here ]------------^M
[ 2395.490652] kernel BUG at fs/jbd2/transaction.c:1325!^M
[ 2395.490652] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC ^M
[ 2395.490652] Dumping ftrace buffer:^M
[ 2395.490652]    (ftrace buffer empty)^M
[ 2395.490652] Modules linked in: nbd ipv6 kvm_intel kvm serio_raw
[last unloaded: null_blk]^M
[ 2395.490652] CPU: 10 PID: 2635 Comm: fsstress Not tainted
4.1.0-next-20150626 #359^M
[ 2395.490652] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011^M
[ 2395.490652] task: ffff8800ad84a200 ti: ffff88022cf90000 task.ti:
ffff88022cf90000^M
[ 2395.490652] RIP: 0010:[<ffffffff811dbceb>]  [<ffffffff811dbceb>]
jbd2_journal_dirty_metadata+0x51/0x207^M
[ 2395.490652] RSP: 0018:ffff88022cf93c98  EFLAGS: 00010207^M
[ 2395.490652] RAX: ffff88022972ae00 RBX: ffff8801f8eede10 RCX:
0000000000000000^M
[ 2395.490652] RDX: ffff8800bb7da300 RSI: ffff8800a5c82208 RDI:
ffff8802345efc00^M
[ 2395.490652] RBP: ffff88022cf93cf8 R08: ffff8800a5c82208 R09:
00000000000009af^M
[ 2395.490652] R10: 0000000000000000 R11: 000000000000000c R12:
ffff8800bb7da300^M
[ 2395.490652] R13: ffff8800a5c82208 R14: 0000000000000000 R15:
ffff8802345efc00^M
[ 2395.490652] FS:  00007f2559cc1740(0000) GS:ffff88023ed40000(0000)
knlGS:0000000000000000^M
[ 2395.490652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
[ 2395.490652] CR2: 00007f2554109fb8 CR3: 000000021469a000 CR4:
00000000000007e0^M
[ 2395.490652] Stack:^M
[ 2395.490652]  ffff88022cf93cb8 ffff88020895e800 0000000000000023
ffff8802345efc00^M
[ 2395.490652]  00000000000009af 0000000000000000 ffff8801f8eede10
ffff8800a5c82208^M
[ 2395.490652]  ffff88013bf329a8 0000000000000000 ffff8802345efc00
00000000000003d4^M
[ 2395.490652] Call Trace:^M
[ 2395.490652]  [<ffffffff811c7d38>] __ext4_handle_dirty_metadata+0xcf/0x1bf^M
[ 2395.490652]  [<ffffffff810d83fb>] ? trace_preempt_on+0x12/0x2f^M
[ 2395.490652]  [<ffffffff811a0a53>] __ext4_new_inode+0x930/0xdd0^M
[ 2395.490652]  [<ffffffff811acec8>] ext4_mknod+0x8f/0x131^M
[ 2395.490652]  [<ffffffff81149193>] vfs_mknod+0x7c/0x9c^M
[ 2395.490652]  [<ffffffff8114bf0c>] ? user_path_create+0x2b/0x32^M
[ 2395.490652]  [<ffffffff8114c043>] SYSC_mknodat+0x130/0x176^M
[ 2395.490652]  [<ffffffff8114cd48>] SyS_mknod+0x1d/0x1f^M
[ 2395.490652]  [<ffffffff814f0917>] entry_SYSCALL_64_fastpath+0x12/0x6a^M
[ 2395.490652] Code: 41 89 c6 0f 85 b8 01 00 00 49 8b 45 00 a9 00 00
02 00 0f 84 b1 01 00 00 49 8b 5d 40 48 8b 43 28 4c 39 e0 74 08 4c 39
63 30 74 02 <0f> 0b 83 7b 10 01 75 39 4c 39 e0 0f 85 93 01 00 00 83 7b
0c 01 ^M
[ 2395.490652] RIP  [<ffffffff811dbceb>]
jbd2_journal_dirty_metadata+0x51/0x207^M
[ 2395.490652]  RSP <ffff88022cf93c98>^M
[ 2395.516997] ---[ end trace dc5028a237345935 ]---^M




-- 
Ming Lei
