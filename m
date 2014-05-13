From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 6/9] quota: support storing the quota file handles in the
 quota context
Date: Tue, 13 May 2014 00:10:37 -0700
Message-ID: <CAGr1F2FZRL9Vuaem1cb+o4R4yBDurt7hUTUaf1k-sifw+y=XQw@mail.gmail.com>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu> <1399782773-20029-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:43428 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaEMHK6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2014 03:10:58 -0400
Received: by mail-oa0-f48.google.com with SMTP id i4so9455571oah.21
        for <linux-ext4@vger.kernel.org>; Tue, 13 May 2014 00:10:57 -0700 (PDT)
In-Reply-To: <1399782773-20029-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 10, 2014 at 9:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This makes memory management easier because when the quota context is
> released, all of the quota file handles get released automatically.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: adityakali@google.com

Reviewed-by: Aditya Kali <adityakali@google.com>

Thanks!

> ---
>  lib/quota/mkquota.c | 26 ++++++++++++++++---------
>  lib/quota/quotaio.c | 55 +++++++++++++++++++++++++++++++++++++++++++----------
>  lib/quota/quotaio.h |  6 ++++--
>  3 files changed, 66 insertions(+), 21 deletions(-)
>
> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
> index bb8482b..58803d0 100644
> --- a/lib/quota/mkquota.c
> +++ b/lib/quota/mkquota.c
> @@ -183,7 +183,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
>                 }
>
>                 write_dquots(dict, h);
> -               retval = quota_file_close(h);
> +               retval = quota_file_close(qctx, h);
>                 if (retval < 0) {
>                         log_err("Cannot finish IO on new quotafile: %s",
>                                 strerror(errno));
> @@ -251,9 +251,10 @@ static void quota_dnode_free(dnode_t *node,
>   */
>  errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
>  {
> -       int     i, err = 0;
> +       errcode_t err;
>         dict_t  *dict;
>         quota_ctx_t ctx;
> +       int     i;
>
>         err = ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
>         if (err) {
> @@ -263,6 +264,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
>
>         memset(ctx, 0, sizeof(struct quota_ctx));
>         for (i = 0; i < MAXQUOTAS; i++) {
> +               ctx->quota_file[i] = NULL;
>                 if ((qtype != -1) && (i != qtype))
>                         continue;
>                 err = ext2fs_get_mem(sizeof(dict_t), &dict);
> @@ -283,6 +285,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
>
>  void quota_release_context(quota_ctx_t *qctx)
>  {
> +       errcode_t err;
>         dict_t  *dict;
>         int     i;
>         quota_ctx_t ctx;
> @@ -298,6 +301,14 @@ void quota_release_context(quota_ctx_t *qctx)
>                         dict_free_nodes(dict);
>                         free(dict);
>                 }
> +               if (ctx->quota_file[i]) {
> +                       err = quota_file_close(ctx, ctx->quota_file[i]);
> +                       if (err) {
> +                               log_err("Cannot close quotafile: %s",
> +                                       strerror(errno));
> +                               ext2fs_free_mem(&ctx->quota_file[i]);
> +                       }
> +               }
>         }
>         *qctx = NULL;
>         free(ctx);
> @@ -541,7 +552,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
>                 return err;
>         }
>
> -       err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, 0);
> +       err = quota_file_open(qctx, qh, qf_ino, type, -1, 0);
>         if (err) {
>                 log_err("Open quota file failed");
>                 goto out;
> @@ -549,7 +560,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
>
>         quota_read_all_dquots(qh, qctx, 1);
>
> -       err = quota_file_close(qh);
> +       err = quota_file_close(qctx, qh);
>         if (err) {
>                 log_err("Cannot finish IO on new quotafile: %s",
>                         strerror(errno));
> @@ -575,15 +586,12 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>         struct dquot *dq;
>         dnode_t *n;
>         dict_t *dict = qctx->quota_dict[qtype];
> -       ext2_ino_t qf_ino;
>         errcode_t err = 0;
>
>         if (!dict)
>                 goto out;
>
> -       qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
> -                                    fs->super->s_grp_quota_inum;
> -       err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
> +       err = quota_file_open(qctx, &qh, 0, qtype, -1, 0);
>         if (err) {
>                 log_err("Open quota file failed");
>                 goto out;
> @@ -612,7 +620,7 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>         *usage_inconsistent = scan_data.usage_is_inconsistent;
>
>  out_close_qh:
> -       err = quota_file_close(&qh);
> +       err = quota_file_close(qctx, &qh);
>         if (err) {
>                 log_err("Cannot close quotafile: %s", error_message(errno));
>                 if (qh.qh_qf.e2_file)
> diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
> index a95a1f9..65fccaa 100644
> --- a/lib/quota/quotaio.c
> +++ b/lib/quota/quotaio.c
> @@ -197,11 +197,16 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
>  /*
>   * Detect quota format and initialize quota IO
>   */
> -errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
> +errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
>                           ext2_ino_t qf_ino, int type, int fmt, int flags)
>  {
> +       ext2_filsys fs = qctx->fs;
>         ext2_file_t e2_file;
>         errcode_t err;
> +       int allocated_handle = 0;
> +
> +       if (type >= MAXQUOTAS)
> +               return EINVAL;
>
>         if (fmt == -1)
>                 fmt = QFMT_VFS_V1;
> @@ -210,18 +215,42 @@ errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
>         if (err)
>                 return err;
>
> +       if (qf_ino == 0) {
> +               if (type == USRQUOTA)
> +                       qf_ino = fs->super->s_usr_quota_inum;
> +               else
> +                       qf_ino = fs->super->s_grp_quota_inum;
> +       }
> +
>         log_debug("Opening quota ino=%lu, type=%d", qf_ino, type);
>         err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
>         if (err) {
>                 log_err("ext2fs_file_open failed: %s", error_message(err));
>                 return err;
>         }
> -       h->qh_qf.e2_file = e2_file;
>
> +       if (!h) {
> +               if (qctx->quota_file[type]) {
> +                       h = qctx->quota_file[type];
> +                       if (((flags & EXT2_FILE_WRITE) == 0) ||
> +                           (h->qh_file_flags & EXT2_FILE_WRITE))
> +                               return 0;
> +                       (void) quota_file_close(qctx, h);
> +               }
> +               err = ext2fs_get_mem(sizeof(struct quota_handle), &h);
> +               if (err) {
> +                       log_err("Unable to allocate quota handle");
> +                       return err;
> +               }
> +               allocated_handle = 1;
> +       }
> +
> +       h->qh_qf.e2_file = e2_file;
>         h->qh_qf.fs = fs;
>         h->qh_qf.ino = qf_ino;
>         h->e2fs_write = quota_write_nomount;
>         h->e2fs_read = quota_read_nomount;
> +       h->qh_file_flags = flags;
>         h->qh_io_flags = 0;
>         h->qh_type = type;
>         h->qh_fmt = fmt;
> @@ -231,17 +260,22 @@ errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
>         if (h->qh_ops->check_file &&
>             (h->qh_ops->check_file(h, type, fmt) == 0)) {
>                 log_err("qh_ops->check_file failed");
> -               ext2fs_file_close(e2_file);
> -               return -1;
> +               goto errout;
>         }
>
>         if (h->qh_ops->init_io && (h->qh_ops->init_io(h) < 0)) {
>                 log_err("qh_ops->init_io failed");
> -               ext2fs_file_close(e2_file);
> -               return -1;
> +               goto errout;
>         }
> +       if (allocated_handle)
> +               qctx->quota_file[type] = h;
>
>         return 0;
> +errout:
> +       ext2fs_file_close(e2_file);
> +       if (allocated_handle)
> +               ext2fs_free_mem(&h);
> +       return -1;
>  }
>
>  static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
> @@ -307,12 +341,12 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
>                 goto out_err;
>         }
>         h->qh_qf.ino = qf_inum;
> +       h->qh_file_flags = EXT2_FILE_WRITE | EXT2_FILE_CREATE;
>         h->e2fs_write = quota_write_nomount;
>         h->e2fs_read = quota_read_nomount;
>
>         log_debug("Creating quota ino=%lu, type=%d", qf_inum, type);
> -       err = ext2fs_file_open(fs, qf_inum,
> -                       EXT2_FILE_WRITE | EXT2_FILE_CREATE, &e2_file);
> +       err = ext2fs_file_open(fs, qf_inum, h->qh_file_flags, &e2_file);
>         if (err) {
>                 log_err("ext2fs_file_open failed: %d", err);
>                 goto out_err;
> @@ -345,7 +379,7 @@ out_err:
>  /*
>   * Close quotafile and release handle
>   */
> -errcode_t quota_file_close(struct quota_handle *h)
> +errcode_t quota_file_close(quota_ctx_t qctx, struct quota_handle *h)
>  {
>         if (h->qh_io_flags & IOFL_INFODIRTY) {
>                 if (h->qh_ops->write_info && h->qh_ops->write_info(h) < 0)
> @@ -366,7 +400,8 @@ errcode_t quota_file_close(struct quota_handle *h)
>                         ext2fs_file_set_size2(h->qh_qf.e2_file, new_size);
>                 ext2fs_file_close(h->qh_qf.e2_file);
>         }
> -
> +       if (qctx->quota_file[h->qh_type] == h)
> +               ext2fs_free_mem(&qctx->quota_file[h->qh_type]);
>         return 0;
>  }
>
> diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
> index d3820a4..7ca7830 100644
> --- a/lib/quota/quotaio.h
> +++ b/lib/quota/quotaio.h
> @@ -53,6 +53,7 @@ typedef struct quota_ctx *quota_ctx_t;
>  struct quota_ctx {
>         ext2_filsys     fs;
>         dict_t          *quota_dict[MAXQUOTAS];
> +       struct quota_handle *quota_file[MAXQUOTAS];
>  };
>
>  /*
> @@ -105,6 +106,7 @@ struct quota_file {
>  struct quota_handle {
>         int qh_type;            /* Type of quotafile */
>         int qh_fmt;             /* Quotafile format */
> +       int qh_file_flags;
>         int qh_io_flags;        /* IO flags for file */
>         struct quota_file qh_qf;
>         unsigned int (*e2fs_read)(struct quota_file *qf, ext2_loff_t offset,
> @@ -171,7 +173,7 @@ extern struct quotafile_ops quotafile_ops_meta;
>
>  /* Open existing quotafile of given type (and verify its format) on given
>   * filesystem. */
> -errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
> +errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
>                           ext2_ino_t qf_ino, int type, int fmt, int flags);
>
>
> @@ -180,7 +182,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
>                             int type, int fmt);
>
>  /* Close quotafile */
> -errcode_t quota_file_close(struct quota_handle *h);
> +errcode_t quota_file_close(quota_ctx_t qctx, struct quota_handle *h);
>
>  /* Get empty quota structure */
>  struct dquot *get_empty_dquot(void);
> --
> 1.9.0
>



-- 
Aditya
