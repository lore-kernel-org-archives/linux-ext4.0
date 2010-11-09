From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC] Self healing extent map OR opportunistic de-fragmentation
Date: Tue, 9 Nov 2010 06:14:25 +0200
Message-ID: <AANLkTinsZRSU46J0JXm2A=u=d-JpQfdYnk0oHf3NC9O_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37562 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0KIEO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Nov 2010 23:14:26 -0500
Received: by vws13 with SMTP id 13so2683144vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Nov 2010 20:14:26 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I would like to propose a simple idea how to automatically de-fragment a file.
How difficult the implementation is, I do not know yet,
but since you talked about modifying the delayed allocation path,
I thought the idea was worth mentioning.

The idea is to use every page write as an opportunity to reduce file
fragmentation
(no extra I/O charges included, no donor inodes, etc..).

There are many strategies to do this, but the simplest one would be
something like this:

Extents A and B are logically adjacent, but not physically adjacent.
When re-writing to first block of extent B, try to extend extent A and
if that fails,
fall back to writing to first block of extent B.

Another simple strategy is:
When about to re-write all blocks of extents A and B, try to allocate
a new single extent
for writing all the blocks and if that fails, fall back to writing to A and B.

The biggest change of course is the notion that an already mapped
block may still need to be allocated
(not a new notion to me) and that existing blocks may need to be freed
on flush_alloc_da_page().
As I told you about snapshots, in data!=ordered, that could lead to
data corruption in existing file
(the uninitialized extent flag is not sufficient information when
changing a block's mapping).

However, if you do intend to follow through with your plan for
flushing metadata in end_io,
I believe that you will then already have enough information in-memory
to achieve
opportunistic de-fragmentation for the same price.

The use case for this, besides healing fragmentation caused by
snapshots move-on-rewrite,
is an highly fragmented ext2/3 fs, which was mounted as ext4.
ext2/3 old files are slowly being deleted while new (still fragmented)
extent mapped files are being created.
This viscous cycle cannot end before there is enough contiguous free
space for writing new files,
which may never happen. Online de-fragmentation will not help in this
case either.
With opportunistic de-fragmentation, if the extent mapped files are
being re-written, the health
of the file system will constantly improve over time.
BTW, Is this use case relevant for upgraded google chunk servers?

Amir.
