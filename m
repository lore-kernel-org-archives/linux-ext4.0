From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Sat, 14 Oct 2017 18:16:14 -0700
Message-ID: <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca> <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com> <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53681 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdJOBQg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Oct 2017 21:16:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id q132so27695866wmd.2
        for <linux-ext4@vger.kernel.org>; Sat, 14 Oct 2017 18:16:35 -0700 (PDT)
In-Reply-To: <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On Fri, Oct 13, 2017 at 11:40 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> The findsuper comment was potentially misleading, as I was mixing up your
> problem with one in another thread where the partition table was clobbered.

Gotcha. Learned about it though, so it was still useful. ;)

>>      1024           0  17983724322816   95590400  4096    0  Thu Nov
>> 26 23:22:42 2015 12c2c019 1.42.6-5644
>
> This is likely to be the proper superblock, but it has a bit of a
> strange label.  Looks like a really old e2fsprogs build version?

Yes, the filesystem label name is for some reason the version of mkfs
that created it. The volume is from a Synology NAS, I assume that's
how they do things.

> No, this looks like the _start_ of a filesystem image, but there is
> no real guarantee that the blocks in the file are allocated contiguously
> in the actual filesystem, so your "dd" is unlikely to work properly.
> The filesystem itself is 773376 * 4KB ~= 3GB in size, and if it was
> originally created as a sparse file there is little chance those blocks
> were allocated contiguously.  The findsuper utility is meant to locate
> superblocks in a block device to help recover from partition table woes.

Aaah, right, got it.

> If you still have access to some of the files, you should consider to
> copy them out of the filesystem.  Next, I would recommend to make an
> LVM snapshot and run e2fsck on that to see what else you get out of it.
> Depending on the amount and type of corruption, that may take a very
> long time on a 20TB filesystem, and not be worthwhile to wait for.

I did that actually: I was able to salvage about 2.3 TB of data that
was still accessible from a read-only mount. Then, I created a
snapshot (although with mdraid, not LVM, but same idea), and fsck'ed
the filesystem: fsck found about 800GB more, but not many intact
directories. I was hoping that some of the top directories that got
lost could be found relatively intact in lost+found/ but I ended up
with a pretty flat hierarchy of things there, with directories at most
maybe 3-4 levels deep. I'll need to spend some time trying to put
pieces together from what fsck recovered.

But unfortunately there's another ~17TB of data that fsck didin't
find. That seems like a lot of data lost from just replaying a
corrupted journal... :(

Cheers,
-- 
Kilian
