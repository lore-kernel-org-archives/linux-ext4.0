From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 13:25:10 -0700
Message-ID: <20160830202510.GA8258@birch.djwong.org>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
 <20160830145810.rgms25xlnatnyxir@thunk.org>
 <CADxRZqzQ+hnjVLkN+4L1u=k4iMOa_6j7UjGX-40F=uy9oUAppA@mail.gmail.com>
 <20160830191644.hoqnviqcj2odxcpu@thunk.org>
 <CADxRZqx1QQNPXyzw7qXKPGH40yA9UsvZPYHaW0=i=z_tAix2Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34106 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbcH3U0O (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2016 16:26:14 -0400
Content-Disposition: inline
In-Reply-To: <CADxRZqx1QQNPXyzw7qXKPGH40yA9UsvZPYHaW0=i=z_tAix2Aw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2016 at 11:17:07PM +0300, Anatoly Pugachev wrote:
> On Tue, Aug 30, 2016 at 10:16 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Tue, Aug 30, 2016 at 06:12:39PM +0300, Anatoly Pugachev wrote:
> >>
> >> (gdb) p bh->b_data
> >> $1 = "\300;9\230\000\000\000\005\000\000\253\204\000\000\000\070\000\000\000\000\000\000$\022\000\000\000\000\000\000$<\000\000\000\000\000\000$\270\000\000\000\000\000\000$]\000\000\000\000\000\000$\024",
> >> '\000' <repeats 967 times>
> >> (gdb) p offset
> >> $2 = 16
> >> (gdb) p *bh->b_data
> >> $3 = -64 '\300'
> >> (gdb) p *(bh->b_data+offset)
> >> $6 = 0 '\000'
> >
> > Can you give us "p &bh->b_data" (so we can get the starting address of
> > b_data to make sure it's aligned) and "p offset" (so we can check and
> > make sure offset is sane)?
> 
> (gdb) p &bh->b_data
> $7 = (char (*)[1024]) 0x2e9b9c
> (gdb) p offset
> $8 = 16

AFAICT, each bh is malloc'd via e2fsck_allocate_memory and nothing seems
to guarantee that the char b_data[1024] will be aligned to a multiple of
8 (it certainly isn't on x64), so I guess this isn't much of a surprise.

We could change b_data to a pointer and then posix_memalign it.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
