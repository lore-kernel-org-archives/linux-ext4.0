From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] Jbd: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 19:37:11 +0800
Message-ID: <BANLkTik=B08XzLViSD10Z_bac6R5DqswmA@mail.gmail.com>
References: <1306318841-8363-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56804 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1EYLhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 07:37:11 -0400
Received: by vxi39 with SMTP id 39so5665050vxi.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 04:37:11 -0700 (PDT)
In-Reply-To: <1306318841-8363-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

m/N means that there are N patches and this patch is the mst one. e.g.
2/30 means the patch series contain 30 patches and this is the 2nd
one.

When a patch is resent, you'd better send it with [PACH vm], where m
is the version number.

Again, you missed Signed-off-by: line.

On Wed, May 25, 2011 at 6:20 PM, Ding Dinghua <dingdinghua@nrchpc.ac.cn=
> wrote:
> drop jh->b_jcount in error path
> ---
> =A0fs/jbd/transaction.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 60d2319..3f7bf84 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -843,8 +843,8 @@ int journal_get_create_access(handle_t *handle, s=
truct buffer_head *bh)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0JBUFFER_TRACE(jh, "cancelling revoke");
> =A0 =A0 =A0 =A0journal_cancel_revoke(handle, jh);
> - =A0 =A0 =A0 journal_put_journal_head(jh);
> =A0out:
> + =A0 =A0 =A0 journal_put_journal_head(jh);
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
