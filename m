From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 19 Dec 2010 17:39:01 +0100
Message-ID: <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61385 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0LSQjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Dec 2010 11:39:03 -0500
In-Reply-To: <1292710543.17128.14.camel@nayuki>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 18, 2010 at 11:15 PM, Calvin Walton <calvin.walton@gmail.co=
m> wrote:
> Hmm. I=E2=80=99m doing a little interpretation of what Olaf said here=
; but I
> think you may have misunderstood the question?
>
> He doesn=E2=80=99t care about whether or not the file is securely wri=
tten to
> disk (durable); however he doesn=E2=80=99t want to see any partially =
written
> files. In other words, something like
>
> =C2=A0 =C2=A0 1. Write to temp file
> =C2=A0 =C2=A0 2. Rename temp file over original file

Meta data, including file owner, should be preserved.
Ideally, no temp files should be visible either.

> Where the rename is only committed to disk once the entire contents o=
f
> the file have been written securely =E2=80=93 whenever that may event=
ually
> happen.
>
> He doesn=E2=80=99t want to synchronously wait for the file to be writ=
ten,
> because the new data isn=E2=80=99t particularly important. The only i=
mportant
> thing is that the file either contains the old or new data after a
> filesystem crash; not incomplete data. So, it=E2=80=99s more of an or=
dering
> problem, I think? (Analogous to putting some sort of barrier between =
the
> file write/close and the file rename to maintain ordering.)
>
> Hopefully I=E2=80=99ve interpreted the original question correctly, b=
ecause this
> is something I would find interesting as well.

Yes, you did.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
