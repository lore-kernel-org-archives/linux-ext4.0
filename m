From: Jan Kara <jack@suse.cz>
Subject: Re: Uninterruptable hang in sendfile
Date: Mon, 12 Oct 2015 14:33:14 +0200
Message-ID: <20151012123314.GC17050@quack.suse.cz>
References: <CACT4Y+Z-7GuiLKBwRXrGCNwte5DBjwRyqtxr-MmZ-C94RJftvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
	jack@suse.com,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	syzkaller@googlegroups.com, Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Julien Tinnes <jln@google.com>, Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z-7GuiLKBwRXrGCNwte5DBjwRyqtxr-MmZ-C94RJftvw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Mon 12-10-15 11:18:48, Dmitry Vyukov wrote:
> Hello,
> 
> The following program leads to hang in D state in:
<snip>
This is the minimal reproducer:
        int fd;
        off_t off = 0;

        fd = open("file", O_RDWR | O_TRUNC | O_SYNC | O_CREAT, 0644);
        ftruncate(fd, 2);
        lseek(fd, 0, SEEK_END);
        sendfile(fd, fd, &off, 0xfffffff);

And although it is a "nice" way to DOS a kernel, it isn't a bug as such.
Effectively you ask kernel to copy some 256MB of data in 2-byte chunks,
fsyncing after each chunk. That takes a *lot* of time to do... In my test
kvm the write speed is some whooping 50 bytes/s so after roughly 62 days
the syscall *will* complete.

I guess some fatal_signal_pending() check somewhere would be good so that
the process can be killed. We do have such check in generic_perform_write()
and that would almost work. The trouble is that we always first write those
two bytes, only then perform signal check and then we return 2 bytes
written. Thus the information about signal gets continuously lost.

I'll send a patch which fixes the problem for me and makes the test program
killable.

								Honza
 
> /proc/self/stack shows:
> 
> [<ffffffff8122fa85>] jbd2_log_wait_commit+0x95/0x110
> fs/jbd2/journal.c:706 (discriminator 2)
> [<ffffffff812324e2>] jbd2_complete_transaction+0x52/0x90 fs/jbd2/journal.c:744
> [<ffffffff811dc2c4>] ext4_sync_file+0x254/0x2e0 fs/ext4/fsync.c:141
> [<ffffffff811932e6>] vfs_fsync_range+0x36/0xa0 fs/sync.c:190
> [<     inline     >] generic_write_sync include/linux/fs.h:2442
> [<ffffffff811db6ff>] ext4_file_write_iter+0x13f/0x340 fs/ext4/file.c:177
> [<ffffffff81165331>] vfs_iter_write+0x61/0x90 fs/read_write.c:364
> [<ffffffff8119150d>] iter_file_splice_write+0x1dd/0x370 fs/splice.c:1012
> [<     inline     >] do_splice_from fs/splice.c:1116
> [<ffffffff811906f1>] direct_splice_actor+0x31/0x40 fs/splice.c:1282
> [<ffffffff81190e10>] splice_direct_to_actor+0x90/0x1f0 fs/splice.c:1235
> [<ffffffff81190fe7>] do_splice_direct+0x77/0xa0 fs/splice.c:1325
> [<ffffffff811664b8>] do_sendfile+0x198/0x380 fs/read_write.c:1227
> [<     inline     >] SYSC_sendfile64 fs/read_write.c:1282
> [<ffffffff81166f5a>] SyS_sendfile64+0x4a/0x90 fs/read_write.c:1274
> [<ffffffff81859a97>] entry_SYSCALL_64_fastpath+0x12/0x6a
> arch/x86/entry/entry_64.S:185
> 
> On commit dd36d7393d6310b0c1adefb22fba79c3cf8a577c
> (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
> 
> Found with syzkaller fuzzer.
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
