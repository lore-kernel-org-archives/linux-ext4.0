From: Curt Wohlgemuth <curtw@google.com>
Subject: Odd "leak" of extent info into data blocks?
Date: Sat, 22 Aug 2009 16:10:56 -0700
Message-ID: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:38344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218AbZHVXK5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Aug 2009 19:10:57 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id n7MNAxMj018453
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 16:10:59 -0700
Received: from pxi29 (pxi29.prod.google.com [10.243.27.29])
	by wpaz37.hot.corp.google.com with ESMTP id n7MNAukv000481
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 16:10:57 -0700
Received: by pxi29 with SMTP id 29so4634973pxi.30
        for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 16:10:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On the off chance that this sounds familiar to anyone out there...

I've got a situation in which data files written by an application are
showing very occasional checksum errors sometimes.  The data files are
all around 8MB long, written using O_DIRECT into fallocated space.
(The entire fallocated space for the example file below is written to
with valid data; i.e., no holes, no truncation, no uninitialized
extents.)

When these occasional checksum failures show up, the data in the files
is rather odd.  I've seen 4 cases of this so far, and the "bad" data
always starts on a block boundary, and always has the first 12 bytes
that are identical to what an extent header would look like (for a
header at the start of a block of extents or extent indexes):

Here's the "od -Ad -x" output from one such file:

             8388608 f30a 0000 0154 0000 0000 0000 0000 0000

(I.e., the first 2 bytes are EXT4_EXT_MAGIC, and bytes 4-5 are 0x154,
or what eh_max would be for a block size of 4096 bytes.)

In this case, the "bad" data starts at block 2048.  Two cases have
this pattern at block 2048; two at block 2050.  A syscall trace of one
such corrupted file shows that this block was written with a single
write encompassing many adjacent blocks:

         write(fd=10, size=192512, offset=8204288)

The file in question above has only two (in-inode) extents, which I
verified look valid.  The block in question (2048) above is covered by
the second extent:  logical blocks 2037-2050.

I've seen the amount of "bad" data (including the "extent header"
above) to be pretty variable: between 70 and 800 bytes; I haven't been
able to correlate the rest of the bad data to any particular ext4 data
structures.

My guess is that a block of extents from a truncated or removed file
was reused for data for this file, and somehow was not written
correctly.  This seems (slightly) more plausible to me than the extent
metadata of an existing file was "leaked" into this one.

Does any of this ring a bell to anybody?

Thanks,
Curt
