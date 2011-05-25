From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] Jbd2: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 18:49:57 +0800
Message-ID: <BANLkTikbgiS+3U9HXRoLOxWih=pGJ2rHgQ@mail.gmail.com>
References: <-1724257416234743088@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Ding Dinghua <dingdinghua@nrchpc.ac.cn>
To: y@mx.nrchpc.ac.cn
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62250 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1EYKt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 06:49:58 -0400
Received: by vws1 with SMTP id 1so5665978vws.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 03:49:57 -0700 (PDT)
In-Reply-To: <-1724257416234743088@unknownmsgid>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: line was missed.

On Wed, May 25, 2011 at 6:19 PM,  <y@mx.nrchpc.ac.cn> wrote:
> From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
>
> drop jh->b_jcount in error path
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
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
