From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Wed, 18 Oct 2017 11:39:43 -0700
Message-ID: <CAJz=VjG8J4W52NhUvB9AE+EYAboAkazan+jZM-Lc15HRmWCD0w@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca> <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca> <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
 <20171015124800.zjsqu623rivp27qv@thunk.org> <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
 <20171016012852.pz63e7hd67c7ipy5@thunk.org> <CAJz=VjF_BGVuCrhDbQA7H3nwVLVF2PyWppwCe5mV6DDPAZ6UWQ@mail.gmail.com>
 <20171017164804.nh5e5x4dwfvmk25c@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45855 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdJRSkF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Oct 2017 14:40:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id q124so11658938wmb.0
        for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2017 11:40:05 -0700 (PDT)
In-Reply-To: <20171017164804.nh5e5x4dwfvmk25c@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 17, 2017 at 9:48 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Unfortunately, if this is what happened, then the true damage was done
> when the file system was remounted read/write, and because the
> allocation bitmaps were incorrect, portions of the inode table were
> overwritten with file data.  (As I mentioned, with modern file systems
> there is a safety check which is now enabled by default which will
> notice when there is an attempt to allocate blocks that are part of
> the inode table, and stop this Very Bad Thing from happening.  It does
> take a tiny bit of extra CPU overhead, but we ultimately decided It
> Was Worth It.  Unfortunately, it was not enabled by default in the
> 3.10 kernel.)
>
> There's not really any recovery possible in that case, unfortunately.  :-(

Argh.

Well, thanks for the explanation, at least I think I have a better
understanding of how things unfolded, now. I'm glad that this safety
check is enabled by default now, and I'm gonna keep repeating myself
"never ever mount read-write when you have a doubt" while I'm waiting
for the carving tools to scan my blocks.

Thanks again!
-- 
Kilian
