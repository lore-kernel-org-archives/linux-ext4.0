From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 10/37] mke2fs: Allow metadata checksums to be turned on at mkfs time
Date: Sun, 4 Sep 2011 12:28:24 -0600
Message-ID: <4764BABB-0FFB-4AE5-B6A3-EF804AA59FC8@dilger.ca>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003615.1176.76957.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:31112 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1IDS1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 14:27:43 -0400
In-Reply-To: <20110901003615.1176.76957.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-31, at 6:36 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Write out checksummed inodes even when writing out a zeroed table.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> misc/mke2fs.c |   37 ++++++++++++++++++++++++++++++-------
> 1 files changed, 30 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 2d57d09..bbc0533 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -309,6 +309,8 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
>    dgrp_t        i;
>    int        num;
>    struct ext2fs_numeric_progress_struct progress;
> +    ext2_ino_t    ino;
> +    struct ext2_inode_large inode;
> 
>    ext2fs_numeric_progress_init(fs, &progress,
>                     _("Writing inode tables: "),
> @@ -330,12 +332,32 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
>            ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
>            ext2fs_group_desc_csum_set(fs, i);
>        }
> -        retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
> -        if (retval) {
> -            fprintf(stderr, _("\nCould not write %d "
> -                  "blocks in inode table starting at %llu: %s\n"),
> -                num, blk, error_message(retval));
> -            exit(1);
> +        if (fs->super->s_creator_os == EXT2_OS_LINUX &&
> +            fs->super->s_feature_ro_compat &
> +            EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {

Somehow it doesn't look like this is skipping the zeroing of the inode table blocks if lazy itable zeroing is set. 

Any measurements on how much this slows down inode table writing (which is already the slowest part of mke2fs)?

> +            bzero(&inode, sizeof(inode));
> +            for (ino = fs->super->s_inodes_per_group * i;
> +                 ino < fs->super->s_inodes_per_group * (i + 1);
> +                 ino++) {

Why recompute "ino" each time through this loop?  It should be enough to simply initialize it at 1 and then increment it for each inode written. 

> +                if (!ino)
> +                    continue;
> +                retval = ext2fs_write_inode(fs, ino, &inode);
> +                if (retval) {
> +                    com_err("inode_init", retval,
> +                        "while writing inode %d\n",
> +                        ino);
> +                    exit(1);
> +                }
> +            }
> +        } else {
> +            retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
> +            if (retval) {
> +                fprintf(stderr, _("\nCould not write %d "
> +                    "blocks in inode table starting "
> +                    "at %llu: %s\n"),
> +                    num, blk, error_message(retval));
> +                exit(1);
> +            }
>        }
>        if (sync_kludge) {
>            if (sync_kludge == 1)
> @@ -829,7 +851,8 @@ static __u32 ok_features[3] = {
>        EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
>        EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
>        EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
> -        EXT4_FEATURE_RO_COMPAT_BIGALLOC
> +        EXT4_FEATURE_RO_COMPAT_BIGALLOC|
> +        EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
> };
> 
> 
> 
