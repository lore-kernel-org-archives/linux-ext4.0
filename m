From: jon ernst <jonernst07@gmail.com>
Subject: Re: [PATCH 02/31] libext2fs: Only link an inode into a directory once
Date: Tue, 1 Oct 2013 11:37:50 -0400
Message-ID: <CAGW2f1F4fgxHjNXW4WxB2et=QL39Wsu8d2fK5bqh5RTV6UvO8g@mail.gmail.com>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
	<20131001012655.28415.38313.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36886 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3JAPhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Oct 2013 11:37:51 -0400
Received: by mail-oa0-f43.google.com with SMTP id f4so4938314oah.16
        for <linux-ext4@vger.kernel.org>; Tue, 01 Oct 2013 08:37:50 -0700 (PDT)
In-Reply-To: <20131001012655.28415.38313.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 9:26 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> The ext2fs_link helper function link_proc does not check the value of ls->done,
> which means that if the function finds multiple empty spaces that will fit the
> new directory entry, it will create a directory entry in each of the spaces.
> Instead of doing that, check the done value and don't do anything more if we've
> already added the directory entry.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/link.c |    3 +++
>  1 file changed, 3 insertions(+)
>
>
> diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
> index f715067..e3ff450 100644
> --- a/lib/ext2fs/link.c
> +++ b/lib/ext2fs/link.c
> @@ -43,6 +43,9 @@ static int link_proc(struct ext2_dir_entry *dirent,
>         int ret = 0;
>         int csum_size = 0;
>
> +       if (ls->done)
> +               return 0;
maybe "return ret;" here to keep consistency.
> +
>         rec_len = EXT2_DIR_REC_LEN(ls->namelen);
>
>         ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
