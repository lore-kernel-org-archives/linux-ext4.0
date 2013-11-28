From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] ext4: Do not reserve clusters when fs doesn't support extents
Date: Thu, 28 Nov 2013 13:47:04 +0100
Message-ID: <CAMuHMdWFsK0pfuigxPbhptz8myGqGMHPT8adRXnweQX_=gu5DQ@mail.gmail.com>
References: <1385638965-14674-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55790 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3K1MrF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Nov 2013 07:47:05 -0500
Received: by mail-pd0-f174.google.com with SMTP id y13so11981744pdi.19
        for <linux-ext4@vger.kernel.org>; Thu, 28 Nov 2013 04:47:04 -0800 (PST)
In-Reply-To: <1385638965-14674-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Thu, Nov 28, 2013 at 12:42 PM, Jan Kara <jack@suse.cz> wrote:
> When filesystem doesn't support extents (like in ext2/3 compatibility
> modes), there is no need to reserve any clusters. Space estimates for
> writing are exact, hole punching doesn't need new metadata, and there
> are no unwritten extents to convert.
>
> This fixes a problem when filesystem still having some free space when
> accessed with a native ext2/3 driver suddently reports ENOSPC when
> accessed with ext4 driver.

Thanks, fixed!

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
