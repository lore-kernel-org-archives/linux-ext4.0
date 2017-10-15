From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Sun, 15 Oct 2017 16:37:03 -0700
Message-ID: <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca> <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca> <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
 <20171015124800.zjsqu623rivp27qv@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:45939 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbdJOXhZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Oct 2017 19:37:25 -0400
Received: by mail-wm0-f51.google.com with SMTP id q124so30783536wmb.0
        for <linux-ext4@vger.kernel.org>; Sun, 15 Oct 2017 16:37:24 -0700 (PDT)
In-Reply-To: <20171015124800.zjsqu623rivp27qv@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I very much appreciate you taking the time to answer here. Some
comments inline below.

On Sun, Oct 15, 2017 at 5:48 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> It wasn't from replaying a journal, corrupted or not.  Andreas was
> mistaken there; remounting the file system read/write would not have
> triggered a journal replay; if the journal needed replaying it would
> have been replayed on the read-only mount.
>
> There are two possibilities about what could have happened; one is
> that the file system was already badly corrupted, but your copy
> command hadn't started hitting the corrupted portion of the file
> system, and so it was coincidence that the r/w remount happened right
> before the errors started getting flagged.

That's something I considered indeed, but (and I have recorded session
logs to prove I didn't dream it after the fact) right after the
initial r/o mount, I ran a "du -hs" on some deeper-level directories:
there wasn't any error and "du" returned reasonable values.

The timeline was:
1. mounted r/o
2. "du /mnt/path/to/deep/dir" returned decent value
3. started rsync=C3=ADng data out
4. mounted r/w
5. errors started to appear in the rsync process
6. "ls /mnt/path" returned I/O error and "deleted inode referenced"

So I _think_ that the filesystem was mostly ok before the r/w remount,
because the first-level directory of my initial "du", which worked,
ended up disappearing.

> The second possibility is that is that the allocation bitmaps were
> corrupted, and shortly after you remounted read/write something stated
> to write into your file system, and since the part of the inode table
> areas was marked as "available" the write into the file system ended
> up smashing the inode table.  (More modern kernels enable the
> block_validity option by default, which would have prevented this; but
> if you were using an older kernel, it would not have enabled this
> feature by default.)

Yeah, I think it may have been this: although I didn't explicitly
write to the filesystem, I suspect some system daemon may have...
It's a 3.10 kernel, by the way, with likely some back-ported patches,
but the vendor doesn't provide many details.

> Since the problem started with the resize, I'm actually guessing the
> first is more likely.  Especially if you were using an older version
> of e2fsprogs/resize2fs,

1.42.6, most likely.

> and if you were doing an off-line resize
> (i.e., the file system was unmounted at the time).

I think it started online, but I'm not even sure it actually did it. I
don't have enough logs from that part to be sure what happened. I
believe resize2fs may actually have refused to operate, because of
pre-existing ext4 errors, but in the end, the filesystem appears to
have been resized anyways... So maybe the online tentative didn't
work, and the vendor automated process tried again an offline resize?
Is there any possibility that the filesystem could appear to be
resized (extended) with the actual inode table still referencing the
pre-resize one?

> There were a
> number of bugs with older versions of e2fsprogs with file systems
> larger than 16TB (hence, the 64-bit file system feature was enabled)
> associated with off-line resize, and the manisfestation of these bugs
> includes portions of the inode table getting smashed.
>
> Unfortunately, there may not be a lot we can do, if that's the case.  :-(

The upside is that I'm now learning a lot about file carving tools. :)

> This is probably not a great time to remind people about the value of
> backups, especially off-site backups (even if software was 100%
> bug-free, what if there was a fire at your home/work)?

It's always a good time to remind about backups, and although the bulk
of the most precious data I had was replicated elsewhere, verifying
integrity and consistency of such replications is a whole venture in
itself.
So yeah, from now on, logical replication on different (file)systems,
metadata backup (I had no idea about e2image before) and snapshots
will be non negotiable requirements.

> Sorry,

I appreciate this, truly, and I'm very grateful for the very existence
of ext4. As many catastrophes, this was likely an accumulation of
little things that would have been benign taken independently, but
that each contributed to my data going poof. :)

Cheers,
--=20
Kilian
