Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:35374 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbeJVPY0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Oct 2018 11:24:26 -0400
Date: Mon, 22 Oct 2018 09:05:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
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
        David Rientjes <rientjes@google.com>,
        Martin Sebor <msebor@gmail.com>,
        Christopher Li <sparse@chrisli.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
Message-ID: <20181022070547.GA22454@1wt.eu>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
 <20181022004217.GA4941@bombadil.infradead.org>
 <20181022065800.GK1617@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022065800.GK1617@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 02:58:00AM -0400, Theodore Y. Ts'o wrote:
> On Sun, Oct 21, 2018 at 05:42:18PM -0700, Matthew Wilcox wrote:
> > On Sun, Oct 21, 2018 at 07:14:13PM +0200, Miguel Ojeda wrote:
> > > +#if __has_attribute(__fallthrough__)
> > > +# define __fallthrough                  __attribute__((__fallthrough__))
> > > +#else
> > > +# define __fallthrough
> > > +#endif
> > 
> > Why is the #else not:
> > 
> > # define __fallthrough		/* fallthrough */
> > 
> > Would this solve the Coverity problem, or does Coverity look at the raw
> > source code before preprocessing?
> 
> Wouldn't the "/* ... */" be eaten by the preprocessor before defining
> the __fallthrough cpp macro?  (e.g., try running the attached script)

You're right, even on older versions (4.7 here) :

$ echo -e '#define foobar quux /* foobar */\nfoobar\n' | gcc -E -
# 1 "<stdin>"
# 1 "<command-line>"
# 1 "<stdin>"

quux

Willy
