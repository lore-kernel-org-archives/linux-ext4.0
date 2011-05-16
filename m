From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3 v2] Add qcow2 support
Date: Mon, 16 May 2011 17:43:21 +0200
Message-ID: <1305560604-31877-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1EPPng (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:43:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

it has been a while since I have posted this last time. Noone seems to care
very much, but I think this is really useful feature for e2image so I give
it a try once more.

These patches adds a qcow2 support to e2image. We all know how painful! is
using e2image on huge filesystems, especially when you need to transfer 
the images. Qcow2 images are different, due to its format it is not sparse
yet, it is space efficient because it packs all used file system metadata
close together, hence avoiding sparseness. So it is really easy to generate,
trasfer and convert qcow2 images.

Now in order to check the image, or use debugfs you have to convert it into
the qcow2 image. Unlike targzipping it is *A LOT* faster, however you still
have to have the space for the raw image, but I do not see that as a big
problem and hey it is a HUGE improvement from what we have today! However
it would be possible to create new iomanager which does understand qcow2
format directly, but I am not going to do that, since there is no library
and it would mean copy/change and maintain part of qemu code and I do not
think this is worth it. But anyone interested in this, feel free to look
at it.

Also, remember that if you really do not want to convert the image
because of file size limit, or whatever, you can always use qemu-nbd to
attach qcow2 image into nbd block device and use that as regular device.


[ Note that the last patch (#3) might not make it into the list, because
it contains new tests and file system images and it is 1.2MB big. If you
would like to see it please let me know and I will send it to you directly ]

Now here are some numbers:
--------------------------

I have 6TB raid composed of four drives and I flooded it with lots and
lots of files (copying /usr/share over and over again) and even created
some big files (1M, 20M, 1G, 10G) so the number of used inodes on the
filesystem is 10928139. I am using e2fsck form top of the master branch.

Before each step I run:
sync; echo 3 > /proc/sys/vm/drop_caches

exporting raw image:
time .//misc/e2image -r /dev/mapper/vg_raid-lv_stripe image.raw

        real    12m3.798s
        user    2m53.116s
        sys     3m38.430s

        6,0G    image.raw

exporting qcow2 image
time .//misc/e2image -Q /dev/mapper/vg_raid-lv_stripe image.qcow2
e2image 1.41.14 (22-Dec-2010)

        real    11m55.574s
        user    2m50.521s
        sys     3m41.515s

        6,1G    image.qcow2

So we can see that the running time is essentially the same, so there is
no crazy overhead in creating qcow2 image. Note that qcow2 image is
slightly bigger because of all the qcow2 related metadata and it's size
really depends on the size of the device. Also I tried to see how long
does it take to export bzipped2 raw image, but it is running almost one
day now, so it is not even comparable.

e2fsck on the device:
time .//e2fsck/e2fsck -fn /dev/mapper/vg_raid-lv_stripe

        real    3m9.400s
        user    0m47.558s
        sys     0m15.098s

e2fsck on the raw image:
time .//e2fsck/e2fsck -fn image.raw

        real    2m36.767s
        user    0m47.613s
        sys     0m8.403s

We can see that e2fsck on the raw image is a bit faster, but that is
obvious since the drive does not have to seek so much (right?).

Now converting qcow2 image into raw image:
time .//misc/e2image -r image.qcow2 image.qcow2.raw

        real    1m23.486s
        user    0m0.704s
        sys     0m22.574s

It is hard to say if it is "quite fast" or not. But I would say it is
not terribly slow either. Just out of curiosity, I have tried to convert
raw->qcow2 with qemu-img convert tool:

time qemu-img convert -O raw image.qcow2 image.qemu.raw
..it is running almost an hour now, so it is not comparable as well :)



Please review!

Thanks!
-Lukas


-- 
[PATCH 1/3 v2] e2image: Add support for qcow2 format
[PATCH 2/3 v2] e2image: Support for conversion QCOW2 image into raw
[PATCH 3/3 v2] tests: New i_e2image test to validate image

 lib/ext2fs/Makefile.in             |    4 +-
 lib/ext2fs/bitops.h                |    4 +
 lib/ext2fs/e2image.h               |   21 +-
 lib/ext2fs/qcow2.c                 |  228 +++++++++++
 lib/ext2fs/qcow2.h                 |   94 +++++
 misc/e2image.8.in                  |   51 +++-
 misc/e2image.c                     |  766 +++++++++++++++++++++++++++++++++---
 tests/i_e2image/i_e2image.md5      |   15 +
 tests/i_e2image/image1024.orig.bz2 |  Bin 0 -> 322312 bytes
 tests/i_e2image/image2048.orig.bz2 |  Bin 0 -> 321388 bytes
 tests/i_e2image/image4096.orig.bz2 |  Bin 0 -> 312342 bytes
 tests/i_e2image/script             |   57 +++
 tests/test_config                  |    1 +
 13 files changed, 1168 insertions(+), 73 deletions(-)
