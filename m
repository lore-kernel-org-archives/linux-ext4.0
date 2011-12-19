From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 23/51] e2fsck: Verify htree root/node checksums
Date: Mon, 19 Dec 2011 07:57:21 +0100
Message-ID: <785BDE1C-35D8-4934-8FE0-F3EF54BDCEF0@whamcloud.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011551.20947.72443.stgit@elm3c44.beaverton.ibm.com>
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
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35638 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1LSLSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 06:18:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so5325769eek.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 03:18:05 -0800 (PST)
In-Reply-To: <20111214011551.20947.72443.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-14, at 2:15, "Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Check htree internal node checksums.  If broken, ask user to clear the htree
> index and recreate it later.
> 
> @@ -560,8 +572,12 @@ static void parse_int_node(ext2_filsys fs,
> #endif
> 
>    count = ext2fs_le16_to_cpu(limit->count);
> -    expect_limit = (fs->blocksize - ((char *) ent - block_buf)) /
> -        sizeof(struct ext2_dx_entry);
> +    if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +                       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +        csum_size = sizeof(struct ext2_dx_tail);
> +    expect_limit = (fs->blocksize -
> +            (csum_size + ((char *) ent - block_buf))) /
> +               sizeof(struct ext2_dx_entry);

How does this handle the case where the METADATA_CSUM feature is newly enabled but there is a dirent usinf the end of the leaf block?  It definitely shouldn't cause the last entry to be considered invalid. 

> @@ -829,7 +850,7 @@ static int check_dir_block(ext2_filsys fs,
>               (rec_len == fs->blocksize) &&
>               (dirent->name_len == 0) &&
>               (ext2fs_le16_to_cpu(limit->limit) ==
> -                ((fs->blocksize-8) /
> +                ((fs->blocksize - (8 + csum_size)) /
>                 sizeof(struct ext2_dx_entry))))
>            dx_db->type = DX_DIRBLOCK_NODE;

Same here.  

> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 96b0de5..2e9ab7f 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1374,6 +1374,16 @@ static struct e2fsck_problem problem_table[] = {
>      N_("i_file_acl_hi @F %N, @s zero.\n"),
>      PROMPT_CLEAR, PR_PREEN_OK },
> 
> +    /* htree root node fails checksum */
> +    { PR_2_HTREE_ROOT_CSUM_INVALID,
> +      N_("@p @h %d: root node fails checksum\n"),
> +      PROMPT_CLEAR_HTREE, PR_PREEN_OK },
> +
> +    /* htree internal node fails checksum */
> +    { PR_2_HTREE_NODE_CSUM_INVALID,
> +      N_("@p @h %d: node fails checksum\n"),

This error message should include "internal" in the printed message. 

Cheers, Andreas