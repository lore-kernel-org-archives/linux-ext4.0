From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] e2fsck: fix quota accounting to use cluster units
Date: Wed, 5 Apr 2017 16:55:58 -0400
Message-ID: <20170405205558.GA941@localhost.localdomain>
References: <20170402165705.GA8705@localhost.localdomain>
 <965F24ED-3B91-4D89-B25D-F547208FE909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Eric Whitney <enwlinux@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35973 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755202AbdDEUym (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Apr 2017 16:54:42 -0400
Received: by mail-qt0-f193.google.com with SMTP id n37so3253812qtb.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Apr 2017 13:54:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <965F24ED-3B91-4D89-B25D-F547208FE909@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Alexey Lyashkov <alexey.lyashkov@gmail.com>:
> Hi Eric,
> 
> > 2 апр. 2017 г., в 19:57, Eric Whitney <enwlinux@gmail.com> написал(а):
> > 
> > The quota accounting code in e2fsck's pass 1 and pass 3 uses block units
> > rather than cluster units when recording the allocated space consumed by
> > files and directories.  In pass 1, this causes a large undercount of
> > actual quota results and test failures for xfstests generic/383, /384,
> > /385, and /386 on bigalloc file systems.  In pass 3, this results in
> > quota accounting errors when the lost+found directory is either extended
> > or recreated on a bigalloc file system.
> > 
> > Use clusters rather than blocks when accounting for allocated space,
> > and correct a related header comment in the quota code.
> > 
> > Note that pass 1b also contains call sites for quota_data_sub() that
> > also need to be addressed.  However, it appears that more than just
> > unit conversion may be needed, so that will be left to a future patch.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> > e2fsck/pass1.c        | 3 ++-
> > e2fsck/pass3.c        | 5 +++--
> > lib/support/quotaio.h | 2 +-
> > 3 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> > index 1714897..188cc56 100644
> > --- a/e2fsck/pass1.c
> > +++ b/e2fsck/pass1.c
> > @@ -3174,7 +3174,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
> > 	if (ino != quota_type2inum(PRJQUOTA, fs->super) &&
> > 	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super))) {
> > 		quota_data_add(ctx->qctx, (struct ext2_inode_large *) inode,
> > -			       ino, pb.num_blocks * fs->blocksize);
> > +			       ino,
> > +			       pb.num_blocks * EXT2_CLUSTER_SIZE(fs->super));
> > 		quota_data_inodes(ctx->qctx, (struct ext2_inode_large *) inode,
> > 				  ino, +1);
> > 	}
> I think it part may rewrite easy.
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 98125bf..cd83156 100644 (file)
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -2700,6 +2700,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>                }
>        }
> 
> +       pb.num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
> +
>        if (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super)) {
>                quota_data_add(ctx->qctx, inode, ino,
>                               pb.num_blocks * fs->blocksize);
> @@ -2710,7 +2712,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>              EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
>            !(inode->i_flags & EXT4_HUGE_FILE_FL))
>                pb.num_blocks *= (fs->blocksize / 512);
> -       pb.num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
> +
> 
> 

Hi Alexey:

Thanks for your comment.  What you propose would certainly work, but I prefer
my original patch because I think it makes the code easier to understand.
Using EXT2_CLUSTER_SIZE makes the unit in which space has been allocated
direct and explicit rather than asking the reader to first follow an
intermediate conversion from cluster to block units.  Also, other calls to
the quota_data_add/sub code in this and in another patch to be posted can be
handled more clearly using EXT2_CLUSTER_SIZE rather than EXT2FS_CLUSTER_RATIO,
and using the same style for all is better for readability.

Thanks,
Eric
