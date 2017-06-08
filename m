From: Marc Thomas <marc@dragonfly.plus.com>
Subject: e4defrag: Corrupt file after running e4defrag
Date: Thu, 8 Jun 2017 15:12:27 +0100
Message-ID: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:47372 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFHOMa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jun 2017 10:12:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by anvil.lan (8.15.2/8.15.2) with ESMTP id v58ECRcI004283
        for <linux-ext4@vger.kernel.org>; Thu, 8 Jun 2017 15:12:27 +0100
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello All,

After running "e4defrag" on an idle filesystem, I found a single file
out of 893084 regular files had become corrupt (md5sum changed).
I have repeated the process using an almost identical copy of the
original filesystem, and a different single file became corrupt.

In both cases the nature of the corruption was the first 4096 bytes of
the file being replaced with something different. The remainder of each
file was intact.
I don't think it's a hardware issue. The machine has ECC RAM, and no I/O
errors are being reported.

The ext4 filesystem is inside an LVM volume, and the underlying storage
is RAID1 md-raid.

The system is running vanilla kernel 4.11.3, with e2fsprogs-1.43.4 on an
8 core / 16 thread x86_64 CPU.


After the first e4defrag run:
# time md5sum --quiet -c CHECKSUMS_home_050617.md5
./marc/LinuxStuff/Linux4.x/patch-4.10.12.xz: FAILED
md5sum: WARNING: 1 computed checksum did NOT match

real    62m30.816s
user    10m15.144s
sys     2m29.436s

After the second run:
# time md5sum --quiet -c CHECKSUMS_home_050617.md5
./marc/.mozilla/firefox/jh6wc1il.default/formhistory.sqlite: FAILED
md5sum: WARNING: 1 computed checksum did NOT match

real    61m45.874s
user    10m24.339s
sys     2m12.107s


Can anyone help pin down the cause of the corruption? I'm happy to
repeat the process again (I have an image copy of the original source
filesystem) - but the "e4defrag" process takes about 4hours, and it
takes a further hour to do the md5sum check - so it's not quick to
reproduce.

Thanks & Kind Regards,
Marc
