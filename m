From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Sun, 15 Oct 2017 08:48:00 -0400
Message-ID: <20171015124800.zjsqu623rivp27qv@thunk.org>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
 <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
 <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48654 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdJOMsE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 08:48:04 -0400
Content-Disposition: inline
In-Reply-To: <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 14, 2017 at 06:16:14PM -0700, Kilian Cavalotti wrote:
> But unfortunately there's another ~17TB of data that fsck didin't
> find. That seems like a lot of data lost from just replaying a
> corrupted journal... :(

It wasn't from replaying a journal, corrupted or not.  Andreas was
mistaken there; remounting the file system read/write would not have
triggered a journal replay; if the journal needed replaying it would
have been replayed on the read-only mount.

There are two possibilities about what could have happened; one is
that the file system was already badly corrupted, but your copy
command hadn't started hitting the corrupted portion of the file
system, and so it was coincidence that the r/w remount happened right
before the errors started getting flagged.

The second possibility is that is that the allocation bitmaps were
corrupted, and shortly after you remounted read/write something stated
to write into your file system, and since the part of the inode table
areas was marked as "available" the write into the file system ended
up smashing the inode table.  (More modern kernels enable the
block_validity option by default, which would have prevented this; but
if you were using an older kernel, it would not have enabled this
feature by default.)

Since the problem started with the resize, I'm actually guessing the
first is more likely.  Especially if you were using an older version
of e2fsprogs/resize2fs, and if you were doing an off-line resize
(i.e., the file system was unmounted at the time).  There were a
number of bugs with older versions of e2fsprogs with file systems
larger than 16TB (hence, the 64-bit file system feature was enabled)
associated with off-line resize, and the manisfestation of these bugs
includes portions of the inode table getting smashed.

Unfortunately, there may not be a lot we can do, if that's the case.  :-(

This is probably not a great time to remind people about the value of
backups, especially off-site backups (even if software was 100%
bug-free, what if there was a fire at your home/work)?

Sorry,

						- Ted
