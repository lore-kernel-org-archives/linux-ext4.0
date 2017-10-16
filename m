From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Sun, 15 Oct 2017 21:28:52 -0400
Message-ID: <20171016012852.pz63e7hd67c7ipy5@thunk.org>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
 <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
 <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
 <20171015124800.zjsqu623rivp27qv@thunk.org>
 <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49478 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbdJPB2y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 21:28:54 -0400
Content-Disposition: inline
In-Reply-To: <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 15, 2017 at 04:37:03PM -0700, Kilian Cavalotti wrote:
> The timeline was:
> 1. mounted r/o
> 2. "du /mnt/path/to/deep/dir" returned decent value
> 3. started rsyncíng data out
> 4. mounted r/w
> 5. errors started to appear in the rsync process
> 6. "ls /mnt/path" returned I/O error and "deleted inode referenced"
> 
> So I _think_ that the filesystem was mostly ok before the r/w remount,
> because the first-level directory of my initial "du", which worked,
> ended up disappearing.

I agree with you; if the initial du worked, but then a du after the
r/w remount failed, then the second possibility is more likely what
happened.

> I think it started online, but I'm not even sure it actually did it. I
> don't have enough logs from that part to be sure what happened. I
> believe resize2fs may actually have refused to operate, because of
> pre-existing ext4 errors, but in the end, the filesystem appears to
> have been resized anyways... So maybe the online tentative didn't
> work, and the vendor automated process tried again an offline resize?
> Is there any possibility that the filesystem could appear to be
> resized (extended) with the actual inode table still referencing the
> pre-resize one?

It's possible, I suppose.  If the vendor script unmounted the file
system and then attempted to run e2fsck -fy to fix the file system,
perhaps.  In which case the damage could also have been done by the
e2fsck -fy run, depending on how badly the file system was corrupted
before this whole procedure was started.

But that would imply that the NAS box would have to stop serving the
file system, and it would have been pretty obviously an off-line
procedure.

Good luck,

						- Ted
