Return-Path: <SRS0=cyUA=MM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f177.google.com ([209.85.160.177]:40078 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbeI3Rn7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Sep 2018 13:43:59 -0400
MIME-Version: 1.0
References: <CA+icZUW+N4V-bLEX0217dMYTrfzmgLZkbif8w3-zRQXnd7VYSQ@mail.gmail.com>
In-Reply-To: <CA+icZUW+N4V-bLEX0217dMYTrfzmgLZkbif8w3-zRQXnd7VYSQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 30 Sep 2018 13:11:11 +0200
Message-ID: <CANiq72mATUQeNA5uTSY2XBPwDi-S+K+H3LJJU5_UFcxUj_E8sw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Compiler Attributes
To: sedat.dilek@gmail.com
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
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
        Jonathan Corbet <corbet@lwn.net>, "Ted Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Sedat,

On Mon, Sep 24, 2018 at 10:46 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> [ Please CC me I am not subcribed to this ML ]
>
> Quote from <https://lkml.org/lkml/2018/9/20/901>:
>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com> (against Linux
> v4.19-rc5 and built with LLVM/Clang v7)

Thanks a lot for testing! Which configuration roughly (e.g.
allmodconfig)? Did you boot it & run it for a while?

Cheers,
Miguel
