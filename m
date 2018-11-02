Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:48068 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbeKCCGU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Nov 2018 22:06:20 -0400
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
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
        Theodore Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, joe@perches.com,
        Arnd Bergmann <arnd@arndb.de>, asmadeus@codewreck.org,
        stefan@agner.ch, luc.vanoostenryck@gmail.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20181022105944.GA1411@gmail.com>
 <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
 <CAHk-=widcG7zGELniGoqjPyBZAHehA_Gyi2n1aRO94G7SBzwNQ@mail.gmail.com>
 <06d822ab-5bc8-2d63-05be-f694c699658d@virtuozzo.com>
 <CAHk-=wgYQHheoc1A6np=yHy6mxgfmu0pdu-+-eRKbOjrywFZ2Q@mail.gmail.com>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <46998a3f-f8e7-fac8-d73c-c9cd81ac32b9@virtuozzo.com>
Date: Fri, 2 Nov 2018 19:59:07 +0300
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgYQHheoc1A6np=yHy6mxgfmu0pdu-+-eRKbOjrywFZ2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/02/2018 07:11 PM, Linus Torvalds wrote:
> On Fri, Nov 2, 2018 at 6:16 AM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>
>> On 11/02/2018 04:46 AM, Linus Torvalds wrote:
>>>
>>> So I _think_ the KASAN config should have a
>>>
>>>     depends on CC_IS_GCC && GCC_VERSION >= 40902
>>>
>>> on it, but maybe there is something I'm missing.
>>
>> I'd rather use cc-option instead of version check, since we also support clang.
> 
> That would be even better, but I thought the requirement for 4.9.2
> came not from the option existing, but because of some bugs getting
> fixed?

It looks unusual but -fsanitize=kernel-address really showed up only in 4.9.2.
It was actually backported from 5.0 branch to 4.9 for whatever reason.

> 
> But if we can do it without version checks, that would be lovely.
> 
>                     Linus
> 
