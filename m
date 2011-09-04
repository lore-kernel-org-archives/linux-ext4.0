From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 13/37] dumpe2fs: Display inode bitmap checksum
Date: Sun, 4 Sep 2011 12:30:32 -0600
Message-ID: <632170F9-0528-44AF-A299-5EE2BFEB70F2@dilger.ca>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003634.1176.10897.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
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
Received: from shawmail.shawcable.com ([64.59.128.220]:31377 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1IDS3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 14:29:51 -0400
In-Reply-To: <20110901003634.1176.10897.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-31, at 6:36 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Display the inode bitmap checksum for each block group.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> misc/dumpe2fs.c |    5 +++++
> 1 files changed, 5 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 7d74e84..ed207cb 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -220,6 +220,11 @@ static void list_desc (ext2_filsys fs)
>        print_number(ext2fs_inode_bitmap_loc(fs, i));
>        print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
>                    first_block, last_block);
> +        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
> +            fs->super->s_feature_ro_compat &
> +            EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> +            printf(_(", checksum 0x%08x"),

Since this line is already very long, printing "csum" should be enough. 

> +                  ext2fs_inode_bitmap_checksum(fs, i));
>        fputs(_("\n  Inode table at "), stdout);
>        print_range(ext2fs_inode_table_loc(fs, i),
>                ext2fs_inode_table_loc(fs, i) +
> 
