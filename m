From: Brian Malehorn <bmalehorn@gmail.com>
Subject: write() hangs during flush
Date: Wed, 19 Jul 2017 23:07:08 -0700
Message-ID: <CAJB88a2J+HY_n8=7nJHp9GQ0jVDJdYLw5TPrBxN-ySqnBXNi9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:37065 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdGTGHv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jul 2017 02:07:51 -0400
Received: by mail-lf0-f53.google.com with SMTP id m86so944018lfi.4
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 23:07:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm debugging an issue where write() can sometimes take several
seconds to complete. I'm looking for general guidance on why this
might happen, and what I can do about it.

While I originally encountered the problem on an embedded device
writing to an MMC, I can also reproduce it on my laptop (Ubuntu
16.04):

    pv -L 100m /dev/zero |
      strace -s 8 -T -e trace=write dd bs=32k of=./zero 2>&1 |
      awk 'substr($NF, 2, length($NF)-2) + 0 > 0.1'

    write(1, "\0\0\0\0\0\0\0\0"..., 32768) = 32768 <0.145895>
    write(1, "\0\0\0\0\0\0\0\0"..., 32768) = 32768 <0.673575>
    write(1, "\0\0\0\0\0\0\0\0"..., 32768) = 32768 <0.126722>
    write(1, "\0\0\0\0\0\0\0\0"..., 32768) = 32768 <1.284791>

In the above example, I write 100 MiB / second, and print out any
write() that took over 100 ms. In the output, the slowest write was
1.28 seconds. I can provide more details about the setup if needed.

I believe this is happening:

  1. accumulate lots of data in cache
  2. filesystem decides to flush
  3. nobody can write during flush
  4. flush flushes "a lot" of data - maybe everything

Do my guesses align with reality, or is there another explanation?

Does anybody have ideas on how to make this more "smooth"? Ideally,
I'd like each write() to be slowed down a little bit, rather than
99.99% of writes completing instantly and 0.01% taking over a second.

Thanks,
Brian
