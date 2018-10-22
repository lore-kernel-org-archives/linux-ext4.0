Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57058 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbeJVSr7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 14:47:59 -0400
Date: Mon, 22 Oct 2018 13:27:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
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
        David Rientjes <rientjes@google.com>, Willy Tarreau <w@1wt.eu>,
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
Message-ID: <20181022102743.nua5fgbscyeymzal@mwanda>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
 <20181021222712.GI1617@thunk.org>
 <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 11:41:56AM +0200, Bernd Petrovitsch wrote:
> On 22/10/2018 00:27, Theodore Y. Ts'o wrote:
> > On Sun, Oct 21, 2018 at 07:14:13PM +0200, Miguel Ojeda wrote:
> >> From the GCC manual:
> >>
> >>   fallthrough
> >>
> >>     The fallthrough attribute with a null statement serves as a
> >>     fallthrough statement. It hints to the compiler that a statement
> >>     that falls through to another case label, or user-defined label
> >>     in a switch statement is intentional and thus the -Wimplicit-fallthrough
> >>     warning must not trigger. The fallthrough attribute may appear
> >>     at most once in each attribute list, and may not be mixed with
> >>     other attributes. It can only be used in a switch statement
> >>     (the compiler will issue an error otherwise), after a preceding
> >>     statement and before a logically succeeding case label,
> >>     or user-defined label.
> >>
> >>   https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html
> > 
> > Do we know if coverity understands the fallthrough attribute?  One of
> > the reasons why I started using /* fallthrough */ is because it kept
> > Coverity happy.
> 
> FWIW, current "eclipse" has the same "problem".
> 
> > If the conversion from /* fallthrough */ to the __fallthrough__
> > attribute means that we start gethting a lot of Coverity warnings,
> 
> We could keep both.

What does that even mean?  Use both the attribute and the comment until
Eclipse is updated?

	case 3:
		frob();
		__fall_through; /* fall through */
	case 4:

That seems like a wrong idea...

regards,
dan carpenter
