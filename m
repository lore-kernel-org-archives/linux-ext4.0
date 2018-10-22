Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46926 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeJVW2z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 18:28:55 -0400
Received: by mail-yb1-f193.google.com with SMTP id o8-v6so16199609ybk.13
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 07:10:10 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id o3-v6sm172018ywe.79.2018.10.22.07.10.06
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 07:10:08 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id o204-v6so2182242yba.9
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 07:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com> <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 22 Oct 2018 07:10:02 -0700
Message-ID: <CAGXu5j+3pR2mfcdbURv7MrPxUVjmjQEDRHH8BLpTNGiasJs1pg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Compiler Attributes: auxdisplay: panel: use __fallthrough
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        "Theodore Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 21, 2018 at 10:14 AM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> Let gcc know these cases are meant to fall through to the next label
> by annotating them with the new __fallthrough statement attribute;
> and remove the comment since it conveys the same information
> (which was also parsed by gcc to suppress the warning).
>
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> ---
>  drivers/auxdisplay/panel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/auxdisplay/panel.c b/drivers/auxdisplay/panel.c
> index 21b9b2f2470a..0755034e49ba 100644
> --- a/drivers/auxdisplay/panel.c
> +++ b/drivers/auxdisplay/panel.c
> @@ -1367,7 +1367,7 @@ static void panel_process_inputs(void)
>                                 break;
>                         input->rise_timer = 0;
>                         input->state = INPUT_ST_RISING;
> -                       /* fall through */
> +                       __fallthrough;
>                 case INPUT_ST_RISING:
>                         if ((phys_curr & input->mask) != input->value) {
>                                 input->state = INPUT_ST_LOW;
> @@ -1380,11 +1380,11 @@ static void panel_process_inputs(void)
>                         }
>                         input->high_timer = 0;
>                         input->state = INPUT_ST_HIGH;
> -                       /* fall through */
> +                       __fallthrough;
>                 case INPUT_ST_HIGH:
>                         if (input_state_high(input))
>                                 break;
> -                       /* fall through */
> +                       __fallthrough;
>                 case INPUT_ST_FALLING:
>                         input_state_falling(input);
>                 }
> --
> 2.17.1
>

I would prefer we continue to use the comment style until we've got
confirmed support for (at least) Clang, Coverity, CPPcheck, smatch,
and eclipse.

-Kees

-- 
Kees Cook
Pixel Security
