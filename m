From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 4/9] quota: fix memory leak in quota_compare_and_update()
Date: Mon, 12 May 2014 23:48:42 -0700
Message-ID: <CAGr1F2FwRLuAtdrJsU+BHaMF05+rihqYW2MfmPCYj-oMm0McOA@mail.gmail.com>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu> <1399782773-20029-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41968 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaEMGtD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2014 02:49:03 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so9389605obc.13
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2014 23:49:02 -0700 (PDT)
In-Reply-To: <1399782773-20029-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 10, 2014 at 9:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The quota_handle wasn't getting closed in quota_compare_and_update().
> Fix this, and also make sure that quota_file_close() doesn't
> unnecessarily modify the quota inode if it's not necessary.  Otherwise
> e2fsck will claim that the file system is modified when it didn't need
> to be.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: adityakali@google.com

Reviewed-by: Aditya Kali <adityakali@google.com>

Thanks!

> ---
>  lib/quota/mkquota.c | 9 ++++++++-
>  lib/quota/quotaio.c | 9 +++++++--
>  2 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
> index f5ae0e0..ed10890 100644
> --- a/lib/quota/mkquota.c
> +++ b/lib/quota/mkquota.c
> @@ -597,7 +597,7 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>         err = qh.qh_ops->scan_dquots(&qh, scan_dquots_callback, &scan_data);
>         if (err) {
>                 log_err("Error scanning dquots");
> -               goto out;
> +               goto out_close_qh;
>         }
>
>         for (n = dict_first(dict); n; n = dict_next(dict, n)) {
> @@ -612,6 +612,13 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>         }
>         *usage_inconsistent = scan_data.usage_is_inconsistent;
>
> +out_close_qh:
> +       err = quota_file_close(&qh);
> +       if (err) {
> +               log_err("Cannot close quotafile: %s", error_message(errno));
> +               if (qh.qh_qf.e2_file)
> +                       ext2fs_file_close(qh.qh_qf.e2_file);
> +       }
>  out:
>         return err;
>  }
> diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
> index 7e98ed7..a95a1f9 100644
> --- a/lib/quota/quotaio.c
> +++ b/lib/quota/quotaio.c
> @@ -356,9 +356,14 @@ errcode_t quota_file_close(struct quota_handle *h)
>         if (h->qh_ops->end_io && h->qh_ops->end_io(h) < 0)
>                 return -1;
>         if (h->qh_qf.e2_file) {
> +               __u64 new_size, size;
> +
> +               new_size = compute_inode_size(h->qh_qf.fs, h->qh_qf.ino);
>                 ext2fs_file_flush(h->qh_qf.e2_file);
> -               ext2fs_file_set_size2(h->qh_qf.e2_file,
> -                       compute_inode_size(h->qh_qf.fs, h->qh_qf.ino));
> +               if (ext2fs_file_get_lsize(h->qh_qf.e2_file, &size))
> +                       new_size = 0;
> +               if (size != new_size)
> +                       ext2fs_file_set_size2(h->qh_qf.e2_file, new_size);
>                 ext2fs_file_close(h->qh_qf.e2_file);
>         }
>
> --
> 1.9.0
>



-- 
Aditya
