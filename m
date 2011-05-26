From: =?GB2312?B?tqG2qLuq?= <dingdinghua@nrchpc.ac.cn>
Subject: Re: [PATCH 1/2] jbd2: fix a bug of leaking jh->b_jcount
Date: Thu, 26 May 2011 10:10:22 +0800
Message-ID: <BANLkTin1zCqFEOqymAXcFaBCs20U4RSmYQ@mail.gmail.com>
References: <1306375374-12619-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53987 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1EZCKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 22:10:22 -0400
Received: by pwi15 with SMTP id 15so137238pwi.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 19:10:22 -0700 (PDT)
In-Reply-To: <1306375374-12619-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

oops, I still forget to add signoff line, please ignore this patch,
i will resend it.

2011/5/26  <dingdinghua@nrchpc.ac.cn>:
> From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
>
> jbd2_journal_get_create_access should drop jh->b_jount in error
> handling path
> ---
> =A0fs/jbd2/transaction.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..d66672a 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -921,8 +921,8 @@ int jbd2_journal_get_create_access(handle_t *hand=
le, struct buffer_head *bh)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0JBUFFER_TRACE(jh, "cancelling revoke");
> =A0 =A0 =A0 =A0jbd2_journal_cancel_revoke(handle, jh);
> - =A0 =A0 =A0 jbd2_journal_put_journal_head(jh);
> =A0out:
> + =A0 =A0 =A0 jbd2_journal_put_journal_head(jh);
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
