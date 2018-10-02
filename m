Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ozlabs.org ([203.11.71.1]:39277 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbeJCD4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Oct 2018 23:56:41 -0400
Date: Wed, 3 Oct 2018 07:10:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
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
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
Message-ID: <20181003071059.02b3fd6f@canb.auug.org.au>
In-Reply-To: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Wy1yG25pA/9_Y8n97w8zq9H"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/Wy1yG25pA/9_Y8n97w8zq9H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

On Tue, 2 Oct 2018 15:47:12 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail=
.com> wrote:
>
> The Compiler Attributes series has been stable for 10+ days. To
> increase testing before 4.20, I would to request it being picked up
> for -next.
>=20
> The changes w.r.t. v5 in the LKML:
>=20
>   - Rebased on top of next-20180928, which required removing

Unfortunately, trees/branches included in linux-next must be based on
something stable (usually Linus' tree, but it could be another
tree/branch that is included in linux-next that does not rebase).
Linux-next itself rebases every day, so snything based on it would drag
in a previous version of all the other trees :-(

> aligned_largest, which was removed by 9503cd9cbaba
> ("include/linux/compiler*.h: add version detection to
> asm_volatile_goto").

That commit is from Andrew's patch series which also rebases (usually
at least every week), so you cannot depend on it.

--=20
Cheers,
Stephen Rothwell

--Sig_/Wy1yG25pA/9_Y8n97w8zq9H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAluz3uMACgkQAVBC80lX
0GzohQf/dtnIEaWJKYtEJwhXt0bAjk5Bk2GPjxi8aCFnm2lUZC46HW7EBT3oyM9n
oPDpt3MbdeUAnDj8b3Z4JzizqRry1RBpdh+ezyHTql35gteBfsu95PW/PPja8wB6
AJfTmoA44zNa2kANpBnfnV9ETn5HGyNjJBwZhsfwwUruF09NUp11zr0Qy8qne2Nb
Ex6DaQ8uBJRAhCfchSd3O4FyTBvva1UlPzdB0b97439EIqyvlK5p9Rg1uWP1StOc
+u5o8hd+EyDO+wbCfpzRYWqC6wpS6JbpHeMoqQuZiO+1cw1Q8HgGOwFU6P+CmYiD
ULrX9yaIUybv2T7GDwiFdDAp28s/7Q==
=GxsG
-----END PGP SIGNATURE-----

--Sig_/Wy1yG25pA/9_Y8n97w8zq9H--
