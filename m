From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] tune2fs: remove_journal_device(): use the correct block to find jsb
Date: Tue, 8 Jul 2014 22:48:03 -0600
Message-ID: <EA4AA383-2731-4D2B-B23D-7BD778392344@dilger.ca>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com> <1404852082-1550-3-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46610 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGIEsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 00:48:08 -0400
Received: by mail-pa0-f54.google.com with SMTP id et14so8584196pad.13
        for <linux-ext4@vger.kernel.org>; Tue, 08 Jul 2014 21:48:05 -0700 (PDT)
In-Reply-To: <1404852082-1550-3-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good. You can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas

> On Jul 8, 2014, at 14:41, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> 
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> ---
> misc/tune2fs.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 0e7caf2..811cb4d 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -193,6 +193,7 @@ static int remove_journal_device(ext2_filsys fs)
>    errcode_t    retval;
>    int        commit_remove_journal = 0;
>    io_manager    io_ptr;
> +    int start;
> 
>    if (f_flag)
>        commit_remove_journal = 1; /* force removal even if error */
> @@ -229,8 +230,10 @@ static int remove_journal_device(ext2_filsys fs)
>        goto no_valid_journal;
>    }
> 
> +    start = ext2fs_journal_sb_start(fs->blocksize);
>    /* Get the journal superblock */
> -    if ((retval = io_channel_read_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
> +    if ((retval = io_channel_read_blk64(jfs->io, start,
> +        -SUPERBLOCK_SIZE, buf))) {
>        com_err(program_name, retval, "%s",
>            _("while reading journal superblock"));
>        goto no_valid_journal;
> @@ -261,7 +264,8 @@ static int remove_journal_device(ext2_filsys fs)
>    jsb->s_nr_users = htonl(nr_users);
> 
>    /* Write back the journal superblock */
> -    if ((retval = io_channel_write_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
> +    if ((retval = io_channel_write_blk64(jfs->io, start,
> +        -SUPERBLOCK_SIZE, buf))) {
>        com_err(program_name, retval,
>            "while writing journal superblock.");
>        goto no_valid_journal;
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
