From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 11/51] dumpe2fs: Display inode bitmap checksum
Date: Sun, 18 Dec 2011 12:09:33 -0600
Message-ID: <0BFEA71E-BA78-4B98-8092-CCD38AB651CE@whamcloud.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011429.20947.35132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
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
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1LRTqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 14:46:21 -0500
Received: by iaeh11 with SMTP id h11so7371044iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 11:46:21 -0800 (PST)
In-Reply-To: <20111214011429.20947.35132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-13, at 19:14, "Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Display the inode bitmap checksum for each block group.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> misc/dumpe2fs.c |    5 +++++
> 1 files changed, 5 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 5b114e9..98bee2b 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -226,6 +226,11 @@ static void list_desc (ext2_filsys fs)
>        print_number(ext2fs_inode_bitmap_loc(fs, i));
>        print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
>                    first_block, last_block);
> +        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
> +            fs->super->s_feature_ro_compat &
> +            EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> +            printf(_(", csum 0x%08x"),

This shouldn't only be printed for 64 byte descriptors. There is a checksum even for 32 byte descriptors. 

Cheers, Andreas

