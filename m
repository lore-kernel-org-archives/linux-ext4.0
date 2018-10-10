Return-Path: <SRS0=q/KL=MW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35619 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJKDHb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2018 23:07:31 -0400
MIME-Version: 1.0
References: <20181010142813.1918180-1-arnd@arndb.de> <20181010192658.GA27646@thunk.org>
In-Reply-To: <20181010192658.GA27646@thunk.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 10 Oct 2018 21:43:39 +0200
Message-ID: <CANiq72nGxH=PTwiEQARiN-iminwECAMYe6-GJzCUh+V0mJ-=YQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: avoid unused variable warning
To: "Ted Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>, jack@suse.cz,
        Eric Biggers <ebiggers@google.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Wed, Oct 10, 2018 at 9:27 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Oct 10, 2018 at 04:27:58PM +0200, Arnd Bergmann wrote:
> > The two new variables are only used in an #ifdef, so they cause a
> > warning without CONFIG_QUOTA:
> >
> > fs/ext4/super.c: In function 'parse_options':
> > fs/ext4/super.c:1977:26: error: unused variable 'grp_qf_name' [-Werror=unused-variable]
> >   char *p, *usr_qf_name, *grp_qf_name;
> >                           ^~~~~~~~~~~
> > fs/ext4/super.c:1977:12: error: unused variable 'usr_qf_name' [-Werror=unused-variable]
> >   char *p, *usr_qf_name, *grp_qf_name;
> >
> > Fixes: 20cefcdc2040 ("ext4: fix use-after-free race in ext4_remount()'s error path")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hmm, I wonder if we should do something like:
>
> #define EXT4_UNUSED_VAR __attribute__ ((unused))

We have __maybe_unused already, so you can go ahead! :-)

(Also __always_unused, same definition as well, but here it does not may sense).

>
> and then we could do:
>
>         char *p, *usr_qf_name EXT4_UNUSED_VAR, *grp_qf_name EXT4_UNUSED_VAR;
>
> More generally, I wonder if this is something we should have defined
> for the whole kernel, as opposed to a one-off hack that ACPI and ext4
> subsystems use.  It's a little ugly, but I think it's much nicer than
> having extra #ifdefs such as:
>
>         char *p;
> #ifdef CONFIG_QUOTA
>         char *usr_qf_name, *grp_qf_name;
> #endif
>
> After all, the compiler is perfectly capable of ignoring variables
> which are unused.  And if it's only because of an #ifdef later in the
> function, it would be nice to not have an extra #ifdef in the variable
> declarations.

Indeed, it looks clean --- I like it.

Although I am not sure how people will feel about that :-) Someone may
argue that, for consistency, we shouldn't, because inside structs we
have to use #ifdefs still.

Cheers,
Miguel
