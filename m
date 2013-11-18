From: Martin Boutin <martboutin@gmail.com>
Subject: Filesystem writes on RAID5 too slow
Date: Mon, 18 Nov 2013 11:02:15 -0500
Message-ID: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Kernel.org-Linux-XFS" <linux-xfs@vger.kernel.org>,
	"Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>
To: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f195.google.com ([209.85.128.195]:38175 "EHLO
	mail-ve0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3KRQCQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Nov 2013 11:02:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear list,

I am writing about an apparent issue (or maybe it is normal, that's my
question) regarding filesystem write speed in in a linux raid device.
More specifically, I have linux-3.10.10 running in an Intel Haswell
embedded system with 3 HDDs in a RAID-5 configuration.
The hard disks have 4k physical sectors which are reported as 512
logical size. I made sure the partitions underlying the raid device
start at sector 2048.

The RAID device has version 1.2 metadata and 4k (bytes) of data
offset, therefore the data should also be 4k aligned. The raid chunk
size is 512K.

I have the md0 raid device formatted as ext3 with a 4k block size, and
stride and stripes correctly chosen to match the raid chunk size, that
is, stride=128,stripe-width=256.

While I was working in a small university project, I just noticed that
the write speeds when using a filesystem over raid are *much* slower
than when writing directly to the raid device (or even compared to
filesystem read speeds).

The command line for measuring filesystem read and write speeds was:

$ dd if=/tmp/diskmnt/filerd.zero of=/dev/null bs=1M count=1000 iflag=direct
$ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct

The command line for measuring raw read and write speeds was:

$ dd if=/dev/md0 of=/dev/null bs=1M count=1000 iflag=direct
$ dd if=/dev/zero of=/dev/md0 bs=1M count=1000 oflag=direct

Here are some speed measures using dd (an average of 20 runs).:

device       raw/fs  mode   speed (MB/s)    slowdown (%)
/dev/md0    raw    read    207
/dev/md0    raw    write    209
/dev/md1    raw    read    214
/dev/md1    raw    write    212

/dev/md0    xfs    read    188    9
/dev/md0    xfs    write    35    83

/dev/md1    ext3    read    199    7
/dev/md1    ext3    write    36    83

/dev/md0    ufs    read    212    0
/dev/md0    ufs    write    53    75

/dev/md0    ext2    read    202    2
/dev/md0    ext2    write    34    84

Is it possible that the filesystem has such enormous impact in the
write speed? We are talking about a slowdown of 80%!!! Even a
filesystem as simple as ufs has a slowdown of 75%! What am I missing?

Thank you,
-- 
Martin Boutin
