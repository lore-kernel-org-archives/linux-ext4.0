Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42716 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbeJVGn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Oct 2018 02:43:58 -0400
Date: Sun, 21 Oct 2018 18:27:12 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20181021222712.GI1617@thunk.org>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 21, 2018 at 07:14:13PM +0200, Miguel Ojeda wrote:
> From the GCC manual:
> 
>   fallthrough
> 
>     The fallthrough attribute with a null statement serves as a
>     fallthrough statement. It hints to the compiler that a statement
>     that falls through to another case label, or user-defined label
>     in a switch statement is intentional and thus the -Wimplicit-fallthrough
>     warning must not trigger. The fallthrough attribute may appear
>     at most once in each attribute list, and may not be mixed with
>     other attributes. It can only be used in a switch statement
>     (the compiler will issue an error otherwise), after a preceding
>     statement and before a logically succeeding case label,
>     or user-defined label.
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html

Do we know if coverity understands the fallthrough attribute?  One of
the reasons why I started using /* fallthrough */ is because it kept
Coverity happy.

If the conversion from /* fallthrough */ to the __fallthrough__
attribute means that we start gethting a lot of Coverity warnings,
that would be unfortunate.  OTOH, if this is getting standardized,
maybe we can get Coverity to understand this attribute?

						- Ted
