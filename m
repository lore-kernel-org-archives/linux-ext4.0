From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Wed, 21 Jul 2010 12:21:17 +0300
Message-ID: <AANLkTinVzQizMo73ZVSL545_tucybjmoUUzyLSWtjqxR@mail.gmail.com>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
	<AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
	<20100720163825.GC12998@quack.suse.cz>
	<AANLkTikIpmopbJvdvm9cafuLYbtQkBlHhhL7u0PACPZQ@mail.gmail.com>
	<AANLkTinbXP4klNS1LScsCQqyEALMYxq9iS5DwOwFJduf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0GUJVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 05:21:18 -0400
Received: by fxm14 with SMTP id 14so3357909fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jul 2010 02:21:17 -0700 (PDT)
In-Reply-To: <AANLkTinbXP4klNS1LScsCQqyEALMYxq9iS5DwOwFJduf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 12:11 AM, Greg Freemyer <greg.freemyer@gmail.co=
m> wrote:
>
> So are you just asking for comments right now, or are you asking that
> the e2fsprogs patches get applied?
>

I am asking that the patches will get applied. comments are always welc=
ome.

I am looking for 2 types of code review:

1. check that the patch looks good in general and doesn't change
behavior when the snapshot feature is disabled.
that kind of review would approve that the patch may be applied to the
master branch.

2. check the behavior of the code when snapshot feature is enabled.
this requires the reviewer to acquire some knowledge about the design
of the snapshot feature.

> Maybe a separate e2fsprogs branch for next3 should be created like
> there was for the 64-bit patches? =A0(That would be Ted/Jan's call, n=
ot
> mine.)
>

That's not my call, but I do not think that would be necessary.
the next3 e2fsprogs patches are really small and are restricted to a
small number of files.
for that reason, it wasn't so hard for me to rebase them from the
maint branch to the master branch (64bit code).
there is some dependency among the patches, but most of them are small
and independent,
so they don't have to be applied all at once. I also verified that
every sub-series of the patches builds with no errors.

To put it in other words, any review, of any type, of any patch, would
be helpful.
Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
