Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33820 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeJWEQn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2018 00:16:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id g12-v6so19514344pgs.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2018 12:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-2-miguel.ojeda.sandonis@gmail.com> <20181021222712.GI1617@thunk.org>
 <8fb78062-b6d4-6f2d-d943-44bec6b95ff0@petrovitsch.priv.at>
 <20181022102743.nua5fgbscyeymzal@mwanda> <1474d995-1b5a-2efb-f077-33eb4a5d9e31@petrovitsch.priv.at>
 <20181022105314.j6djkrpwbnokhai5@mwanda> <CANiq72=ioYcRA-yq38+Z4i6iVDNm6C2-+b4feRmnvEiekuR7dA@mail.gmail.com>
 <3cbb5345-0270-5575-7563-6ad37d888e42@petrovitsch.priv.at>
 <CAKwvOdnWkPi_2UJ7VKYZ6cuWi+BDgpEUf+tcrfZLUYawbm+grw@mail.gmail.com> <9c52827b-4783-8f39-9030-a166d5436f05@petrovitsch.priv.at>
In-Reply-To: <9c52827b-4783-8f39-9030-a166d5436f05@petrovitsch.priv.at>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 22 Oct 2018 12:56:37 -0700
Message-ID: <CAKwvOd=_mnxnG3cFb6qBhO5KLFxjrgsavoQ37asY3O1B4LLkwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Compiler Attributes: add support for __fallthrough
 (gcc >= 7.1)
To: bernd@petrovitsch.priv.at
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 22, 2018 at 11:15 AM Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
>
> Hi all!
>
> On 22/10/18 19:54, Nick Desaulniers wrote:
> > On Mon, Oct 22, 2018 at 10:50 AM Bernd Petrovitsch
> > <bernd@petrovitsch.priv.at> wrote:
> [...]
> >> PS: clang++ errors with "fallthrough annotation in unreachable code" if
> >>     [[fallthrough]] is after an assert(). clang-devs there, please, the
> >>     fallthrough doesn't really generated code (I hope;-).
> [...]
> > Can you send me a link to a simple reproducer in godbolt (godbolt.org)
> > and we'll take a look?
>
> Does https://godbolt.org/z/2Y4zIo do it - I'm a godbolt-newbie?

Moving the kernel folks to bcc, since we don't need to be discussing
C++ on LKML.
https://godbolt.org/z/B1fo9Z shows that this works as intended, for
cases that cannot be statically proven.  I guess I'm looking for a
more realistic code sample to show why putting a `break;` statement
there is untenable?

>
> For
> ----  snip  ----
> #include <cassert>
>
> int main(void)
> {
>   switch (1) {
>   default:
>     assert(0);
>     [[fallthrough]];
>   case 1:
>     ;
>   }
>   return 0;
> }
> ----  snip  ----
> Just "clang++ -Wimplicit-fallthrough -Werror" it .....
>
> MfG,
>         Bernd
> --
> "I dislike type abstraction if it has no real reason. And saving
> on typing is not a good reason - if your typing speed is the main
> issue when you're coding, you're doing something seriously wrong."
>     - Linus Torvalds



-- 
Thanks,
~Nick Desaulniers
