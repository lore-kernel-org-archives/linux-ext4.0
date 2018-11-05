Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728886AbeKEPVN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2018 10:21:13 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wA55waNu143629
        for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2018 01:03:13 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2njen1b0n1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 05 Nov 2018 01:03:13 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <schwidefsky@de.ibm.com>;
        Mon, 5 Nov 2018 06:03:11 -0000
Date: Mon, 5 Nov 2018 07:02:56 +0100
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
In-Reply-To: <CAHk-=wj2AEQbmhto6FwxaxLEwvh3GG8FD8p8UptOsh5bE7jcuQ@mail.gmail.com>
References: <20181022105944.GA1411@gmail.com>
        <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
        <29dba7c2-f612-7b35-d665-9939d7e10eb8@virtuozzo.com>
        <CAHk-=wj2AEQbmhto6FwxaxLEwvh3GG8FD8p8UptOsh5bE7jcuQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <20181105070256.52c6fd8f@mschwideX1>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2 Nov 2018 09:09:32 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Nov 2, 2018 at 2:43 AM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> >
> > You're right, version checks shouldn't matter here. But __no_sanitize_address_or_inline
> > shouldn't have been added in the first place, because we already have almost the same
> >__no_kasan_or_inline:  
> 
> Ahh, very good.
> 
> Vasily, Martin - since __no_sanitize_address_or_inline was added just
> for s390, would you mind replacing it with __no_kasan_or_inline
> instead, and testing that in whatever failed before?
> 
> Then we can just remove that unnecessary symbol #define entirely..

Ok, will do.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
