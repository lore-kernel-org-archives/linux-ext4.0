Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44895 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeJVRu0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 13:50:26 -0400
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com> <20181022004217.GA4941@bombadil.infradead.org>
In-Reply-To: <20181022004217.GA4941@bombadil.infradead.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 22 Oct 2018 11:32:29 +0200
Message-ID: <CANiq72nKkJgLuHVTEZAMPcrXeTd1OvP2owCAUjqnYtru4JeMYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: Matthew Wilcox <willy@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 2:42 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Oct 21, 2018 at 07:14:13PM +0200, Miguel Ojeda wrote:
> > +#if __has_attribute(__fallthrough__)
> > +# define __fallthrough                  __attribute__((__fallthrough__))
> > +#else
> > +# define __fallthrough
> > +#endif
>
> Why is the #else not:
>
> # define __fallthrough          /* fallthrough */
>
> Would this solve the Coverity problem, or does Coverity look at the raw
> source code before preprocessing?

That wouldn't work if Coverity follows the standard, because it is
required that comments are removed right before the preprocessing
phase.

That is one of the advantages vs. the attribute that I mentioned:

    """
    We can actually use a #define for it like for the rest of
    attributes/extensions, which is not possible with a comment, (...)
    """

Cheers,
Miguel
