From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: [bug] ext{3,4}: __find_get_block_slow() failed on 3.0.3
Date: Sat, 20 Aug 2011 01:51:49 +0200
Message-ID: <CANvSZQ804KZWhPG4JvzOPtkC02ibD6YmRnUvHCEhLB8DKEo7LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42844 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1HSX6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 19:58:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there,

while rsyncing a large amount (> 1TB) of data from an ext3 to an ext4
on my machine [1], I encountered an issue where rsync and syslog
eventually started consuming 100% CPU and my syslog was flooded [2]
with error messages:

-- 8< --
> kernel: [101543.047293] b_state=0x00000029, b_size=>[10ock01543.04>[101543.047321] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> kernel: [101543.047330] b_state=0x00000029, b_size=4096
> kernel: [101543.047>[10ock01543.047348] b_state=0x00000029, b_size=4096
> kernel: [101543.047353] device blocksize: 4096
> kernel: [101543.047359] __find_get_block_slow() failed. block=328204473, b01543.0>[10ock01543.047>[1ock01543.047404] b_state=0x00000029, b_size=4096
> kernel: [101543.047409] device blocksize: 4096
> kernel: [101543.047414] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> kernel: [10154ock01543.0>[1ock01543.0492>[1ock01543.0492>[1ock01543.049>[1ock01543.0492>[1ock01543.0>[1ock01543.049>[1ock01543.049>[1ock01543.0492>[10ock01543.0>[1ock=01543.04>[1ock01543.>[1ock01543.0493>[1ock01543.049>[1ock01543.04>[1ock01543.0493>[1ock01543.04941>[1ock01543.0494>[1ock01543.0>[1ock01543.049>[10ock01543.0>[1ock01543.04>[1ock01543.04>[1ock01543.0495>[1ock01543.0495>[1ock01543.0495>[1ock01543.0496>[1ock01543.04>[1ock01543.04>[1ock01543.049>[1ock01543.049>[1ock01543.04>[1ock01543.0497>[1ock01543.0>[1ock01543.0497>[1ock01543.0497>[1ock01543.0498>[1ock01543.0498>[1ock01543.04>[1ock01543.04>[1ock01543.0498>[1ock01543.0498>[1ock01543.0499>[1ock01543.0499>[1ock01543.04>[101543.049967] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
> kernel: [101543.049975] b_state=0x00000029, b_size=4096
> kernel: [101543.049980] device blocksize: 4096
> kernel: [101543.049986] __find_get_block_slow() failed. block=328204473, b_blocknr=51867812025
-- 8< --

These are not preceded by any other error messages (about possible FS
inconsistencies) as has been the case in the past when bugs related to
this error message were reported.

Judging by the block size, the possibly corrupt volume is the ext3 one
(the ext4 volume has a block size of 2048).

A forced fsck.ext{3,4} of the source and target partitions did not
show any inconsistencies.

Any ideas?

Thanks,
Thilo

[1] Linux andromeda 3.0.3-030003-generic #201108180913 SMP Thu Aug 18
09:15:59 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
[2] /var/log/kern.log grew to 200 MB just while shutting down the system
