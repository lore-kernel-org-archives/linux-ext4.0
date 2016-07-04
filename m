From: Pranay Srivastava <pranjas@gmail.com>
Subject: Re: [PATCH 1/1]ext4: Fix WARN_ON_ONCE when marking buffer dirty
Date: Mon, 4 Jul 2016 12:39:05 +0530
Message-ID: <CA+aCy1HhYFwsME0Zo1p1UJddz0WzDZPWMeK6D4rLv5Fp9-igkQ@mail.gmail.com>
References: <1467285150-15977-1-git-send-email-pranjas@gmail.com> <1467285150-15977-2-git-send-email-pranjas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Pranay Kr. Srivastava" <pranjas@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36644 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcGDHJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2016 03:09:08 -0400
In-Reply-To: <1467285150-15977-2-git-send-email-pranjas@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2016 at 4:42 PM, Pranay Kr. Srivastava
<pranjas@gmail.com> wrote:
> Signed-off-by: Pranay Kr. Srivastava <pranjas@gmail.com>
> ---
>  fs/ext4/super.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3822a5a..8f10715 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4327,20 +4327,6 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>
>         if (!sbh || block_device_ejected(sb))
>                 return error;
> -       if (buffer_write_io_error(sbh)) {
> -               /*
> -                * Oh, dear.  A previous attempt to write the
> -                * superblock failed.  This could happen because the
> -                * USB device was yanked out.  Or it could happen to
> -                * be a transient write error and maybe the block will
> -                * be remapped.  Nothing we can do but to retry the
> -                * write and hope for the best.
> -                */
> -               ext4_msg(sb, KERN_ERR, "previous I/O error to "
> -                      "superblock detected");
> -               clear_buffer_write_io_error(sbh);
> -               set_buffer_uptodate(sbh);
> -       }
>         /*
>          * If the file system is mounted read-only, don't update the
>          * superblock write time.  This avoids updating the superblock
> @@ -4371,7 +4357,23 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>                                 &EXT4_SB(sb)->s_freeinodes_counter));
>         BUFFER_TRACE(sbh, "marking dirty");
>         ext4_superblock_csum_set(sb);
> +       lock_buffer(sbh);
> +       if (buffer_write_io_error(sbh)) {
> +               /*
> +                * Oh, dear.  A previous attempt to write the
> +                * superblock failed.  This could happen because the
> +                * USB device was yanked out.  Or it could happen to
> +                * be a transient write error and maybe the block will
> +                * be remapped.  Nothing we can do but to retry the
> +                * write and hope for the best.
> +                */
> +               ext4_msg(sb, KERN_ERR, "previous I/O error to "
> +                      "superblock detected");
> +               clear_buffer_write_io_error(sbh);
> +               set_buffer_uptodate(sbh);
> +       }
>         mark_buffer_dirty(sbh);
> +       unlock_buffer(sbh);
>         if (sync) {
>                 error = __sync_dirty_buffer(sbh,
>                         test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
> --
> 1.9.1
>

Can this be reviewed as well please.


-- 
        ---P.K.S
