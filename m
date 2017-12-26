From: Jayashree Mohan <jayashree2912@gmail.com>
Subject: Incorrect block count during stat of a file if fallocate follows a
 buffered write.
Date: Tue, 26 Dec 2017 16:07:22 -0600
Message-ID: <CA+EzBbAmiKdBMBZRFU_YXVj1CS-U-SAB=xjR82Xu6qou+EN5jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: tytso@mit.edu,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:42466 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLZWHX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Dec 2017 17:07:23 -0500
Received: by mail-vk0-f43.google.com with SMTP id 189so22191288vkc.9
        for <linux-ext4@vger.kernel.org>; Tue, 26 Dec 2017 14:07:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I am Jayashree Mohan, a PhD student at the University of Texas at
Austin, working with Prof. Vijay Chidambaram. I've been working on the
Crashmonkey project, which is a test harness for file system crash
consistency[1].

While trying to reproduce some of the reported bugs on ext4 using
CrashMonkey we stumbled upon the following issue:
Whenever a fallocate follows a buffered write(delayed allocated), with
fallocate overlapping with a certain range of the write, the block
count reported by stat of the file is incorrect until the write is
resolved.

Consider the following workload(The number within the braces indicate
the start and end offsets)
1. Write (79581 - 136029)
2. Fallocate (46385 - 92886)

If we now stat the file, the result is as follows :

1. Stat after Write (79581 - 136029)
  File: '/mnt/5gbdisk/only-fallocate.txt'
  Size: 136029        Blocks: 120        IO Block: 4096   regular file
Device: 810h/2064d    Inode: 14          Links: 1

2. Stat after fallocate (46385 - 92886)
  File: '/mnt/5gbdisk/only-fallocate.txt'
  Size: 136029        Blocks: 216        IO Block: 4096   regular file
Device: 810h/2064d    Inode: 14          Links: 1

3. Stat 30 seconds later, after the checkpoint
  File: '/mnt/5gbdisk/only-fallocate.txt'
  Size: 136029        Blocks: 184        IO Block: 4096   regular file
Device: 810h/2064d    Inode: 14          Links: 1

So we see here that the actual block count should be 184, as there is
an overlapping region between the buffered write(120 blocks) and
fallocate(96 blocks). Note that there are 32 overlapping blocks in the
above workload(Blocks are in units of 512B). However until the write
is resolved, the block count is shown to be 216, which is just the sum
of the blocks reserved for writes and fallocate(120+96=216), without
consideration for the overlap(120+96-32 = 184).

So, if any program stats the file before the write is resolved (the 30
sec checkpoint interval), the block count returned seems to be
incorrect.

Let me know if I am missing some detail.

[1] https://github.com/utsaslab/crashmonkey

Thanks,
Jayashree
