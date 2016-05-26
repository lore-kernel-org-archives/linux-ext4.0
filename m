From: Filipe Brandenburger <filbranden@google.com>
Subject: Re: [PATCH e2fsprogs] Apply LDFLAGS when building tests in lib/e2p
Date: Thu, 26 May 2016 10:47:54 -0700
Message-ID: <CADU+-uBOXVHUUX4f3xjJmzdDpLwUGNao2R9pKSunMsUKoaqfxw@mail.gmail.com>
References: <1462578003-25315-1-git-send-email-filbranden@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Eric Christopher <echristo@google.com>,
	Michael Forney <forney@google.com>,
	Filipe Brandenburger <filbranden@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34432 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbcEZRr4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2016 13:47:56 -0400
Received: by mail-vk0-f43.google.com with SMTP id c189so112124100vkb.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 May 2016 10:47:56 -0700 (PDT)
In-Reply-To: <1462578003-25315-1-git-send-email-filbranden@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Can you please include this patch in upstream e2fsprogs git repo?

This is a complement for 53904ae543591a which added LDFLAGS to the
test cases but seemed to miss these two...

Thank you!
Filipe


On Fri, May 6, 2016 at 4:40 PM, Filipe Brandenburger
<filbranden@google.com> wrote:
> This was previously addressed by Michael Forney on commit 53904ae543591a
> but it seems the test cases from lib/e2p (tst_ostype and tst_feature)
> were missed.
>
> Fix them by adding the same $(ALL_LDFLAGS) to those two targets.
>
> Tested by building it on a system that depends on LDFLAGS to produce
> working binaries and confirming that `make check` succeeds.
>
> Reported-by: Eric Christopher <echristo@google.com>
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
>  lib/e2p/Makefile.in | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
> index 83f04ff5c04e..d109bf190051 100644
> --- a/lib/e2p/Makefile.in
> +++ b/lib/e2p/Makefile.in
> @@ -68,12 +68,12 @@ e2p.pc: $(srcdir)/e2p.pc.in $(top_builddir)/config.status
>  tst_ostype: $(srcdir)/ostype.c
>         $(E) "  LD $@"
>         $(Q) $(CC) -DTEST_PROGRAM -I$(top_srcdir)/lib -o tst_ostype \
> -               $(srcdir)/ostype.c $(ALL_CFLAGS)
> +               $(srcdir)/ostype.c $(ALL_CFLAGS) $(ALL_LDFLAGS)
>
>  tst_feature: $(srcdir)/feature.c
>         $(E) "  LD $@"
>         $(Q) $(CC) -DTEST_PROGRAM -I$(top_srcdir)/lib -o tst_feature \
> -               $(srcdir)/feature.c $(ALL_CFLAGS)
> +               $(srcdir)/feature.c $(ALL_CFLAGS) $(ALL_LDFLAGS)
>
>  check::        tst_ostype tst_feature
>         ./tst_ostype
> --
> 2.8.0.rc3.226.g39d4020
>
