Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33875 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbeJVR7N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 13:59:13 -0400
Received: by mail-yb1-f195.google.com with SMTP id n140-v6so1025060yba.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 02:41:27 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id k2-v6sm8765513ywh.52.2018.10.22.02.41.26
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 02:41:26 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id n140-v6so1025042yba.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 02:41:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANiq72mXV6WTyHXNZJDTfFOpPrXD0zD6cB30bGOuKO44AvRiog@mail.gmail.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com> <20181021222712.GI1617@thunk.org>
 <CANiq72mXV6WTyHXNZJDTfFOpPrXD0zD6cB30bGOuKO44AvRiog@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 22 Oct 2018 02:34:13 -0700
Message-ID: <CAGXu5jKb-0H+smRAW6ngQKDZ-PbTThhMwhmu34iB8vjTa-4H8Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
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
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 2:26 AM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Mon, Oct 22, 2018 at 12:27 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>>
>> On Sun, Oct 21, 2018 at 07:14:13PM +0200, Miguel Ojeda wrote:
>> > From the GCC manual:
>> >
>> >   fallthrough
>> >
>> >     The fallthrough attribute with a null statement serves as a
>> >     fallthrough statement. It hints to the compiler that a statement
>> >     that falls through to another case label, or user-defined label
>> >     in a switch statement is intentional and thus the -Wimplicit-fallthrough
>> >     warning must not trigger. The fallthrough attribute may appear
>> >     at most once in each attribute list, and may not be mixed with
>> >     other attributes. It can only be used in a switch statement
>> >     (the compiler will issue an error otherwise), after a preceding
>> >     statement and before a logically succeeding case label,
>> >     or user-defined label.
>> >
>> >   https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html

Please CC Gustavo on these kinds of things -- he's been driving the
bulk of the fall through coverage.

>> Do we know if coverity understands the fallthrough attribute?  One of
>> the reasons why I started using /* fallthrough */ is because it kept
>> Coverity happy.
>
> If Coverity is like gcc, they should be doing both (i.e. I see the
> comment parsing as an "extra" that gcc did, but the "basic stuff" is
> the attribute -- and I would guess it is way easier for them to
> support than the comment parsing).
>
> But I cannot test it myself :-( Someone, please?
>
> However, if I understood Greg correctly in his reply to the cover
> letter, he replied that Coverity knows about it (?).
>
>>
>> If the conversion from /* fallthrough */ to the __fallthrough__
>> attribute means that we start gethting a lot of Coverity warnings,
>> that would be unfortunate.  OTOH, if this is getting standardized,
>> maybe we can get Coverity to understand this attribute?
>
> Indeed! That would be the best for everyone, including Coverity customers.

We need to make sure the static analyzers are happy with either
method. Additionally, when was -Wimplicit-fallthrough added to GCC? If
it was added _before_ the attribute, we need to continue using the
comment style otherwise we lose coverage even with gcc itself.
Additionally, does Clang support this attribute (it supports
-Wimplicit-fallthrough).

-Kees

-- 
Kees Cook
Pixel Security
