From: Jayashree Mohan <jayashree2912@gmail.com>
Subject: Re: Incorrect block count during stat of a file if fallocate follows
 a buffered write.
Date: Tue, 2 Jan 2018 11:39:22 -0600
Message-ID: <CA+EzBbAbdJAU4v_Wb5c1kkgWA=fU0HLz_XmV9Y4NUit1HUiGeQ@mail.gmail.com>
References: <CA+EzBbAmiKdBMBZRFU_YXVj1CS-U-SAB=xjR82Xu6qou+EN5jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:37648 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbeABRjX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jan 2018 12:39:23 -0500
Received: by mail-vk0-f41.google.com with SMTP id n2so25304884vkf.4
        for <linux-ext4@vger.kernel.org>; Tue, 02 Jan 2018 09:39:23 -0800 (PST)
In-Reply-To: <CA+EzBbAmiKdBMBZRFU_YXVj1CS-U-SAB=xjR82Xu6qou+EN5jQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
I wasn't sure if you missed this mail in your inbox. So I wanted to
send a gentle reminder about the same.

On Tue, Dec 26, 2017 at 4:07 PM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
> Hi,
> I am Jayashree Mohan, a PhD student at the University of Texas at
> Austin, working with Prof. Vijay Chidambaram. I've been working on the
> Crashmonkey project, which is a test harness for file system crash
> consistency[1].
>
> While trying to reproduce some of the reported bugs on ext4 using
> CrashMonkey we stumbled upon the following issue:
> Whenever a fallocate follows a buffered write(delayed allocated), with
> fallocate overlapping with a certain range of the write, the block
> count reported by stat of the file is incorrect until the write is
> resolved.
>
> Consider the following workload(The number within the braces indicate
> the start and end offsets)
> 1. Write (79581 - 136029)
> 2. Fallocate (46385 - 92886)
>
> If we now stat the file, the result is as follows :
>
> 1. Stat after Write (79581 - 136029)
>   File: '/mnt/5gbdisk/only-fallocate.txt'
>   Size: 136029        Blocks: 120        IO Block: 4096   regular file
> Device: 810h/2064d    Inode: 14          Links: 1
>
> 2. Stat after fallocate (46385 - 92886)
>   File: '/mnt/5gbdisk/only-fallocate.txt'
>   Size: 136029        Blocks: 216        IO Block: 4096   regular file
> Device: 810h/2064d    Inode: 14          Links: 1
>
> 3. Stat 30 seconds later, after the checkpoint
>   File: '/mnt/5gbdisk/only-fallocate.txt'
>   Size: 136029        Blocks: 184        IO Block: 4096   regular file
> Device: 810h/2064d    Inode: 14          Links: 1
>
> So we see here that the actual block count should be 184, as there is
> an overlapping region between the buffered write(120 blocks) and
> fallocate(96 blocks). Note that there are 32 overlapping blocks in the
> above workload(Blocks are in units of 512B). However until the write
> is resolved, the block count is shown to be 216, which is just the sum
> of the blocks reserved for writes and fallocate(120+96=216), without
> consideration for the overlap(120+96-32 = 184).
>
> So, if any program stats the file before the write is resolved (the 30
> sec checkpoint interval), the block count returned seems to be
> incorrect.
>
> Let me know if I am missing some detail.
>
> [1] https://github.com/utsaslab/crashmonkey
>
> Thanks,
> Jayashree
