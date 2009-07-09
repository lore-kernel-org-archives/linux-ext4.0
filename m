From: Jason Gunthorpe <jgunthorpe@gmail.com>
Subject: ext4, AIO and new files?
Date: Wed, 8 Jul 2009 20:59:23 -0600
Message-ID: <da2267130907081959y1d79e4f1na9d7828141a18f95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52863 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZGIC7Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jul 2009 22:59:25 -0400
Received: by bwz25 with SMTP id 25so3241131bwz.37
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2009 19:59:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All.

I saw an many years old thread on this topic and recently ran into the
same problem. I'm wondering if anything has changed since - or someone
had some smart thoughts on this?

In short, if you do:

fd = open("foo",O_DIRECT|O_TRUNC_O|CREAT,0666);
fallocate(fd,0,xxx);
io_submit(.. IO_CMD_PWRITE ..);

io_submit blocks on ext4. (It also blocks on ext3, but fallocate fails
there so that is not entirely surprising..)

On xfs io_submit runs asynchronously with the same sequence. There is
a change in the performance characteristic: -30% with a 32k iosize
compared to re-writing already existing blocks - but it performs well
with larger iosizes

I am working on a network file copy application, so this is the common
(well. only) workload.

I haven't yet got access to the good storage to test on, but I'm
concerned that io_submit blocking means that there is going to be
limited, or no, concurrency at the SCSI level? I understand the
problem is that ext4 needs to note the block is now actually used and
no longer 'zero' but I guess I don't entirely follow why that wrecks
AIO?

Thanks,
Jason
