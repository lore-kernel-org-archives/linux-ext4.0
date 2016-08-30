From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 14:56:45 +0200
Message-ID: <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: debian-sparc <debian-sparc@lists.debian.org>
To: Anatoly Pugachev <matorola@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:37000 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758215AbcH3M4u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Aug 2016 08:56:50 -0400
In-Reply-To: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/30/2016 02:42 PM, Anatoly Pugachev wrote:
> ../../e2fsck/recovery.c:866
> 866                             blocknr = ext2fs_be64_to_cpu(* ((__u64
> *) (bh->b_data+offset)));

The reason is that this expression is casting "char * b_data" [1] into u64 [2]
which provokes unaligned access. Since such expression are often inevitable,
it's probably best to modify the conversion macros in bitops.h [3] to be
safe against unaligned accesses.

An example for that can be seen in the systemd code base [4].

Thanks,
Adrian

> [1] http://lxr.free-electrons.com/source/include/linux/buffer_head.h#L69
> [2] http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/tree/e2fsck/recovery.c#n866
> [3] http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/tree/lib/ext2fs/bitops.h
> [4] https://github.com/systemd/systemd/blob/master/src/basic/unaligned.h

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
