Return-Path: <SRS0=7m81=MS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ozlabs.org ([203.11.71.1]:46621 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbeJFJiz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 Oct 2018 05:38:55 -0400
Date: Sat, 6 Oct 2018 12:37:06 +1000
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
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes (v6) tree
Message-ID: <20181006123706.121fc6bc@canb.auug.org.au>
In-Reply-To: <CANiq72kuTr09CjE0jcNFkdO-gOFCjYp+REuLPq5V9c4Y8KvWXA@mail.gmail.com>
References: <CANiq72kuTr09CjE0jcNFkdO-gOFCjYp+REuLPq5V9c4Y8KvWXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XBsAZcgT2zZeLnpPcuNXhp1"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/XBsAZcgT2zZeLnpPcuNXhp1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

On Fri, 5 Oct 2018 13:32:25 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail=
.com> wrote:
>
> As discussed, here it is the Compiler Attributes series for
> linux-next. This time the original v6, based on -rc6.
>=20
> The changes w.r.t. v5:
>=20
>   - Added latest Reviewed-by's and Tested-by's.
>=20
> The conflicts are trivial to solve, but if you want a reference, take
> a look at (rebased on top of next-20181005):
>=20
>   https://github.com/ojeda/linux.git compiler-attributes-rebased
>=20
> Thanks!
>=20
> Cheers,
> Miguel
>=20
> The following changes since commit 17b57b1883c1285f3d0dc2266e8f79286a7bef=
38:
>=20
>   Linux 4.19-rc6 (2018-09-30 07:15:35 -0700)
>=20
> are available in the Git repository at:
>=20
>   https://github.com/ojeda/linux.git compiler-attributes

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

Just in case you are unaware, I will fetch that branch every morning
and the merge it into linux-next, so any updates will be added without
you having to send a new pull request.  I will send you an email if I
find a problem.
--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/XBsAZcgT2zZeLnpPcuNXhp1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlu4H9IACgkQAVBC80lX
0Gw8Xgf/WO3e5cq2gi42DEe04GACun0MjPVUObeEaYyMIPJAWWf9N61ljSZn6kqF
kPniwP4jklEvGQAkBYVwsArnGHKacOk28ahaZMUeIM5qIcVRVGasJ4HHMTq+8Wdn
wYhq3q1OjEUOR+HxofUS9oFYPiikGWv7rqRHlnwnVQONqAcA+kvTmxH3wWyGRSfp
sX978hckIPvhwNQZh6/Qy32RG7SYefa0Z3UpDbdfpWpmehWrFmC4mh6ITkMOcGCY
bqPkGqBnHqoa0PDQMAf56OdbhKwrRAS6WF6t5/7KSUgwxWaqSMnDXfSCpYErAdA1
5/DHCXzqxkCKto4C05UrwgUQG7l/VQ==
=d5WN
-----END PGP SIGNATURE-----

--Sig_/XBsAZcgT2zZeLnpPcuNXhp1--
