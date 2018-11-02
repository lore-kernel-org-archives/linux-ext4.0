Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:35678 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbeKBTyM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Nov 2018 15:54:12 -0400
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: dan.carpenter@oracle.com, adilger.kernel@dilger.ca,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        rostedt@goodmis.org, mchehab+samsung@kernel.org, olof@lxom.net,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, paullawrence@google.com,
        sandipan@linux.vnet.ibm.com, andreyknvl@google.com,
        dwmw2@infradead.org, will.deacon@arm.com, pombredanne@nexb.com,
        paul.burton@mips.com, rientjes@google.com, w@1wt.eu,
        msebor@gmail.com, sparse@chrisli.org,
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
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20181022105944.GA1411@gmail.com>
 <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <29dba7c2-f612-7b35-d665-9939d7e10eb8@virtuozzo.com>
Date: Fri, 2 Nov 2018 12:44:01 +0300
MIME-Version: 1.0
In-Reply-To: <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/01/2018 08:06 PM, Linus Torvalds wrote:
> On Mon, Oct 22, 2018 at 3:59 AM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>>
>> Here it is the Compiler Attributes series/tree, which tries to disentangle
>> the include/linux/compiler*.h headers and bring them up to date.
> 
> I've finally emptied the "normal" pull queues, and am looking at the
> odd ones that I felt I needed to review more in-depth.
> 
> This looked fine to me, and I already pulled, but when looking at the
> conflict for __no_sanitize_address_or_inline, I also noticed that you
> actually changed the gcc version logic.
> 
> The logic for using __no_sanitize_address *used* to be
> 
>     #if GCC_VERSION >= 40902
> 
> but you have changed it to
> 
>   # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
> 
> so now it's gcc-4.8+ rather than gcc-4.9.2+.

As you said in other email - "this has less to do with the attribute
being recognized, and simply just being because KASAN itself wants
gcc-4.9.2."

gcc < 4.9.2 simply doesn't have -fsanitize=kernel-address.
But no_sanitize attribute originally comes with user space ASAN (-fsanitize=address)
which exist in earlier GCCs like 4.8.
Checking against 4.8 gcc should be fine. If we compile the kernel with gcc 4.8
it will be compiled without instrumentation, so the attribute won't have any effect.

> 
> I'm not sure how much that matters (maybe the original check for 4.9.2
> was just a random pick by Andrey? Added to cc), but together with the
> movement to <linux/compiler_attributes.h> that looks like it also
> wouldn't want the CONFIG_KASAN tests, I wonder what the right merge
> resolution would be.
> 
> Yes, I see the resolution in linux-next, and I think that one is odd
> and dubious, and now it *mixes* that old test of gcc-4.9.2 with the
> different test in compiler-attributes.
> 
> I'm _inclined_ to just do
> 
> #ifdef CONFIG_KASAN
>  #define __no_sanitize_address_or_inline \
>   __no_sanitize_address __maybe_unused notrace
> #else
>  #define __no_sanitize_address_or_inline inline
> #endif
> 
> without any compiler versions at all, because I don't think it matters
> (maybe we won't get address sanitation, and we will not get inlining
> either, but do we care?).

You're right, version checks shouldn't matter here. But __no_sanitize_address_or_inline
shouldn't have been added in the first place, because we already have almost the same __no_kasan_or_inline:

#ifdef CONFIG_KASAN
/*
 * We can't declare function 'inline' because __no_sanitize_address confilcts
 * with inlining. Attempt to inline it may cause a build failure.
 * 	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
 * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
 */
# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
#else
# define __no_kasan_or_inline __always_inline
#endif

There are small differences like absence of notrace, but notrace could be added
to the function together with __no_kasan_or_inline.
And inline is *not* redefined to __always_inline  only on x86 when CONFIG_OPTIMIZE_INLINING=y

So there is absolutely no reason to have both __no_kasan_or_inline and __no_sanitize_address_or_inline.
