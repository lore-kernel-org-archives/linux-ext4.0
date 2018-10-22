Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46737 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbeJWBN5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 21:13:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id r64-v6so20191443pfb.13
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 09:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021182926.GB6683@kroah.com> <CANiq72kOE0a4M0oCmmiWO9xTFJsybEirwUyb_ZTXpJJhc7O_TA@mail.gmail.com>
In-Reply-To: <CANiq72kOE0a4M0oCmmiWO9xTFJsybEirwUyb_ZTXpJJhc7O_TA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 22 Oct 2018 09:54:27 -0700
Message-ID: <CAKwvOdn9hOcF01eOmwfnrH_ciFZ4fPaspSzMPiY68o3B0En-VQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Compiler Attributes: __fallthrough
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dan.carpenter@oracle.com,
        adilger.kernel@dilger.ca,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>, rostedt@goodmis.org,
        mchehab+samsung@kernel.org, olof@lxom.net,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
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
        "Theodore Ts'o" <tytso@mit.edu>,
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

On Mon, Oct 22, 2018 at 2:48 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Oct 21, 2018 at 8:29 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Will this work with all of the static tools that are currently looking
> > for the comment instead?  I know coverity handles that, what about
> > others?
>
> I will also contact the different tools about this.

Let's contact the authors of these tools if they don't parse the
attribute.  I prefer to have the attributes rather than specifically
formatted comments.

I do think this may be tricky to provide backwards support for though;
Miguel, do you have info on which versions of GCC support comments vs
attribute?
-- 
Thanks,
~Nick Desaulniers
