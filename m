From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Thu, 23 Dec 2010 16:49:53 +0100
Message-ID: <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42142 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0LWPty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Dec 2010 10:49:54 -0500
In-Reply-To: <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 19, 2010 at 5:39 PM, Olaf van der Spek <olafvdspek@gmail.co=
m> wrote:
> On Sat, Dec 18, 2010 at 11:15 PM, Calvin Walton <calvin.walton@gmail.=
com> wrote:
>> Hmm. I=E2=80=99m doing a little interpretation of what Olaf said her=
e; but I
>> think you may have misunderstood the question?
>>
>> He doesn=E2=80=99t care about whether or not the file is securely wr=
itten to
>> disk (durable); however he doesn=E2=80=99t want to see any partially=
 written
>> files. In other words, something like
>>
>> =C2=A0 =C2=A0 1. Write to temp file
>> =C2=A0 =C2=A0 2. Rename temp file over original file
>
> Meta data, including file owner, should be preserved.
> Ideally, no temp files should be visible either.
>
>> Where the rename is only committed to disk once the entire contents =
of
>> the file have been written securely =E2=80=93 whenever that may even=
tually
>> happen.
>>
>> He doesn=E2=80=99t want to synchronously wait for the file to be wri=
tten,
>> because the new data isn=E2=80=99t particularly important. The only =
important
>> thing is that the file either contains the old or new data after a
>> filesystem crash; not incomplete data. So, it=E2=80=99s more of an o=
rdering
>> problem, I think? (Analogous to putting some sort of barrier between=
 the
>> file write/close and the file rename to maintain ordering.)
>>
>> Hopefully I=E2=80=99ve interpreted the original question correctly, =
because this
>> is something I would find interesting as well.
>
> Yes, you did.

Somebody?

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
