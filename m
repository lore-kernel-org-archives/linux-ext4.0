From: Jiaying Zhang <jiayingz@google.com>
Subject: ext4 DIO read performance issue on SSD
Date: Fri, 9 Oct 2009 16:34:08 -0700
Message-ID: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@google.com>, Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:25566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZJIXfS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 19:35:18 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n99NYAuY009999
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 16:34:11 -0700
Received: from ywh16 (ywh16.prod.google.com [10.192.8.16])
	by wpaz21.hot.corp.google.com with ESMTP id n99NY8k4032438
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 16:34:09 -0700
Received: by ywh16 with SMTP id 16so6668440ywh.13
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2009 16:34:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Recently, we are evaluating the ext4 performance on a high speed SSD.
One problem we found is that ext4 performance doesn't scale well with
multiple threads or multiple AIOs reading a single file with O_DIRECT.
E.g., with 4k block size, multiple-thread DIO AIO random read on ext4
can lose up to 50% throughput compared to the results we get via RAW IO.

After some initial analysis, we think the ext4 performance problem is caused
by the use of i_mutex lock during DIO read. I.e., during DIO read, we grab
the i_mutex lock in __blockdev_direct_IO because ext4 uses the default
DIO_LOCKING from the generic fs code. I did a quick test by calling
blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 DIO read
got 99% performance as raw IO.

As we understand, the reason why we want to take i_mutex lock during DIO
read is to prevent it from accessing stale data that may be exposed by a
simultaneous write. We saw that Mingming Cao has implemented a patch set
with which when a get_block request comes from direct write, ext4 only
allocates or splits an uninitialized extent. That uninitialized extent
will be marked as initialized at the end_io callback. We are wondering
whether we can extend this idea to buffer write as well. I.e., we always
allocate an uninitialized extent first during any write and convert it
as initialized at the time of end_io callback. This will eliminate the need
to hold i_mutex lock during direct read because a DIO read should never get
a block marked initialized before the block has been written with new data.

We haven't implemented anything yet because we want to ask here first to
see whether this proposal makes sense to you.

Regards,

Jiaying
