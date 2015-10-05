From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 13:48:59 -0700
Message-ID: <5612E23B.7070606@linux.intel.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
 <5612A3F3.2040609@linux.intel.com>
 <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Anvin <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/05/2015 01:22 PM, Linus Torvalds wrote:
> On Mon, Oct 5, 2015 at 5:23 PM, Dave Hansen <dave.hansen@linux.intel.=
com> wrote:
>> One thing I've been noticing on Skylake is that barriers (implicit a=
nd
>> explicit) are showing up more in profiles.
>=20
> Ahh, you're on skylake?

Yup.

> It's entirely possible that the issue is that the whole
> "stac/mov/clac" is much more expensive because skylake actually ends
> up supporting those AC instructions. That would make sense.
>=20
> We could probably do them outside the loop, rather than tightly aroun=
d
> the actual move instructions. Peter (hpa), is there some sane
> interface to try to do that?

iov_iter_fault_in_readable() is just going and touching a single word i=
n
the page so that it is faulted in, or a pair of words if it manages to
cross a page boundary (which isn't happening here).  I'm not sure
there's a loop to move them out of here (for the prefaulting part).

We could theoretically expand the stac/clac to be around the pair of
__get_user()s in fault_in_pages_readable() but that would only help the
case where we are crossing a page boundary.

Although I was probably wrong about the source of the overhead, the
point still remains that the prefaulting is eating cycles for no
practical benefit.

>>  What we're seeing here
>> probably isn't actually stac/clac overhead, but the cost of finishin=
g
>> some other operations that are outstanding before we can proceed thr=
ough
>> here.
>=20
> I suspect it actually _is_ stac/clac overhead. It might well be that
> clac/stac ends up serializing loads some way. Last I heard, they were
> reasonably cheap but certainly not free - and when we're talking abou=
t
> something that just loops over bringing the line into cache, it might
> be relatively expensive.
>=20
> How did you do the profile? Use "-e cycles:pp" to get the precise
> profile information, which should actually attribute the cost to the
> instruction that really causes it.

It reduced the skid a bit.

Plain (no -e"):
>        =E2=94=82      stac
>  24.57 =E2=94=82      mov    (%rcx),%sil
>  15.70 =E2=94=82      clac
>  28.77 =E2=94=82      test   %eax,%eax
>   2.15 =E2=94=82      mov    %sil,-0x1(%rbp)
>   8.93 =E2=94=82    =E2=86=93 jne    66
>   2.31 =E2=94=82      movslq %edx,%rdx

With "-e cycles:pp":
>        =E2=94=82      sub    $0x8,%rsp
>  24.57 =E2=94=82      stac
>  15.49 =E2=94=82      mov    (%rcx),%sil
>  29.06 =E2=94=82      clac
>   2.24 =E2=94=82      test   %eax,%eax
>   8.77 =E2=94=82      mov    %sil,-0x1(%rbp)
>   2.22 =E2=94=82    =E2=86=93 jne    66
>        =E2=94=82      movslq %edx,%rdx
