From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [GIT PULL]
Date: Fri, 11 Feb 2011 19:41:41 -0600
Message-ID: <4D55E555.9050409@redhat.com>
References: <20110211134058.GA4309@thunk.org> <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1BLBmF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Feb 2011 20:42:05 -0500
In-Reply-To: <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/11/11 6:33 PM, Linus Torvalds wrote:
> On Fri, Feb 11, 2011 at 5:40 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>
>> Please pull from:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_li=
nus
>>
>> to get regression and bug fixes for 2.6.38.
>>
>> Eric Sandeen (3):
>>      ext4: serialize unaligned asynchronous DIO
>=20
> This is a completely disgusting patch, and it causes warnings like th=
is:

>  fs/ext4/file.c: In function =91ext4_aiodio_wait=92:
>  fs/ext4/file.c:60:44: warning: cast from pointer to integer of diffe=
rent size
>=20
> because that disgusting patch does things like
>=20
>   #define ext4_aio_mutex(v)  (&ext4__aio_mutex[((unsigned)v) % EXT4_W=
Q_HASH_SZ])

Well crap, the patch I sent Ted did not cause warnings.
OTOH, I eyeballed his changes to my patch and said OK.  Didn't test-bui=
ld it though.
Sorry about that.

Will see what's going on here...

-Eric

> which is just terminally broken.
>=20
> It's terminally broken for multiple reasons, too. It's not just "oh, =
a
> warning". It's a case of "oh, THAT CODE IS UTTER CRAP". The warning
> was just the lucky reason I noticed the totally unacceptable code.
>=20
> Dammit, don't send sh*t to me this late in the release cycle. This
> clearly went through _zero_ quality control.
>=20
>                    Linus
>=20
> PS. If people don't understand why that code is utter crap, let me
> give you a hint: macro argument expansion vs operator precedence.
>=20
> PPS. And btw, the warning is unacceptable too. Cast the thing to
> "unsigned long" (or uintptr_t, but quite frankly, in the kernel I'd
> suggest "unsigned long" rather than the more obscure standard types)
> after you've fixed the macro argument problem.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
