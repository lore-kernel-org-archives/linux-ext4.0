From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Tue, 17 Oct 2017 08:32:52 -0700
Message-ID: <CAJz=VjF_BGVuCrhDbQA7H3nwVLVF2PyWppwCe5mV6DDPAZ6UWQ@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca> <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca> <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
 <20171015124800.zjsqu623rivp27qv@thunk.org> <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
 <20171016012852.pz63e7hd67c7ipy5@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52214 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763147AbdJQPdO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Oct 2017 11:33:14 -0400
Received: by mail-wm0-f65.google.com with SMTP id f4so4785778wme.0
        for <linux-ext4@vger.kernel.org>; Tue, 17 Oct 2017 08:33:13 -0700 (PDT)
In-Reply-To: <20171016012852.pz63e7hd67c7ipy5@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 15, 2017 at 6:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> Is there any possibility that the filesystem could appear to be
>> resized (extended) with the actual inode table still referencing the
>> pre-resize one?
>
> It's possible, I suppose.  If the vendor script unmounted the file
> system and then attempted to run e2fsck -fy to fix the file system,
> perhaps.  In which case the damage could also have been done by the
> e2fsck -fy run, depending on how badly the file system was corrupted
> before this whole procedure was started.

In that case, is there any way to re-shrink the filesystem to its
pre-expansion size, and try to read the pre-expansion inode table from
another superblock? Or did the r/w remount over-write all the existing
superblocks with the same new, corrupted information?

> But that would imply that the NAS box would have to stop serving the
> file system, and it would have been pretty obviously an off-line
> procedure.

Well, I have this elements that point in that direction:
1. the online resize2fs tentative aborted (I have that logged),
2. the filesystem has been expanded (I can see it now),
3. it definitely stopped serving the filesystem at some point.


Cheers,
-- 
Kilian
