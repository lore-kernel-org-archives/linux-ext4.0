Return-Path: <SRS0=ORgn=PU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-vs1-f48.google.com ([209.85.217.48]:41304 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfALJnW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2019 04:43:22 -0500
MIME-Version: 1.0
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 12 Jan 2019 10:43:10 +0100
Message-ID: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
Subject: Preserving a rev 0.0 ext2 filesystem
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I'm still regularly using a Linux rev 0.0 ext2 filesystem as a  ramdisk
on m68k, containing mid-90's binaries, from right after the a.out-to-ELF
transition, so I notice if someone breaks old syscall support.

Recently I wanted to change /dev/console on that ramdisk from a symlink
to chardev 5 0.  Unfortunately I cannot mount it, without it being
upgraded automatically to a rev 1.0 ext2 filesystem.  Apparently the
kernel has been doing that upgrade for ages.

Do you have a suggestion how to make that change, while preserving the
ext2 revision?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
