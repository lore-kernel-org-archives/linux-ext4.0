From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 3/9] quota: fix e2fsck to notice missing quota entries
Date: Mon, 12 May 2014 23:42:36 -0700
Message-ID: <CAGr1F2Gyw55=X+JGn-6kVgXL-FQUSkSU8oXHFMcYrpZF1VXdWw@mail.gmail.com>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu> <1399782773-20029-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:41390 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEMGm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2014 02:42:56 -0400
Received: by mail-oa0-f54.google.com with SMTP id j17so9442615oag.41
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2014 23:42:56 -0700 (PDT)
In-Reply-To: <1399782773-20029-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good.

On Sat, May 10, 2014 at 9:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Previously if there was a missing quota entry --- i.e., if there were
> files owned by group "eng", but there was no quota record for group
> "eng", e2fsck would not notice the missing entry.  This means that the
> usage informtion would not be properly repaired.  This is unfortunate.
> Fix this by marking each quota record in quota_dict that has a
> corresponding record on disk, and then check to see if there are any
> records in quota_dict that have not been marked as having been seen.
> In that case, we know we need to update the relevant quota inode.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: adityakali@google.com

Reviewed-by: Aditya Kali <adityakali@google.com>

Thanks!

> ---
>  lib/quota/mkquota.c | 17 ++++++++++++++++-
>  lib/quota/quotaio.h |  2 ++
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
> index f77e072..f5ae0e0 100644
> --- a/lib/quota/mkquota.c
> +++ b/lib/quota/mkquota.c
> @@ -458,6 +458,7 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
>
>         dq = get_dq(quota_dict, dquot->dq_id);
>         dq->dq_id = dquot->dq_id;
> +       dq->dq_flags |= DQF_SEEN;
>
>         print_dquot("mem", dq);
>         print_dquot("dsk", dquot);
> @@ -572,10 +573,13 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>         ext2_filsys fs = qctx->fs;
>         struct quota_handle qh;
>         struct scan_dquots_data scan_data;
> +       struct dquot *dq;
> +       dnode_t *n;
> +       dict_t *dict = qctx->quota_dict[qtype];
>         ext2_ino_t qf_ino;
>         errcode_t err = 0;
>
> -       if (!qctx->quota_dict[qtype])
> +       if (!dict)
>                 goto out;
>
>         qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
> @@ -595,6 +599,17 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>                 log_err("Error scanning dquots");
>                 goto out;
>         }
> +
> +       for (n = dict_first(dict); n; n = dict_next(dict, n)) {
> +               dq = dnode_get(n);
> +               if (!dq)
> +                       continue;
> +               if ((dq->dq_flags & DQF_SEEN) == 0) {
> +                       fprintf(stderr, "[QUOTA WARNING] "
> +                               "Missing quota entry ID %d\n", dq->dq_id);
> +                       scan_data.usage_is_inconsistent = 1;
> +               }
> +       }
>         *usage_inconsistent = scan_data.usage_is_inconsistent;
>
>  out:
> diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
> index 1c062f1..55e6eb0 100644
> --- a/lib/quota/quotaio.h
> +++ b/lib/quota/quotaio.h
> @@ -104,6 +104,8 @@ struct dquot {
>         struct util_dqblk dq_dqb;       /* Parsed data of dquot */
>  };
>
> +#define DQF_SEEN       0x0001
> +
>  /* Structure of quotafile operations */
>  struct quotafile_ops {
>         /* Check whether quotafile is in our format */
> --
> 1.9.0
>



-- 
Aditya
