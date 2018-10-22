Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3668 "EHLO
        esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbeJVTF7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 15:05:59 -0400
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
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
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
 <20181021222712.GI1617@thunk.org>
 <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
 <20181022102743.nua5fgbscyeymzal@mwanda>
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Message-ID: <1474d995-1b5a-2efb-f077-33eb4a5d9e31@petrovitsch.priv.at>
Date: Mon, 22 Oct 2018 12:45:03 +0200
MIME-Version: 1.0
In-Reply-To: <20181022102743.nua5fgbscyeymzal@mwanda>
Content-Type: multipart/mixed;
 boundary="------------6B430408704DD0FCAEB2EC1A"
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------6B430408704DD0FCAEB2EC1A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 22/10/18 12:27, Dan Carpenter wrote:
[...]
> What does that even mean?  Use both the attribute and the comment until=

> Eclipse is updated?
>=20
> 	case 3:
> 		frob();
> 		__fall_through; /* fall through */
> 	case 4:
>=20
> That seems like a wrong idea...

It's more like
----  snip  ----
	case 3:
		frob();
		__fall_through;
		/* no break - fall through */
	case 4:
----  snip  ----
as "eclipse" doesn't accept anything else.

And yes, it's far from "beautiful" but I hadn't time to dig into
eclipses innards to fix that.

MfG,
	Bernd
--=20
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

--------------6B430408704DD0FCAEB2EC1A
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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3D=3D
=3Dv2Yn
-----END PGP PUBLIC KEY BLOCK-----

--------------6B430408704DD0FCAEB2EC1A--
