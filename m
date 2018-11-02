Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40507 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbeKBK54 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2018 06:57:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id n3-v6so272165lfe.7
        for <linux-ext4@vger.kernel.org>; Thu, 01 Nov 2018 18:52:31 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id w21-v6sm686814lfe.73.2018.11.01.18.52.29
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 18:52:30 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id p86so279014lfg.5
        for <linux-ext4@vger.kernel.org>; Thu, 01 Nov 2018 18:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20181022105944.GA1411@gmail.com> <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
In-Reply-To: <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Nov 2018 18:46:17 -0700
Message-ID: <CAHk-=widcG7zGELniGoqjPyBZAHehA_Gyi2n1aRO94G7SBzwNQ@mail.gmail.com>
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: dan.carpenter@oracle.com, adilger.kernel@dilger.ca,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        rostedt@goodmis.org, mchehab+samsung@kernel.org, olof@lxom.net,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, paullawrence@google.com,
        sandipan@linux.vnet.ibm.com, andreyknvl@google.com,
        David Woodhouse <dwmw2@infradead.org>, will.deacon@arm.com,
        Philippe Ombredanne <pombredanne@nexb.com>,
        paul.burton@mips.com, rientjes@google.com, w@1wt.eu,
        msebor@gmail.com, sparse@chrisli.org,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, joe@perches.com,
        Arnd Bergmann <arnd@arndb.de>, asmadeus@codewreck.org,
        stefan@agner.ch, luc.vanoostenryck@gmail.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 1, 2018 at 10:06 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The logic for using __no_sanitize_address *used* to be
>
>     #if GCC_VERSION >= 40902

Ok, looking around, I think this has less to do with the attribute
being recognized, and simply just being because KASAN itself wants
gcc-4.9.2.

I'm actually not seeing that KASAN dependency in the Kconfig scripts
(and it probably _should_ be now that we can just add compiler version
dependencies there), but that explains why the gcc version check is
different from "gcc supports the attribute".

Anyway, I decided to do the merge by just getting rid of the
GCC_VERSION check around __no_sanitize_address_or_inline entirely. If
you enable KASAN, then a function with that marking just won't be
marked inline.

End result: pulled. I'm as confused as you are as to why
__no_sanitize_address_or_inline is in the gcc header, but I guess it
ends up being the same issue: KASAN depends on gcc even if that
dependency doesn't seem to be spelled out in lib/Kconfig.kasan.

So I _think_ the KASAN config should have a

    depends on CC_IS_GCC && GCC_VERSION >= 40902

on it, but maybe there is something I'm missing.

But from a pull standpoint, I don't want to mess with those
(unrelated) issues, so I just kept the merge resolution as simple and
straightforward as possible.

Miguel, please do double-check the merge (it's not pushed out yet, I'm
doing the usual build tests etc first).

                    Linus
