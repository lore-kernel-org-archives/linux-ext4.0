From: Ronen Shitrit <rshitrit@gmail.com>
Subject: resize getting out of memory on 32bit machine
Date: Mon, 16 Sep 2013 16:48:01 +0200
Message-ID: <CAHFzjDAGNTdusKhtLuoCppctme1sprurzSLr_-=35pf5mry+ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40076 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3IPOsC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Sep 2013 10:48:02 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so4196408pbb.28
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2013 07:48:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I'm trying to resize an ext4 filesystem from 10TB to 25TB.
I'm running on a 32bit machine and using latest e2fsprogs-1.42.8 and kernel 3.8.

When doing so I'm getting a memory allocation failure:

  $ > resize2fs -d 255 -f /dev/md1 25T
  resize2fs 1.42.8 (20-Jun-2013)
  Resizing the filesystem on /dev/md1 to 6710886400 (4k) blocks.
  read_bitmaps: Memory used: 160k/373856k (40k/121k), time: 37.14/ 0.44/ 0.23
  read_bitmaps: I/O read: 21MB, write: 0MB, rate: 0.57MB/s
  fix_uninit_block_bitmaps 1: Memory used: 160k/373856k (40k/121k),
time: 78.82/78.75/ 0.05
  adjust_superblock: Memory used: 160k/2127584k (42k/119k), time:
51.05/50.58/ 0.46
  fix_uninit_block_bitmaps 2: Memory used: 160k/2127584k (42k/119k),
time: 197.02/196.95/ 0.02
  /mnt/e2fsprogs-1.42.8/resize/resize2fs: Memory allocation failed
while trying to resize /dev/md1
  Please run 'e2fsck -fy /dev/md1' to fix the filesystem
  after the aborted resize operation.

Above shows 2G+ mem allocations. In the failure case the allocations
gets close to 3GB, which can't  be handle on a 32bit machines.
Looking into the resize code I see the big allocations are a result of
the bitmap block array allocations. I also found some threads that
already reported similar issues.


Using BIGALLOC option is much more memory efficient, and I can
overcome the resize, but I have my doubts about it:
1. It seems to break compatibility to older existing FS without
BIGALLOC. if I will need to move an existing EXT4 disk array to this
machine I wouldn't be able to resize it as there is no tune2fs support
for BIGALLOC, am I right?
2. There are some warning notes on the ext4 wiki about resize with
BIGALLOC which make me wonder if it will be wise to use it...


I also noticed that there is an option to use rb-tree instead of block
array for managing bitmaps, which seems to be much more memory
efficient and still dont break compatibility with existing FS.
However I dont see any option to use it for resize, any reason for this?


Thanks for your advice.
