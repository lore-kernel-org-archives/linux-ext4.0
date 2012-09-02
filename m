From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and 64bits features
Date: Sun, 2 Sep 2012 18:31:19 +0800
Message-ID: <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63809 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2IBKbk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Sep 2012 06:31:40 -0400
Received: by vbbff1 with SMTP id ff1so4530357vbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 02 Sep 2012 03:31:40 -0700 (PDT)
In-Reply-To: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

    I noticed that you send out the patch enabling resizing on
filesystems with meta_bg and 64bits, so I send out the corresponding
patch on e2fsprogs.  Unfortunately, there is still a bug in e2fsprogs
as my last email says.

Thanks,
Yongqiang.

On Sun, Sep 2, 2012 at 5:52 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> This patch supports online-resizing for meata_bg and 64bits features.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  resize/main.c   |    5 +++--
>  resize/online.c |    6 +++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/resize/main.c b/resize/main.c
> index ffefe01..b3a7840 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -324,9 +324,10 @@ int main (int argc, char ** argv)
>          * This is something we should fix eventually, though.
>          */
>         if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> -           !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
> +           !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
> +           !(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)) {
>                 com_err(program_name, 0, _("%s: The combination of flex_bg "
> -                                          "and\n\t!resize_inode features "
> +                                          "and\n\t!resize_inode and !meta_bg features "
>                                            "is not supported by resize2fs.\n"),
>                         device_name);
>                 exit(1);
> diff --git a/resize/online.c b/resize/online.c
> index 966ea1e..e7891bd 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -56,9 +56,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>                 EXT2_DESC_PER_BLOCK(fs->super));
>         printf("old_desc_blocks = %lu, new_desc_blocks = %lu\n",
>                fs->desc_blocks, new_desc_blocks);
> -       if (!(fs->super->s_feature_compat &
> -             EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
> -           new_desc_blocks != fs->desc_blocks) {
> +       if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
> +           new_desc_blocks != fs->desc_blocks &&
> +           !(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)) {
>                 com_err(program_name, 0,
>                         _("Filesystem does not support online resizing"));
>                 exit(1);
> --
> 1.7.5.1
>



-- 
Best Wishes
Yongqiang Yang
