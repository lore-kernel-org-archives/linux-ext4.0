Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32792 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387475AbeKFBnF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2018 20:43:05 -0500
Received: by mail-lj1-f194.google.com with SMTP id v1-v6so2367656ljd.0
        for <linux-ext4@vger.kernel.org>; Mon, 05 Nov 2018 08:22:38 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id z195-v6sm6902373lff.82.2018.11.05.08.22.35
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 08:22:36 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id p86so6585836lfg.5
        for <linux-ext4@vger.kernel.org>; Mon, 05 Nov 2018 08:22:35 -0800 (PST)
MIME-Version: 1.0
References: <20181022105944.GA1411@gmail.com> <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
 <29dba7c2-f612-7b35-d665-9939d7e10eb8@virtuozzo.com> <CAHk-=wj2AEQbmhto6FwxaxLEwvh3GG8FD8p8UptOsh5bE7jcuQ@mail.gmail.com>
 <20181105070256.52c6fd8f@mschwideX1> <20181105141535.7394b16d@mschwideX1>
In-Reply-To: <20181105141535.7394b16d@mschwideX1>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Nov 2018 08:14:56 -0800
Message-ID: <CAHk-=wi6OFJrhN2rmTy7oy2ZghvQb5Nhrq1O1G-+EPuPxdhEMQ@mail.gmail.com>
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
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
        sandipan@linux.vnet.ibm.com,
        Andrey Konovalov <andreyknvl@google.com>,
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

On Mon, Nov 5, 2018 at 5:15 AM Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
>
> This patch would work for me:

Thanks, applied,

                 Linus
