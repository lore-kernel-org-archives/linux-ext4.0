From: Seongbae Son <seongbae.son@gmail.com>
Subject: [PATCH] ext4: delayed inode update for the consistency of file size
 after a crash
Date: Sat, 16 Dec 2017 13:33:26 +0900
Message-ID: <20171216043326.GA12365@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > 1. Current file offset of fileA is 14 KB. An application appends 2 KB data to
> > fileA by executing a write() system call. At this time, the file size in
> > the ext4_inode of fileA is updated to 16 KB by ext4_da_write_end().
> > 2. Current file offset of fileB is 14 KB. An application appends 2 KB data to
> > fileB by executing a write() system call. At this time, the file size in
> > the ext4_inode of fileB is updated to 16 KB by ext4_da_write_end().
> > 3. A fsync(fileB) is called before the kworker thread runs. At this time,
> > the application thread transfers the data block of fileB to storage and
> > wakes up the JBD2. Then, JBD2 writes the ext4_inodes of fileA and fileB in
> > the running transaction to the journal area. The ext4_inode of fileA in
> > the journal area has the file size, 16 KB, even though the data block of
> > fileA has not been written to storage.
> > 4. Assume that a system crash occurs. The EXT4 recovery module recovers
> > the inodes of fileA and fileB. The recovered inode of fileA has the updated
> > file size, 16 KB, even though the data of fileA has not been made durable.
> > The data block of fileA between 14 KB and 16 KB is seen as zeros.

> There's nothing wrong with this.  The user space application called
> fsync on fileB, and *not* on fileA.  Therefore, there is absolutely no
> guarantee that fileA's data contents are valid.
> 
> Consider the exact same thing will happen if the application had
> written data to fileA at offsets 6k to 8k.  If those offsets were
> previously zero, then after the crash, those offsets *might* still be
> zero after the crash, *unless* the application had first called
> fsync() or fdatasync() first.

> > Details can be found as follows.
> >
> > Son et al. "Guaranteeing the Metadata Update Atomicity in EXT4 Filesystem”,
> > In Proc. of APSYS 2017, Mumbai, India

> This is behind a paywall, so I can't access it.  I am sorry I wasn't
> on the program committee, or I would have pointed this out while the
> paper was being reviewed.

Hello Ted,

Thanks for your quick answer.
I am sorry about that. I could not think about the paywall.

> The problem with providing more guarantees than what is strictly
> provided for by POSIX is that it degrades the performance of the file
> system.  It can also promote application writes to depend on semantics
> which are non-portable, which can cause problems when they try to run
> that progam on other operating systems or other file systems.

I have performed the above scenario to xfs, btrfs, f2fs, and zfs.
As the test result, all of the four file systems does not have the problem
that fileA in which fsync() was not executed has the wrong file size
after a system crash. So, I think, the portability of applications might be
okay even though EXT4 guarantees the consistency between the file size and
the data blocks of the file that fsync() is not executed after a system crash.

Many thanks,

Seongbae Son.
