From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Wed, 11 Oct 2017 07:36:31 -0700
Message-ID: <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:56146 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdJKOgx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Oct 2017 10:36:53 -0400
Received: by mail-wm0-f52.google.com with SMTP id u138so5451406wmu.4
        for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2017 07:36:53 -0700 (PDT)
In-Reply-To: <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thanks a lot for taking the time to answer my plea for help. :)

On Tue, Oct 10, 2017 at 1:36 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> If the problem is only one of the partition being misaligned compared
> to the logical volume, you can run the "findsuper" utility which is
> part of e2fsprogs *sources* (it isn't built and packaged by default).
> It will scan your block device and print out the ext2/3/4 superblocks
> that it finds, along with the *byte* offset of each one found.  You
> can use this to determine where the start of the filesystem should be.

I will give this a try, thanks. Although I don't really had any issue
to mount the filesystem r/o, which seems to indicate that there is no
misalignment issue, right?

> This is made *much* more complex if you have other LVs on the same
> storage, and the LV was increased in size over multiple iterations,
> resulting in a fragmented allocation of PEs.

Just one LV there.

>> $ ls /vol
>> ls: cannot access backup: Input/output error
>> drwxr-xr-x 2 root root 4096 Sep 28 11:10 .
>> drwxr-xr-x 4 root root 4096 Sep 14  2013 ..
>> -????????? ? ?    ?       ?            ? backup
>> [...]
>>
>> I re-remounted read-only as soon as I realized my mistake, but the
>> filesystem stayed mounted r/w for a few minutes.
>
> It sounds like this replayed a corrupted journal over the rest of your
> filesystem, leading to further corruption.

Ah I see. So even of no process was actively writing to the
filesystem, simply remounting it read-write made it replay an old
journal? I know I shouldn't have done that, but I really didn't expect
so much impact: there's probably only around 15-20% of the original
data left... :(

> My only recommendation would be to update to the latest e2fsprogs,
> since it usually fixes important issues found in older versions.

Will make sure to use the latest one.

> Seems unlikely, unless you have an LVM snapshot.

I so wish, but I don't. :(

> e2fsck is good at recovering what files are available, much better
> than other filesystem recovery tools, but it can only work with the
> data it has.

So, another question: given e2fsck doesn't complain about a missing or
damaged superblock, is there any reason why running it with an
alternative superblock (with -b) would yield different results?

Thanks!
-- 
Kilian
