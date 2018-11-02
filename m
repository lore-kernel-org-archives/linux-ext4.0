Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44261 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbeKBTUH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2018 15:20:07 -0400
MIME-Version: 1.0
References: <20181022105944.GA1411@gmail.com> <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
 <CAHk-=widcG7zGELniGoqjPyBZAHehA_Gyi2n1aRO94G7SBzwNQ@mail.gmail.com>
In-Reply-To: <CAHk-=widcG7zGELniGoqjPyBZAHehA_Gyi2n1aRO94G7SBzwNQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 2 Nov 2018 11:13:15 +0100
Message-ID: <CANiq72=jj6J0BmykqcExC2P4f1W82YPLmtRHztPmRMmNY9Zvqg@mail.gmail.com>
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dan <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
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
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 2, 2018 at 2:52 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, I decided to do the merge by just getting rid of the
> GCC_VERSION check around __no_sanitize_address_or_inline entirely. If
> you enable KASAN, then a function with that marking just won't be
> marked inline.

I was a bit confused when reading the gcc bug reports, i.e. why gcc
did *not* complain in 4.9 but it did in 5.1 (when it was supposed to
complain also in 4.9). It turns out that gcc 5.1 takes into account
who is the actual caller due to this change:

+  cgraph_node *caller = e->caller->global.inlined_to
+                       ? e->caller->global.inlined_to : e->caller;
...
-  else if (!sanitize_attrs_match_for_inline_p (e->caller->decl, callee->decl))
+  else if (!sanitize_attrs_match_for_inline_p (caller->decl, callee->decl))

change; e.g. this:

#define really_inline inline __attribute__((always_inline))
#define no_sanitize __attribute__((no_sanitize_address))

really_inline void f() {}
really_inline void g() { f(); }
no_sanitize void h() { g(); }

Complains in gcc 4.9 -O0, 5.1 -O0 and 5.1 -O2; but *not* in 4.9 -O2.
https://godbolt.org/z/kNApqk

Anyway, this is orthogonal but in case it clarifies that for someone else...

> Miguel, please do double-check the merge (it's not pushed out yet, I'm
> doing the usual build tests etc first).

I was sleeping, didn't manage to see it (in your GitHub, I guess?).

I did the merge myself, and arrived at the same thing as you. I
quickly inspected the rest and seems fine. By the way, I spotted an
extra space at:

+ * we do one or the other.

Cheers,
Miguel
