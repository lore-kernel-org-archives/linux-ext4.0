From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: delayed inode update for the consistency of file
 size after a crash
Date: Sun, 10 Dec 2017 12:16:00 -0500
Message-ID: <20171210171600.2l2gsuv4rfta6z6t@thunk.org>
References: <20171210121257.GA1588@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: seongbaeSon <seongbae.son@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56538 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdLJRQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Dec 2017 12:16:03 -0500
Content-Disposition: inline
In-Reply-To: <20171210121257.GA1588@son-VirtualBox>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 10, 2017 at 09:12:57PM +0900, seongbaeSon wrote:
> 1. Current file offset of fileA is 14 KB. An application appends 2 KB data to
> fileA by executing a write() system call. At this time, the file size in 
> the ext4_inode of fileA is updated to 16 KB by ext4_da_write_end().
> 2. Current file offset of fileB is 14 KB. An application appends 2 KB data to
> fileB by executing a write() system call. At this time, the file size in
> the ext4_inode of fileB is updated to 16 KB by ext4_da_write_end().
> 3. A fsync(fileB) is called before the kworker thread runs. At this time,
> the application thread transfers the data block of fileB to storage and
> wakes up the JBD2. Then, JBD2 writes the ext4_inodes of fileA and fileB in
> the running transaction to the journal area. The ext4_inode of fileA in 
> the journal area has the file size, 16 KB, even though the data block of
> fileA has not been written to storage.
> 4. Assume that a system crash occurs. The EXT4 recovery module recovers
> the inodes of fileA and fileB. The recovered inode of fileA has the updated
> file size, 16 KB, even though the data of fileA has not been made durable.
> The data block of fileA between 14 KB and 16 KB is seen as zeros.

There's nothing wrong with this.  The user space application called
fsync on fileB, and *not* on fileA.  Therefore, there is absolutely no
guarantee that fileA's data contents are valid.

Consider the exact same thing will happen if the application had
written data to fileA at offsets 6k to 8k.  If those offsets were
previously zero, then after the crash, those offsets *might* still be
zero after the crash, *unless* the application had first called
fsync() or fdatasync() first.

> Details can be found as follows.
> 
> Son et al. "Guaranteeing the Metadata Update Atomicity in EXT4 Filesystem”,
> In Proc. of APSYS 2017, Mumbai, India

This is behind a paywall, so I can't access it.  I am sorry I wasn't
on the program committee, or I would have pointed this out while the
paper was being reviewed.

The problem with providing more guarantees than what is strictly
provided for by POSIX is that it degrades the performance of the file
system.  It can also promote application writes to depend on semantics
which are non-portable, which can cause problems when they try to run
that progam on other operating systems or other file systems.

Cheers,

						- Ted
