From: thanumalayan mad <madthanu@gmail.com>
Subject: e2fsck exit codes
Date: Mon, 13 Feb 2017 16:59:49 -0800
Message-ID: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
Reply-To: madthanu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:35363 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdBNBAK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2017 20:00:10 -0500
Received: by mail-ot0-f173.google.com with SMTP id 65so81812267otq.2
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 17:00:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I'm trying to figure out a way to tell fsck to inform me and abort if
it suspects disk corruption, but continue otherwise. I thought I knew
how to do this, but I don't.

I did the following experiment: I created a new file system using
mkfs.ext4, mounted it, ran a simple workload on it, and hard-rebooted
the machine during the middle of the workload. After rebooting the
machine, I ran "fsck.ext4 -fy" on the partition. Fsck complains about
wrong inode counts and block counts, and exits with code 1.

Is this the expected behavior? I retried the experiment on a couple of
machines, so I know its not an actual corrupted-drive issue. The
following is an example output of fsck:

root@lappy:/home/madthanu# fsck.ext4 -f /dev/sda8
e2fsck 1.42.12 (29-Aug-2014)
/dev/sda8: recovering journal
Clearing orphaned inode 6063 (uid=0, gid=0, mode=0100664, size=2377)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (2710767, counted=2681703).
Fix<y>? no
Free inodes count wrong (698998, counted=684135).
Fix<y>? no
/dev/sda8: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda8: 10/699008 files (80.0% non-contiguous), 83473/2794240 blocks

root@lappy:/home/madthanu# echo $?
1

root@lappy:/home/madthanu# fsck.ext4 -fy /dev/sda8
e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (2710767, counted=2681703).
Fix? yes
Free inodes count wrong (698998, counted=684135).
Fix? yes
/dev/sda8: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda8: 14873/699008 files (0.1% non-contiguous), 112537/2794240 blocks

root@lappy:/home/madthanu# echo $?
1

Is there a correct way to do that? "fsck.ext4 -p" does continue
without complaining much, but as I understand it, it might continue
even if there was disk corruption (so long as fsck has enough
confidence that it restored the correct version of corrupted metadata,
it'll continue).

Thanks,
Thanu

---
(Thanumalayan Sankaranarayana Pillai)
