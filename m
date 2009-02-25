From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 11:50:57 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902251150300.4063@vixen.sonytel.be>
References: <49A2705D.9030008@in.ibm.com> <18850.31567.212454.514549@cargo.ozlabs.ibm.com> <alpine.LRH.2.00.0902241857170.544@vixen.sonytel.be> <200902251227.38741.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@ozlabs.org, Jan Kara <jack@ucw.cz>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Mark Nelson <markn@au1.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59907 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751AbZBYKvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 05:51:00 -0500
In-Reply-To: <200902251227.38741.markn@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Feb 2009, Mark Nelson wrote:
> On Wed, 25 Feb 2009 05:01:59 am Geert Uytterhoeven wrote:
> > On Mon, 23 Feb 2009, Paul Mackerras wrote:
> > > Andrew Morton writes:
> > > > It looks like we died in ext3_xattr_block_get():
> > > >=20
> > > > 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
> > > > 		       size);
> > > >=20
> > > > Perhaps entry->e_value_offs is no good.  I wonder if the filesy=
stem is
> > > > corrupted and this snuck through the defenses.
> > > >=20
> > > > I also wonder if there is enough info in that trace for a ppc p=
erson to
> > > > be able to determine whether the faulting address is in the sou=
rce or
> > > > destination of the memcpy() (please)?
> > >=20
> > > It appears to have faulted on a load, implicating the source.  Th=
e
> > > address being referenced (0xc00000003f380000) doesn't look
> > > outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC t=
urned
> > > on, and what page size is selected?
> >=20
> > I'm seeing a similar thing on PS3, but not in ext3. During early us=
erspace
> > setup (udevd), it crashes accessing a 0xc00* address in:
> >=20
> > | NIP setup+0x20/0x130
> > | LR copy_user_page+0x18/0x6c
> > | Call trace:
> > | do_wp_page+0x5b4/0x89c
> > | do_page_fault+0x3a8/0x58c
> > | handle_page_fault+0x20/0x5c
> >=20
> > I have CONFIG_DEBUG_PAGEALLOC=3Dy. If I disable it, the system boot=
s fine.
> >=20
> > If needed, I can probably bisect this tomorrow. It definitely didn'=
t happen in
> > 2.6.29-rc5.
>=20
> No need to bisect - it was 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556, =
my
> commit that "optimised" 64bit memcpy() for Power6 and Cell.
>=20
> The bug was in -rc1, but if your copies were 8-byte aligned with resp=
ect
> to the source the problem wouldn't have been seen... Could this have
> been why you didn't see it in -rc5?

Hmm... I just started seeing it on older kernels (-rc5+), too...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
