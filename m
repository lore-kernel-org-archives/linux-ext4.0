From: Harshad Shirwadkar <harshads@google.com>
Subject: Re: [PATCH] ext4: Add support for online resizing with bigalloc.
Date: Mon, 30 Oct 2017 14:01:46 -0700
Message-ID: <CAMCMpYJfJECSUOr_bp+k3o=jH18ShkHcOT9fK0o=FaHZkwUtZA@mail.gmail.com>
References: <20171025044208.86545-1-harshads@google.com> <20171029150609.ngislvfqc3gwysuy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:46982 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932794AbdJ3VBs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Oct 2017 17:01:48 -0400
Received: by mail-yw0-f194.google.com with SMTP id t71so12859855ywc.3
        for <linux-ext4@vger.kernel.org>; Mon, 30 Oct 2017 14:01:48 -0700 (PDT)
In-Reply-To: <20171029150609.ngislvfqc3gwysuy@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 29, 2017 at 8:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> (If you work for a company which supports enterprise distros, please
> keep reading.  I have a question for you below.)
>
> On Tue, Oct 24, 2017 at 09:42:08PM -0700, harshads wrote:
>> This patch adds support for online resizing on bigalloc file system by
>> implementing EXT4_IOC_RESIZE_FS ioctl. Old resize interfaces (add
>> block groups and extend last block group) are left untouched. Tests
>> performed with cluster sizes of 1, 2, 4 and 8 blocks (of size 4k) per
>> cluster. I will add these tests to xfstests.
>>
>> Signed-off-by: Harshad Shirwadkar <harshads@google.com>
>
> Can you talk more about what sort of testing you have done?  What file
> system sizes did you use?

In my testing, I have tried to ensure that all different code paths
that resize IOCTL triggers get executed. At a high level, these
different code paths are - 1) extending last block group, 2) adding
new block groups 3) conversion of file system to meta-bg.
I performed tests with combinations of different cluster sizes (1, 2,
4, 8 block(s) per cluster) and different file system sizes. Following
csv table lists all the tests that were performed and were successful
with new resize IOCTL.

Cluster size (# 4K blocks), Original Size(# clusters), Final Size(# clusters)
1, 16384(64M), 24576(96M)
1, 24576(96M), 32767(128M)
1, 24576(96M), 32768(128M)
1, 24576(96M), 32769(128M)
1, 24576(96M), 49152(192M)
1, 24576(96M), 65536(256M)
1, 24576(96M), 491521(1.9G)
1, 24576(96M), 507904(~1.9G)
1, 24576(96M), 527488(2G)
1, 24576(96M), 5274880(20G)
2, 16384(128M), 24576(192M)
2, 24576(192M), 32767(256M)
2, 24576(192M), 32768(256M)
2, 24576(192M), 32769(256M)
2, 24576(192M), 49152(384M)
2, 24576(192M), 65536(512M)
2, 24576(192M), 491521(3.8G)
2, 24576(192M), 507904(3.8G)
2, 24576(192M), 527488(4G)
2, 24576(192M), 5274880(40G)
4, 16384(256M), 24576(384M)
4, 24576(384M), 32767(512M)
4, 24576(384M), 32768(512M)
4, 24576(384M), 32769(512M)
4, 24576(384M), 49152(768M)
4, 24576(384M), 65536(1G)
4, 24576(384M), 491521(7.6G)
4, 24576(384M), 507904(7.6G)
4, 24576(384M), 527488(8G)
4, 24576(384M), 5274880(80G)
8, 16384(512M), 24576(768M)
8, 24576(768M), 32767(1G)
8, 24576(768M), 32768(1G)
8, 24576(768M), 32769(1G)
8, 24576(768M), 49152(1.5G)
8, 24576(768M), 65536(2G)
8, 24576(768M), 491521(15.2G)
8, 24576(768M), 507904(15.2G)
8, 24576(768M), 527488(16G)
8, 24576(768M), 5274880(160G)

>
> I'm guessing you didn't test the old resize ioctls, because they are
> currently broken.  I did a quick test because the code paths that are
> touched by this patch are also used by the old resize ioctls, and the
> following is failing:

Yes, you are right. Also in the latest kernel, there are code-paths
that are present only for the old resize IOCTLs and I have not touch
them yet. Let's see what others have to say and then I can fix those
if required.

Thanks,
Harshad.

>
> mke2fs -t ext4 -Fq /dev/vdc 1G
> mount /dev/vdc
> export RESIZE2FS_KERNEL_VERSION=3.2.0
> strace -o /tmp/st-$RESIZE2FS_KERNEL_VERSION resize2fs /dev/vdc 5G
> umount /dev/vdc
>
> From a quick check, and it looks like this broke sometime between 4.1
> and 4.4.  It works on 3.18 and 4.1, and but it failed for me in 4.4.
>
> The 4.1 kernel was released in June 2015, and 4.4 kernel was released
> in January 2016.  E2fsprogs v1.42 started using the new resize ioctl,
> which was released in November 2011.  So if we take an enterprise
> distro which was initially released > 5-6 years ago, and it upgrades
> to a kernel newer than 4.1-4.4, the resize2fs from e2fsprogs 1.41.x
> (or earlier) will not be able to do online resize.
>
> The question is whether or not we care at this point.  We could use
> the observation that our lack of good testing, sometime in second half
> of 2015, we broke online resize backwards compatibility with e2fsprogs
> from before 2011, given that no one screamed --- perhaps we can just
> rip out support for the old resize ioctls entirely.
>
> Or we can try to fix the old resize ioctl's, and then add better
> resize testing to xfstests.
>
> What do the maintainers from the enterprise distro's think?
>
>                                                 - Ted
