From: Cuong Tran <cuonghuutran@gmail.com>
Subject: Why deleting large files took so long?
Date: Wed, 7 Aug 2013 00:45:53 -0700
Message-ID: <CALQm4jiYtxKmfji9p2QPZ6vnXApQmGh8UVjtm2DWr94JF4B8yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:52265 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3HGHqP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 03:46:15 -0400
Received: by mail-vb0-f44.google.com with SMTP id e13so1482328vbg.31
        for <linux-ext4@vger.kernel.org>; Wed, 07 Aug 2013 00:46:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My apology if this is not the correct forum for this question. I am
trying to understand why deleting large files take so long? If this is
not the correct forum, please kindly let me know which forum I can ask
this question.

I created 4 large files, 30 GB per file, for total size of 120 GB.
Then when my machine was idle (no CPU, no IO), I deleted these 4 files
at the same time.

Deleting these files at the same time took 12 secs, most of each was
due to kernel time!

$  time rm -f large* test.log
real    0m12.002s
user    0m0.001s
sys     0m11.928s

Kernel is RedHat Enterprise 6.x
Linux ctran-ld 2.6.32-131.4.1.el6.x86_64 #1 SMP Fri Jun 10 10:54:26
EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

Server has 64 GByte memory. Drive is SAS 15K RPM. CPU is Xeon
E5620@2.40Hz, 8 cores including hyper-threading.


Why does it take so long to delete these files (diskIO during deleting
is about couple of 100 MBytes, probably to commit changes in meta-data
in journal).

Thanks so much for shedding light on this puzzle.

Cheers,

--Cuong
