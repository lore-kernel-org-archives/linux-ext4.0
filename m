From: Steve Brown <sbrown25@gmail.com>
Subject: ext4 benchmark questions
Date: Thu, 22 Apr 2010 16:38:07 -0500
Message-ID: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51541 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0DVViO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Apr 2010 17:38:14 -0400
Received: by gwj19 with SMTP id 19so2308583gwj.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Apr 2010 14:38:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm in the process of evaluating various storage options for a large
array (12TB) I'm creating.  First. I will preface all of this by
saying that I understand the note in the kernel docs about comparing
file systems under various workloads, and I acknowledge that my exact
methodology isn't perfect.  But it works for what I'm doing. :)  This
array will be used for storage of large media files (up to 20-30GB per
file).  I'm testing using iozone with various file sizes ranging from
4GB to 32GB.  I'm pretty much settled on a RAID50 (128kb stripe size)
running ext4 on top of LVM (for snapshots, future expansion, etc.).
I'm running kernel 2.6.33.2, e2fsprogs 1.41.11 and util-linux-ng 2.16.

The file system in question was created with the following options:

mkfs -t ext4 -T large -i 524288 -b 4096 -I 256 -E
stride=32,stripe-width=192 /dev/vg/lv

Currently, I'm testing the effect of various mount options on an ext4
file system and my results are not what I would have expected based on
the docs I have read.  I wanted to bounce some of them off the list to
find out if I'm completely missing something, or if my expectations
were off.

I'll start with the craziest one: noatime.  Everything I have read
says that the noatime option should increase both read and write
performance.  My results are finding that write speeds are comparable
with or without this option, but read speeds are significantly faster
*without* the noatime option.  For example, a 16GB file reads about
210MB/s with noatime but reads closer to 250MB/s without the noatime
option.

Next is the write barrier.  I'm an in a fully battery-backed
environment, so I'm not worried about disabling it.  From my testing,
setting barrier=0 will improve write performance on large files
(>10GB), but hurts performance on smaller files (<10GB).  Read
performance is effected similarly.  Is this to be expected with files
of this size?

Next is the data option.  I am seeing a significant increase in read
performance when using data=ordered vs data=writeback.  Reading is as
much as 20% faster when using data=ordered.  The difference in write
performance is almost none with this option.

Finally is the commit option.  I did my testing mounting with commit=5
and commit=90.  While my read performance increased with commit=90, my
write performance improved by as much as 30% or more with commit=5.

As I said, I'm looking for some help interpreting these results more
than anything.  Any insight into these results that can be provided
would be appreciated.

Steve
