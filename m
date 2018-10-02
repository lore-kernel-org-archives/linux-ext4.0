Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ozlabs.org ([203.11.71.1]:39485 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725198AbeJCFqQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 01:46:16 -0400
Date: Wed, 3 Oct 2018 09:00:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Lawrence <paullawrence@google.com>,
        Sandipan Das <sandipan@linux.vnet.ibm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Paul Burton <paul.burton@mips.com>,
        David Rientjes <rientjes@google.com>, Willy Tarreau <w@1wt.eu>,
        Martin Sebor <msebor@gmail.com>,
        Christopher Li <sparse@chrisli.org>,
        Jonathan Corbet <corbet@lwn.net>, Ted Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
Message-ID: <20181003090010.5150f914@canb.auug.org.au>
In-Reply-To: <20181002223652.GA4290@nautica>
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
        <20181003071059.02b3fd6f@canb.auug.org.au>
        <CAKwvOdmt4-jFv6d-ZVUH5OOvXSz38jpuNvQy-jtoSS3xEoh78A@mail.gmail.com>
        <CANiq72mmxiO6RWBTQfWYDaa6gmOF01nXmN6BJNCAjAFz3QJqqA@mail.gmail.com>
        <20181002223652.GA4290@nautica>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Pi_fuJWlk3fcJlLoIKV/0xY"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/Pi_fuJWlk3fcJlLoIKV/0xY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

On Wed, 3 Oct 2018 00:36:52 +0200 Dominique Martinet <asmadeus@codewreck.or=
g> wrote:
>
> Miguel Ojeda wrote on Wed, Oct 03, 2018:
> > As I have read, -next is supposed to be a vision of what the merge
> > window will look like after merging everything, i.e. ideally -rc1. For
> > that to work for files out-of-tree (like these ones, which are not
> > maintained by a single tree), changes should be allowed to be stacked
> > on each other; otherwise, we cannot handle conflicts :-( =20
>=20
> The rule is the same as with a regular mainline pull; I don't have the
> reference at hand but in some recent-ish pull request Linus said he
> prefers the stable version with the conflict, and optionally you can
> provide a second branch with the conflict resolved for reference, but
> the pull request should be based on something stable even if it has
> conflicts
>=20
> If there is a conflict Stefen will resolve it like Linus/Greg would, and
> the resolved bit will be carried over everyday so it's not much more
> work -- exactly like a regular pull request for inclusion in the main
> tree :)

Exactly what Dominique said.  I will fix up the conflict (unless it is
a very complex conflict, in which case the author(s) should help) and
the Linus (or Greg) will do the same.  If you do depend on a patch in
Andrew's series, what happens if that patch does not get sent to Linus
during the merge window or Linus rejects it?

--=20
Cheers,
Stephen Rothwell

--Sig_/Pi_fuJWlk3fcJlLoIKV/0xY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAluz+HoACgkQAVBC80lX
0GwB6Af/QRmuvQ4ntPviR4hY99kAVf71n2hG+jM6yJp/+JjLvGaMxGSq+ZFAMk0V
qnVWGZKhMDjl8b1Z+UrEJU35kn5GoWIAIbaXsBSgGWo5Hc6Z9u3PDfF6/Z0pMUEw
KE8e8PS/1KVk24EBb5foc0l3VvVYKttUroqVfUglkYVgvizRV6kdzkMAbOaqdiVh
eMIWmB0ZxYoOyM2rAQt9ul4VhQLrLKiIPlzjUQa3pMJmcaHT38RuuZ/Cpv4M3L0a
uNbiOJCyY+hUp4Q6Twi69Srk9IWU5GdaSWwTOM0SvWRQhh1ge/K0mC+b21D8ANDh
utwC/WyGrQiXJcpRJKiQpefzWwcWbQ==
=9ecB
-----END PGP SIGNATURE-----

--Sig_/Pi_fuJWlk3fcJlLoIKV/0xY--
