From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Next3 - COW of data blocks
Date: Sat, 15 May 2010 08:36:04 +0200
Message-ID: <AANLkTilD-9GKI6SRF-ZmzkoSRW2YfvPk80Jyt0dHuErk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55651 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0EOGgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 May 2010 02:36:06 -0400
Received: by fxm6 with SMTP id 6so2163043fxm.19
        for <linux-ext4@vger.kernel.org>; Fri, 14 May 2010 23:36:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 8, 2010 at 9:40 PM, Amir G. <amir73il@users.sourceforge.net=
> wrote:
> On Sat, May 8, 2010 at 7:25 PM, =A0<tytso@mit.edu> wrote:
>>
>> Technically speaking, it's possible to do it both way, yes? =A0I'm n=
ot
>> sure why you consider this such a important design decision. =A0We c=
an
>> even play games where for some files we might do copy-on-write, and
>> for some files, we do move-on-write. =A0It's always possible to chec=
k
>> the COW bitmaps to decide what had happened.
>>
>
> Definitely yes! I never thought it would really have to come down to =
a
> "decision",
> because there is a trade-off at hand.
> Even in Next3, without extents, it makes sense to have a choice of
> write performance vs. fragmentation per file.
> The few applications that use random in-place write (db, virtual disk=
)
> would probably want to avoid the fragmentation.
>

There is another challenge concerning COW of non-journaled data blocks.

With COW of metadata blocks, the order of I/O is guarantied to
preserve snapshot consistency after crash,
because snapshot data blocks (the copied block) are ordered and both
snapshot metadata blocks and original COWed metadata block are
journaled in the same transaction.

With move-on-write of non-journaled data blocks, the entire move block
operation is journaled, the snapshot data block is
a moved block, so has no I/O at all, and the new data block is
whatever (ordered,writeback).

If Next3 were to implement COW of non-journaled data blocks (i.e.,
ordered or writeback) to avoid the file fragmentation,
how can it assure the correct order of I/O between the COWed data
block and the snapshot copied block without using synchronic I/O?

Can someone propose a solution to that challenge?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
