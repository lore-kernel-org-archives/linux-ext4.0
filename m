From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 15:16:44 -0400
Message-ID: <20160830191644.hoqnviqcj2odxcpu@thunk.org>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
 <20160830145810.rgms25xlnatnyxir@thunk.org>
 <CADxRZqzQ+hnjVLkN+4L1u=k4iMOa_6j7UjGX-40F=uy9oUAppA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52984 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcH3TQt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Aug 2016 15:16:49 -0400
Content-Disposition: inline
In-Reply-To: <CADxRZqzQ+hnjVLkN+4L1u=k4iMOa_6j7UjGX-40F=uy9oUAppA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2016 at 06:12:39PM +0300, Anatoly Pugachev wrote:
> 
> (gdb) p bh->b_data
> $1 = "\300;9\230\000\000\000\005\000\000\253\204\000\000\000\070\000\000\000\000\000\000$\022\000\000\000\000\000\000$<\000\000\000\000\000\000$\270\000\000\000\000\000\000$]\000\000\000\000\000\000$\024",
> '\000' <repeats 967 times>
> (gdb) p offset
> $2 = 16
> (gdb) p *bh->b_data
> $3 = -64 '\300'
> (gdb) p *(bh->b_data+offset)
> $6 = 0 '\000'

Can you give us "p &bh->b_data" (so we can get the starting address of
b_data to make sure it's aligned) and "p offset" (so we can check and
make sure offset is sane)?

Thanks,

					- Ted


