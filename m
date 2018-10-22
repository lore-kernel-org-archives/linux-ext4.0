Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbeJVTN2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 15:13:28 -0400
Date: Mon, 22 Oct 2018 13:53:14 +0300
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
Message-ID: <20181022105314.j6djkrpwbnokhai5@mwanda>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com>
 <20181021222712.GI1617@thunk.org>
 <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
 <20181022102743.nua5fgbscyeymzal@mwanda>
 <1474d995-1b5a-2efb-f077-33eb4a5d9e31@petrovitsch.priv.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474d995-1b5a-2efb-f077-33eb4a5d9e31@petrovitsch.priv.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 12:45:03PM +0200, Bernd Petrovitsch wrote:
> It's more like
> ----  snip  ----
> 	case 3:
> 		frob();
> 		__fall_through;
> 		/* no break - fall through */
> 	case 4:
> ----  snip  ----
> as "eclipse" doesn't accept anything else.
> 
> And yes, it's far from "beautiful" but I hadn't time to dig into
> eclipses innards to fix that.
> 

Doing both is super ugly.  Let's just do comments until Eclipse gets
updated.

I had wanted to move to the attribute because that would simplify things
in Smatch but it's not a huge deal to delay for another year.

regards,
dan carpenter
