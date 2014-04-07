From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
Date: Mon, 7 Apr 2014 00:14:31 -0400
Message-ID: <20140407041431.GA8468@thunk.org>
References: <53396AC1.10108@gmail.com>
 <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50932 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaDGEOl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 00:14:41 -0400
Content-Disposition: inline
In-Reply-To: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 06, 2014 at 03:39:09PM +0200, Geert Uytterhoeven wrote:
> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com>=
 wrote:
> > '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. =
Need
> > append 'ULL' for it.
> >
> > The related warning (with allmodconfig under unicore32):
> >
> >     CC [M]  fs/ext4/extents_status.o
> >   fs/ext4/extents_status.c: In function =E2=80=98__es_remove_extent=
=E2=80=99:
> >   fs/ext4/extents_status.c:813: warning: integer constant is too la=
rge for =E2=80=98long=E2=80=99 type
>=20
> Thanks! This is failing on all 32-bit architectures.

Yes, it's harmless (since we don't actually check the value anywhere;
this is just so humans could easily spot bugs when debugging), but
I'll make sure this gets queued for 3.15 fixes in the ext4 tree.

Thanks!!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
