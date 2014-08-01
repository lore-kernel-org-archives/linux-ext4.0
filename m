From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: fix uninitialized variable in remove_journal_device
Date: Fri, 1 Aug 2014 08:38:30 +0200
Message-ID: <6FF7A658-00C4-4185-A182-E9895E704A3E@dilger.ca>
References: <53DA5DDC.1020703@redhat.com> <1406821994-19600-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Azat Khuzhin <a3at.mail@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33387 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaHAGie (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 02:38:34 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so775016wiv.9
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 23:38:33 -0700 (PDT)
In-Reply-To: <1406821994-19600-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 31, 2014, at 17:53, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> This bug was introduced by commit 7dfefaf413bbd ("tune2fs: update
> journal super block when changing UUID for fs").
> 
> Fixes-Coverity-Bug: 1229243
> 
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> misc/tune2fs.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 0c1feb1..639809d 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -232,7 +232,6 @@ static int remove_journal_device(ext2_filsys fs)
>    errcode_t    retval;
>    int        commit_remove_journal = 0;
>    io_manager    io_ptr;
> -    int start;
> 
>    if (f_flag)
>        commit_remove_journal = 1; /* force removal even if error */
> @@ -286,8 +285,9 @@ static int remove_journal_device(ext2_filsys fs)
>    jsb->s_nr_users = htonl(nr_users);
> 
>    /* Write back the journal superblock */
> -    if ((retval = io_channel_write_blk64(jfs->io, start,
> -        -SUPERBLOCK_SIZE, buf))) {
> +    if ((retval = io_channel_write_blk64(jfs->io,
> +                ext2fs_journal_sb_start(fs->blocksize),
> +                -SUPERBLOCK_SIZE, buf))) {

Better to also remove assignment in conditional check. 

Cheers, Andreas

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
