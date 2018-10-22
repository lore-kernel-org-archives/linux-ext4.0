Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4682 "EHLO
        esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbeJWCMC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 22:12:02 -0400
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Dan <dan.carpenter@oracle.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        ndesaulniers@google.com
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
 <20181021222712.GI1617@thunk.org>
 <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
 <20181022102743.nua5fgbscyeymzal@mwanda>
 <1474d995-1b5a-2efb-f077-33eb4a5d9e31@petrovitsch.priv.at>
 <20181022105314.j6djkrpwbnokhai5@mwanda>
 <CANiq72=ioYcRA-yq38+Z4i6iVDNm6C2-+b4feRmnvEiekuR7dA@mail.gmail.com>
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Message-ID: <3cbb5345-0270-5575-7563-6ad37d888e42@petrovitsch.priv.at>
Date: Mon, 22 Oct 2018 19:49:21 +0200
MIME-Version: 1.0
In-Reply-To: <CANiq72=ioYcRA-yq38+Z4i6iVDNm6C2-+b4feRmnvEiekuR7dA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------4F428F195E06AF3B428EB1A0"
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------4F428F195E06AF3B428EB1A0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all!

On 22/10/18 13:07, Miguel Ojeda wrote:
> On Mon, Oct 22, 2018 at 12:54 PM Dan Carpenter <dan.carpenter@oracle.co=
m> wrote:
>>
>> Doing both is super ugly.  Let's just do comments until Eclipse gets
>> updated.

Yes, "Eclipse" as the IDE.

And yes but IMHO better super ugly than loosing the warning - YMMV.

For the archives: I have Eclipse Photon/June 2016 here. And "no break"
is the (default) string in a comment used by Eclipse (it can be
customized and is actually a regexp but it must be in a comment).

>> I had wanted to move to the attribute because that would simplify thin=
gs
>> in Smatch but it's not a huge deal to delay for another year.
>=20
> I can re-send them later on, no problem. On the other hand, doing the
> changes will push tools to get updated sooner ;-)
>=20
> If tools were doing something as fancy as comment parsing for
> diagnostics, they should have been updated with the attribute support
> (either gcc's or C++17's) -- it has been more than a year now since
> gcc 7.1 and the C++17 final draft. (Note that this does not apply for
> things like clang, since they weren't doing comment parsing to begin
> with.)

That would be nice. And if they agree on the same texts (or accept per
default all somewhat widely used and/or old ones).

After stumbling over
https://stackoverflow.com/questions/16935935/how-do-i-turn-off-a-static-c=
ode-analysis-warning-on-a-line-by-line-warning-in-cd,
looking into Eclipses Window -> Preferences -> C/C++ -> Code Analysis ->
"No break at the end of case" screen (that's the screenshot there) and I
tried various things:

Preface:
I have
----  snip  ----
#define __fallthrough __attribute__((fallthrough))
----  snip  ----
for gcc >=3D 7 (because clang doesn't know it and I had also older
gcc's in use before).

So:
- Adding a comment to the #define doesn't change anything for Eclipse.
- Eclipse looks *only* in comments for the string/regexp given
  the warnings configuration (and that comment must be on the line
  directly before the "case").
- Eclipse understands [[fallthrough]] out-of-the-box though (which
  is C++11 AFAIK) as does g++-7 (I use -std=3Dgnu++17 - most of the
  sources are C++, but not all) and clang++-6 (all the current standard
  Ubuntu-18.06/Bionic packages).
  Eclipse "accepts" [[fallthrough]] only in C++ sources (and not in C
  sources).
- Neither gcc nor clang understand [[fallthrough]] (so it's probably a
  no-go for the Kernel with C89 anyways).

MfG,
	Bernd

PS: clang++ errors with "fallthrough annotation in unreachable code" if
    [[fallthrough]] is after an assert(). clang-devs there, please, the
    fallthrough doesn't really generated code (I hope;-).
    I have lots of switch()es which catch undefined values (for enums
    et. al.) with "default"+assert() and fall through to the most safe
    case (for the deployed version).
--=20
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

--------------4F428F195E06AF3B428EB1A0
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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3D=3D
=3Dv2Yn
-----END PGP PUBLIC KEY BLOCK-----

--------------4F428F195E06AF3B428EB1A0--
