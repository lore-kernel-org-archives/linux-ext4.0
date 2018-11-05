Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728094AbeKEWff (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2018 17:35:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA5DF78Z080524
        for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2018 08:15:52 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2njmca6mjh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 05 Nov 2018 08:15:52 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <schwidefsky@de.ibm.com>;
        Mon, 5 Nov 2018 13:15:48 -0000
Date: Mon, 5 Nov 2018 14:15:35 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
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
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
In-Reply-To: <20181105070256.52c6fd8f@mschwideX1>
References: <20181022105944.GA1411@gmail.com>
        <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
        <29dba7c2-f612-7b35-d665-9939d7e10eb8@virtuozzo.com>
        <CAHk-=wj2AEQbmhto6FwxaxLEwvh3GG8FD8p8UptOsh5bE7jcuQ@mail.gmail.com>
        <20181105070256.52c6fd8f@mschwideX1>
Message-Id: <20181105141535.7394b16d@mschwideX1>
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 Nov 2018 07:02:56 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 2 Nov 2018 09:09:32 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, Nov 2, 2018 at 2:43 AM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:  
> > >
> > > You're right, version checks shouldn't matter here. But __no_sanitize_address_or_inline
> > > shouldn't have been added in the first place, because we already have almost the same
> > >__no_kasan_or_inline:    
> > 
> > Ahh, very good.
> > 
> > Vasily, Martin - since __no_sanitize_address_or_inline was added just
> > for s390, would you mind replacing it with __no_kasan_or_inline
> > instead, and testing that in whatever failed before?
> > 
> > Then we can just remove that unnecessary symbol #define entirely..  
> 
> Ok, will do.
 
Follow-up question: the __no_sanitize_address_or_inline define has the 'notrace'
option that is missing for __no_kasan_or_inline. We need that option for
__load_psw_mask, if we do the replacement all users of __no_kasan_or_inline
would get the option as well. This affects __read_once_size_nocheck and
read_word_at_a_time. Do these function have to be traceable ?

This patch would work for me:
--
>From 4aaa09fe4b54e930edabac86606dee979b12647c Mon Sep 17 00:00:00 2001
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Mon, 5 Nov 2018 07:36:28 +0100
Subject: [PATCH] compiler: remove __no_sanitize_address_or_inline again

The __no_sanitize_address_or_inline and __no_kasan_or_inline defines
are almost identical. The only difference is that __no_kasan_or_inline
does not have the 'notrace' attribute.

To be able to replace __no_sanitize_address_or_inline with the older
definition, add 'notrace' to __no_kasan_or_inline and change to two
users of __no_sanitize_address_or_inline in the s390 code.

The 'notrace' option is necessary for e.g. the __load_psw_mask function
in arch/s390/include/asm/processor.h. Without the option it is possible
to trace __load_psw_mask which leads to kernel stack overflow.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/processor.h |  4 ++--
 include/linux/compiler-gcc.h      | 12 ------------
 include/linux/compiler.h          |  2 +-
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 302795c47c06..81038ab357ce 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -236,7 +236,7 @@ static inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-static __no_sanitize_address_or_inline unsigned short stap(void)
+static __no_kasan_or_inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
 
@@ -330,7 +330,7 @@ static inline void __load_psw(psw_t psw)
  * Set PSW mask to specified value, while leaving the
  * PSW addr pointing to the next instruction.
  */
-static __no_sanitize_address_or_inline void __load_psw_mask(unsigned long mask)
+static __no_kasan_or_inline void __load_psw_mask(unsigned long mask)
 {
 	unsigned long addr;
 	psw_t psw;
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index c0f5db3a9621..2010493e1040 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -143,18 +143,6 @@
 #define KASAN_ABI_VERSION 3
 #endif
 
-/*
- * Because __no_sanitize_address conflicts with inlining:
- *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
- * we do one or the other. 
- */
-#ifdef CONFIG_KASAN
-#define __no_sanitize_address_or_inline					\
-	__no_sanitize_address __maybe_unused notrace
-#else
-#define __no_sanitize_address_or_inline inline
-#endif
-
 #if GCC_VERSION >= 50100
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 18c80cfa4fc4..06396c1cf127 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -189,7 +189,7 @@ void __read_once_size(const volatile void *p, void *res, int size)
  * 	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
  * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
  */
-# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
+# define __no_kasan_or_inline __no_sanitize_address notrace __maybe_unused
 #else
 # define __no_kasan_or_inline __always_inline
 #endif
-- 
2.16.4
-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
