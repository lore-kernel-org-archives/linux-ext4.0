Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:48852 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727794AbeJVCdV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Oct 2018 22:33:21 -0400
Message-ID: <f46baa5bb0e3373c89d09b6e0d15170902e5f55c.camel@perches.com>
Subject: Re: [PATCH 2/2] Compiler Attributes: auxdisplay: panel: use
 __fallthrough
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
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
        Theodore Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Sun, 21 Oct 2018 11:11:36 -0700
In-Reply-To: <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
         <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2018-10-21 at 19:14 +0200, Miguel Ojeda wrote:
> Let gcc know these cases are meant to fall through to the next label
> by annotating them with the new __fallthrough statement attribute;
> and remove the comment since it conveys the same information
> (which was also parsed by gcc to suppress the warning).

Instead of many individual conversion patches,
perhaps a script to do all the conversions at once.

Maybe:

pattern='(?:\/\*\s*fall(?:\s*|\s*\-\s*)thr(?:u|ough)\s*\*\/|\/\/\s*fall\s*thr(?:u|ough)\s*$)'
git grep -P -i --name-only "$pattern" -- '*.[ch]' |
    xargs perl -p -i -e "s/$pattern/__fallthrough;/gi"
