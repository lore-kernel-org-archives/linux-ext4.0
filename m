From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 02/37] libext2fs: Add metadata checksum flag
Date: Sat, 3 Sep 2011 19:47:40 -0600
Message-ID: <0476B72B-E537-4252-9ED2-EC69D344DF7E@gmail.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003523.1176.17239.stgit@elm3c44.beaverton.ibm.com>
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
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62023 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1IDBrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Sep 2011 21:47:13 -0400
Received: by pzk37 with SMTP id 37so6663028pzk.1
        for <linux-ext4@vger.kernel.org>; Sat, 03 Sep 2011 18:47:12 -0700 (PDT)
In-Reply-To: <20110901003523.1176.17239.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-31, at 6:35 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Add a feature flag to enable metadata checksumming in e2fsprogs.  Also add a
> runtime flag to disable checksum verification; this flag will be used by
> debugfs to salvage filesystems and tune2fs when resetting checksums.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> lib/blkid/probe.h    |    1 +
> lib/e2p/feature.c    |    2 ++
> lib/ext2fs/ext2_fs.h |    1 +
> lib/ext2fs/ext2fs.h  |    4 +++-
> 4 files changed, 7 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
> index 37e80ef..d6809e1 100644
> --- a/lib/blkid/probe.h
> +++ b/lib/blkid/probe.h
> @@ -110,6 +110,7 @@ struct ext2_super_block {
> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK    0x0020
> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE    0x0040
> #define EXT4_FEATURE_RO_COMPAT_QUOTA        0x0100
> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400

There is really no reason to add every feature flag to probe.h. This was only used for distinguishing ext2/3/4. The blkid code officially lives in util-linux anyway.  Probably better to remove the ones that are not actually used. 

> /* for s_feature_incompat */
> #define EXT2_FEATURE_INCOMPAT_FILETYPE        0x0002
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 16fba53..07b700d 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -59,6 +59,8 @@ static struct feature feature_list[] = {
>            "quota" },
>    {    E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
>            "bigalloc"},
> +    {    E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM,
> +            "metadata_csum"},
> 
>    {    E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
>            "compression" },
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index e342bf0..ae7662e 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -635,6 +635,7 @@ struct ext2_super_block {
> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT    0x0080
> #define EXT4_FEATURE_RO_COMPAT_QUOTA        0x0100
> #define EXT4_FEATURE_RO_COMPAT_BIGALLOC        0x0200
> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
> 
> #define EXT2_FEATURE_INCOMPAT_COMPRESSION    0x0001
> #define EXT2_FEATURE_INCOMPAT_FILETYPE        0x0002
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index b290a1f..e638169 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -195,6 +195,7 @@ typedef struct ext2_file *ext2_file_t;
> #define EXT2_FLAG_64BITS        0x20000
> #define EXT2_FLAG_PRINT_PROGRESS    0x40000
> #define EXT2_FLAG_DIRECT_IO        0x80000
> +#define EXT2_FLAG_IGNORE_CSUM_ERRORS    0x100000
> 
> /*
>  * Special flag in the ext2 inode i_flag field that means that this is
> @@ -564,7 +565,8 @@ typedef struct ext2_icount *ext2_icount_t;
>                     EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
>                     EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
>                     EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
> -                     EXT4_FEATURE_RO_COMPAT_BIGALLOC)
> +                     EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
> +                     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> 
> /*
>  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
