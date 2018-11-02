Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35788 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCBY4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2018 21:24:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id x85-v6so2256649ljb.2
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2018 09:17:17 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id b19sm420623lfc.80.2018.11.02.09.17.15
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 09:17:15 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id o2-v6so1687366lfl.13
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2018 09:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20181022105944.GA1411@gmail.com> <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
 <CAHk-=widcG7zGELniGoqjPyBZAHehA_Gyi2n1aRO94G7SBzwNQ@mail.gmail.com> <06d822ab-5bc8-2d63-05be-f694c699658d@virtuozzo.com>
In-Reply-To: <06d822ab-5bc8-2d63-05be-f694c699658d@virtuozzo.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2018 09:11:16 -0700
Message-ID: <CAHk-=wgYQHheoc1A6np=yHy6mxgfmu0pdu-+-eRKbOjrywFZ2Q@mail.gmail.com>
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        dan.carpenter@oracle.com, adilger.kernel@dilger.ca,
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
        msebor@gmail.com, Chris Li <sparse@chrisli.org>,
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

On Fri, Nov 2, 2018 at 6:16 AM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>
> On 11/02/2018 04:46 AM, Linus Torvalds wrote:
> >
> > So I _think_ the KASAN config should have a
> >
> >     depends on CC_IS_GCC && GCC_VERSION >= 40902
> >
> > on it, but maybe there is something I'm missing.
>
> I'd rather use cc-option instead of version check, since we also support clang.

That would be even better, but I thought the requirement for 4.9.2
came not from the option existing, but because of some bugs getting
fixed?

But if we can do it without version checks, that would be lovely.

                    Linus
