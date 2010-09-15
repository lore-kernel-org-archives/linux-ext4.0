From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] block: Make blkdev_issue_discard() interruptible
Date: Wed, 15 Sep 2010 10:59:25 -0400
Message-ID: <AANLkTinmJyJOqgSe6G0RiNUgT59wtxeT6y+0b3GivQem@mail.gmail.com>
References: <1284561161-22278-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
	linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37995 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0IOO7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Sep 2010 10:59:46 -0400
In-Reply-To: <1284561161-22278-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 15, 2010 at 10:32 AM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> Since the discard may take quite long time, especially with really bi=
g
> extents (like the whole device for example), it would be nice to give=
 to
> users the opportunity to abort it. This is especially useful for mkfs=
,
> when user can not know in advance how long it will take.
>
> In conjunction with mke2fs patch "Inform user about ongoing discard"
> it gives the user all the comfort of being informed about discard and
> being able to abort the operation.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> =A0block/blk-lib.c | =A0 =A05 +++++
> =A01 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index d0216b9..4f54a1a 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -102,6 +102,11 @@ int blkdev_issue_discard(struct block_device *bd=
ev, sector_t sector,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (!bio_flagged(bio, BIO_UPTODAT=
E))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_put(bio);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (signal_pending(current)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ERESTARTSYS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return ret;
> =A0out_free_page:

Neil Brown recently suggested the use of fatal_signal_pending() rather
than signal_epnding() in another thread:
http://lkml.org/lkml/2010/9/12/232

I think Neil's suggestion applies here too?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
