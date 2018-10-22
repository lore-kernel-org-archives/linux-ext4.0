Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45980 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbeJWBhS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 21:37:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id o19-v6so3588352pll.12
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 10:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com> <20181021222712.GI1617@thunk.org>
 <CANiq72mXV6WTyHXNZJDTfFOpPrXD0zD6cB30bGOuKO44AvRiog@mail.gmail.com>
 <CAGXu5jKb-0H+smRAW6ngQKDZ-PbTThhMwhmu34iB8vjTa-4H8Q@mail.gmail.com>
 <CANiq72n4+HDXPqr7xySSGx49g8vEcXaxO7a-By9cSg7YSxOS_A@mail.gmail.com> <CANiq72kNnrhi8OPbF7P+Rw4SGYu=JuvhDKtzGtG2J5AOoC1-Dw@mail.gmail.com>
In-Reply-To: <CANiq72kNnrhi8OPbF7P+Rw4SGYu=JuvhDKtzGtG2J5AOoC1-Dw@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 22 Oct 2018 10:17:44 -0700
Message-ID: <CAKwvOdn1TOzZYg_i0zB0rU+K3jaQQ8XmWnLXz01NCG9V+8PxHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, gustavo@embeddedor.com,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dan.carpenter@oracle.com,
        adilger.kernel@dilger.ca,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>, rostedt@goodmis.org,
        mchehab+samsung@kernel.org, olof@lxom.net,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Lawrence <paullawrence@google.com>,
        sandipan@linux.vnet.ibm.com,
        Andrey Konovalov <andreyknvl@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        paul.burton@mips.com, David Rientjes <rientjes@google.com>,
        Willy Tarreau <w@1wt.eu>, msebor@gmail.com, sparse@chrisli.org,
        Jonathan Corbet <corbet@lwn.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, joe@perches.com,
        Arnd Bergmann <arnd@arndb.de>, asmadeus@codewreck.org,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 2:43 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Oct 22, 2018 at 11:41 AM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> >   * clang does *not* support the attribute in C.
>
> ...nor the warning at all, by the way (which is why this is OK).
>
> Cheers,
> Miguel

Oh? We're going through and annotating all of Android's C++ source
right now with it.
https://clang.llvm.org/docs/DiagnosticsReference.html#wimplicit-fallthrough

Though it looks like the attribute syntax I like from GCC is not yet
supported in Clang.
https://bugs.llvm.org/show_bug.cgi?id=37135
https://github.com/ClangBuiltLinux/linux/issues/235
I'll take a look at adding support.

So Kees sent me this embarrassing example:
https://godbolt.org/z/gV_c9_
(try changing the language from C++ to C; it works)!  That's embarrassing!
https://bugs.llvm.org/show_bug.cgi?id=39382
https://github.com/ClangBuiltLinux/linux/issues/236
Will get these both fixed up.
-- 
Thanks,
~Nick Desaulniers
