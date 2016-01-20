From: William Jannen <wjannen@cs.stonybrook.edu>
Subject: slower sequential read when data is overwritten
Date: Wed, 20 Jan 2016 14:45:32 -0500
Message-ID: <CA+hswQC6g4X=14dJR2OGmFJ15RLhMO7RqAjdigPQJqaXwg5RgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36021 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbcATTpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2016 14:45:34 -0500
Received: by mail-lb0-f171.google.com with SMTP id oh2so11215659lbb.3
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2016 11:45:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We were recently trying to evaluate the trade-offs between
update-in-place and no-overwrite file system designs, and on ext4 I
produced some data that does not match my understanding of ext4
internals. I am wondering if this is known behavior and what is going
on within the ext4 data structures that would lead to these results.
The experiment I was running had four phases:

Write an 8 GiB file sequentially (in 4 MiB chunks).
Read back the 8 GiB file sequentially (in 4 MiB chunks).
Overwrite 10,000 4KiB blocks within the 8GiB file (block aligned
offsets chosen uniformly at random)
Read back the 8 GiB file sequentially (in 4 MiB chunks).

We start with an empty file system on its own partition. Between
phases, we drop the caches and we unmount/mount the file system to
ensure that the reads are all cold-cache. We ran all experiments using
linux 3.11.10, on an ATA disk.

We expected the performance of both of the sequential reads to be
indistinguishable (based on our assumption that the data blocks are
updated in place, so the random overwrites would have no impact on
data placement).

What we found instead was that the second sequential read had a ~10% slowdown.

When I looked at the blktrace output from the random writes, I did not
notice anything that I thought was suspicious. When I looked at the
blktrace output from the 2nd sequential read, it appears as if there
are some small reads performed out of order with respect to LBA.

I have linked the seekwatcher I/O output for each of the phases (green
indicates a write, and blue indicates a read). I have also attached a
zoomed-in detail of the second sequential read (to the best
granularity seekwatcher allowed). It covers the first second of the
second sequential read.

Internally, what data structures are changed by an overwrite that
would cause different read patterns? The file is very large and spans
many block groups, but my understanding is that the size and
allocation information would not change when just overwriting blocks.
And the only changes to the file system metadata that I can think of
would be the inode's mtime, atime, and ctime. No extents should be
split,

This is my first time posting to the list, so please let me know if
there is anything else I should provide or if there is any etiquette I
am violating. I appreciate any insights.

Graphs:

Sequential write: https://drive.google.com/open?id=0B8HuLLVp2h86SmxmeVFGczFFaEU

Sequential read of sequentially-written data:
https://drive.google.com/open?id=0B8HuLLVp2h86SmxmeVFGczFFaEU

Random 4K-aligned overwrites:
https://drive.google.com/open?id=0B8HuLLVp2h86Slo5X1BjUkVxRUE

Sequential read of randomly-overwritten data:
https://drive.google.com/open?id=0B8HuLLVp2h86UnlzNkJvdG1HYUk
  (Detail of first 1 second:
https://drive.google.com/open?id=0B8HuLLVp2h86R0IzV01Sd3M5ejA)

Thank you,
Bill
