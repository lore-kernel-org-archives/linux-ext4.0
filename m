From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Fri, 26 Jun 2015 20:05:48 -0700
Message-ID: <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
References: <20150625034626.GA21682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150625034626.GA21682@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 24, 2015 at 8:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> A very large number of cleanups and bug fixes --- in particular for
> the ext4 encryption patches, which is a new feature added in the last
> merge window.  Also fix a number of long-standing xfstest failures.
> (Quota writes failing due to ENOSPC, a race between truncate and
> writepage in data=journalled mode that was causing generic/068 to
> fail, and other corner cases.)
>
> Also add support for FALLOC_FL_INSERT_RANGE, and improve jbd2
> performance eliminating locking when a buffer is modified more than
> once during a transaction (which is very common for allocation
> bitmaps, for example), in which case the state of the journalled
> buffer head doesn't need to change.

I think this is very broken.

I just got this while compiling:

   ------------[ cut here ]------------
   kernel BUG at fs/jbd2/transaction.c:1325!
   invalid opcode: 0000 [#1] SMP
   Modules linked in: bnep bluetooth fuse ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 nf_conntrack_ipv6 ...
   CPU: 7 PID: 5509 Comm: gcc Not tainted 4.1.0-10944-g2a298679b411 #1
   Hardware name:                  /DH87RL, BIOS
RLH8710H.86A.0327.2014.0924.1645 09/24/2014
   task: ffff8803bf866040 ti: ffff880308528000 task.ti: ffff880308528000
   RIP: jbd2_journal_dirty_metadata+0x237/0x290
   Call Trace:
     __ext4_handle_dirty_metadata+0x43/0x1f0
     ext4_handle_dirty_dirent_node+0xde/0x160
     ? jbd2_journal_get_write_access+0x36/0x50
     ext4_delete_entry+0x112/0x160
     ? __ext4_journal_start_sb+0x52/0xb0
     ext4_unlink+0xfa/0x260
     vfs_unlink+0xec/0x190
     do_unlinkat+0x24a/0x270
     SyS_unlink+0x11/0x20
     entry_SYSCALL_64_fastpath+0x12/0x6a
   Code: ff f3 90 48 8b 16 f7 c2 00 00 80 00 75 f3 e9 f4 fe ff ff b8
8b ff ff ff e9 8e fe ff ff 31 c0 e9 3a ff ff ff 31 ff e9 26 ff ff ff
<0f> 0b 41 83 7c 24 0c 01 0f 84 e4 fe ff ff 0f 0b 0f 0b 4d 85 c9
   RIP  jbd2_journal_dirty_metadata+0x237/0x290
   ---[ end trace ae033ebde8d080b4 ]---

followed by basically a dead machine (SIGSEGV's, unresponsive X etc).
I assume it died with some major jbd2 or ext4 lock held.

The most obvious candidate for a culprit would seem to be

   2143c1965a76 "jbd2: speedup jbd2_journal_dirty_metadata()"

which is the commit that introduced the assert that triggers. Ted? Jan?

Nothing particularly odd was going on. I was reading email in a
browser while doing an allmodconfig build with "make -j16". That's
literally all I ever tend to do.

                            Linus
