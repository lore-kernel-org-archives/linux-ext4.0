Return-Path: <SRS0=cyUA=MM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f171.google.com ([209.85.160.171]:44653 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbeI3RuV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Sep 2018 13:50:21 -0400
MIME-Version: 1.0
References: <20180920172301.21868-1-miguel.ojeda.sandonis@gmail.com>
 <20180920172301.21868-14-miguel.ojeda.sandonis@gmail.com> <CAGXu5jKZYEK7Asy4KwtfVVxHLFbpeqpWWEOM-60h7h4gj3JZrw@mail.gmail.com>
In-Reply-To: <CAGXu5jKZYEK7Asy4KwtfVVxHLFbpeqpWWEOM-60h7h4gj3JZrw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 30 Sep 2018 13:17:33 +0200
Message-ID: <CANiq72nvZZAF445cBTiLCX-4EOLD6OsRo0TP8eXgwvBAzakgOA@mail.gmail.com>
Subject: Re: [PATCH v5 13/15] Compiler Attributes: enable -Wstringop-truncation
 on W=1 (gcc >= 8)
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
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

On Thu, Sep 20, 2018 at 9:56 PM Kees Cook <keescook@chromium.org> wrote:
>
> Yessss. :)
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Done! Thanks! :)

Cheers,
Miguel
