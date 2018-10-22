Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46250 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeJWFoN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2018 01:44:13 -0400
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021182926.GB6683@kroah.com> <CANiq72kOE0a4M0oCmmiWO9xTFJsybEirwUyb_ZTXpJJhc7O_TA@mail.gmail.com>
 <CAKwvOdn9hOcF01eOmwfnrH_ciFZ4fPaspSzMPiY68o3B0En-VQ@mail.gmail.com>
In-Reply-To: <CAKwvOdn9hOcF01eOmwfnrH_ciFZ4fPaspSzMPiY68o3B0En-VQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 22 Oct 2018 23:23:45 +0200
Message-ID: <CANiq72ktOU91ghnT4eRPvBzO-xq3_Kq-RCyCB1_VSf2b+17YXw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Compiler Attributes: __fallthrough
To: Nick Desaulniers <ndesaulniers@google.com>
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
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 6:54 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Oct 22, 2018 at 2:48 AM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> > On Sun, Oct 21, 2018 at 8:29 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > Will this work with all of the static tools that are currently looking
> > > for the comment instead?  I know coverity handles that, what about
> > > others?
> >
> > I will also contact the different tools about this.
>
> Let's contact the authors of these tools if they don't parse the
> attribute.  I prefer to have the attributes rather than specifically
> formatted comments.

Sorry, not sure what you mean -- isn't that what I said? Greg was
asking whether tools would support the attribute equally well compared
to the comment parsing; not the comments.

>
> I do think this may be tricky to provide backwards support for though;
> Miguel, do you have info on which versions of GCC support comments vs
> attribute?

It is in the commit message:

    """
    In C mode, GCC supports the __fallthrough__ attribute since 7.1,
    the same time the warning and the comment parsing were introduced.
    """

Cheers,
Miguel
