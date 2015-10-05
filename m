From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Mon, 5 Oct 2015 22:18:18 +0100
Message-ID: <CA+55aFwkA1EODc0bsrdmob945DYfDW_jE+nmrFKpq2YmBn+W4Q@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
	<5612A3F3.2040609@linux.intel.com>
	<CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
	<5612E23B.7070606@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Anvin <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5612E23B.7070606@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 5, 2015 at 9:48 PM, Dave Hansen <dave.hansen@linux.intel.co=
m> wrote:
>
> Although I was probably wrong about the source of the overhead, the
> point still remains that the prefaulting is eating cycles for no
> practical benefit.

Yeah, no, I'm not disagreeing with that part, I'm just more of a "at
this point in the rc series we are probably better off reverting".

Your ext4 patch may well fix the issue, and be the right thing to do
(_regardless_ of the revert, in fact - while it might make the revert
unnecessary, it might also be a good idea even if we do revert).

The subtlety of this just worries me, and the reason I'd still be
inclined to revert is simply "it's been that way a long time, the safe
thing is to go back and take this slow".

> With "-e cycles:pp":
>>        =E2=94=82      sub    $0x8,%rsp
>>  24.57 =E2=94=82      stac
>>  15.49 =E2=94=82      mov    (%rcx),%sil
>>  29.06 =E2=94=82      clac
>>   2.24 =E2=94=82      test   %eax,%eax
>>   8.77 =E2=94=82      mov    %sil,-0x1(%rbp)
>>   2.22 =E2=94=82    =E2=86=93 jne    66
>>        =E2=94=82      movslq %edx,%rdx

Ok, so it really is the stac/clac that is the bulk of the cost. Hmm.

You're right that the loop there will only be executed once for your
case, so moving the stac/clac outside probably doesn't help. It
*might* still make a difference just for microarchitectural reasons
(ie they may cause more trouble just because they are close to an
instruction that depends on them), but it's questionable.

It is a bit worrisome to see that those things are so expensive. Right
now almost all user accesses will cause *lots* of clac/stac stuff.

I originally asked Intel to do SMAP using a segment prefix, but that
was not to be..

              Linus
