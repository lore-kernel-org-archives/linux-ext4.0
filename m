Return-Path: <SRS0=Oy82=PD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42392 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbeLZAKh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Dec 2018 19:10:37 -0500
Received: by mail-qt1-f193.google.com with SMTP id d19so16012040qtq.9
        for <linux-ext4@vger.kernel.org>; Tue, 25 Dec 2018 16:10:37 -0800 (PST)
MIME-Version: 1.0
References: <20181225053326.7012-1-tytso@mit.edu>
In-Reply-To: <20181225053326.7012-1-tytso@mit.edu>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 25 Dec 2018 16:10:25 -0800
Message-ID: <CANQeFDAL=Bx6dq69Rzmz_OWXkXMz=KzLvEkw4rQSSqMW9OHWMQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: make sure enough credits are reserved for
 dioread_nolock writes
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

</bo.liu@linux.alibaba.com>
On Mon, Dec 24, 2018 at 9:36 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> There are enough credits reserved for most dioread_nolock writes;
> however, if the extent tree is sufficiently deep, and/or quota is
> enabled, the code was not allowing for all eventualities when
> reserving journal credits for the unwritten extent conversion.
>
> This problem can be seen using xfstests ext4/034:
>
>    WARNING: CPU: 1 PID: 257 at fs/ext4/ext4_jbd2.c:271 __ext4_handle_dirty_metadata+0x10c/0x180
>    Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
>    RIP: 0010:__ext4_handle_dirty_metadata+0x10c/0x180
>         ...
>    EXT4-fs: ext4_free_blocks:4938: aborting transaction: error 28 in __ext4_handle_dirty_metadata
>    EXT4: jbd2_journal_dirty_metadata failed: handle type 11 started at line 4921, credits 4/0, errcode -28
>    EXT4-fs error (device dm-1) in ext4_free_blocks:4950: error 28
>

I had a patch[1] to address the problem but with adding reservation
only when we need to (in ext4_ext_try_to_merge_up).

I'm fine with either way.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

BTW, the ext4/034 may need to be updated with the correct patch title/commit.

thanks,
liubo

[1]:
https://patchwork.ozlabs.org/patch/991794/

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9affabd07682..165ff331d998 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2778,7 +2778,8 @@ static int ext4_writepages(struct address_space *mapping,
>                  * We may need to convert up to one extent per block in
>                  * the page and we may dirty the inode.
>                  */
> -               rsv_blocks = 1 + (PAGE_SIZE >> inode->i_blkbits);
> +               rsv_blocks = 1 + ext4_chunk_trans_blocks(inode,
> +                                               PAGE_SIZE >> inode->i_blkbits);
>         }
>
>         /*
> --
> 2.19.1
>
