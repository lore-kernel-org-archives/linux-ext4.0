From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
Date: Mon, 25 Jul 2011 16:25:39 +0300
Message-ID: <CAOQ4uxhGceySNm7-d=NdjPVZDsb4Pi8Gobf145zdDomZqhJCyQ@mail.gmail.com>
References: <4E2D6961.9000909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GYNZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 09:25:41 -0400
In-Reply-To: <4E2D6961.9000909@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 4:02 PM, Wang Sheng-Hui <shhuiw@gmail.com> wrot=
e:
> The patch is against 3.0
>
> In the definition of struct journal_head, the comment for
> the field "unsigned b_cow_tid" says the field tracks the
> last transaction id in which this buffer has been cowed.
>
> In the header part of file journal-head.h, it defines
> =A0 typedef unsigned int =A0tid_t;
> We should use type tid_t to define transaction id fields.
>
> Change the field "b_cow_tid" of struct journal_head from
> type unsigned to tid_t.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

my bad.

Acked-by: Amir Goldstein <amir73il@users.sf.net>

> ---
> =A0include/linux/journal-head.h | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/journal-head.h b/include/linux/journal-hea=
d.h
> index 44e95d0..423cb6d 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -45,7 +45,7 @@ struct journal_head {
> =A0 =A0 =A0 =A0 * has been cowed
> =A0 =A0 =A0 =A0 * [jbd_lock_bh_state()]
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 unsigned b_cow_tid;
> + =A0 =A0 =A0 tid_t b_cow_tid;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Copy of the buffer data frozen for writing to the l=
og.
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
