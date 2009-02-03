From: Andreas Dilger <adilger@sun.com>
Subject: Re: Using libext2fs in libe2p?
Date: Tue, 03 Feb 2009 13:31:14 -0700
Message-ID: <20090203203114.GZ28818@webber.adilger.int>
References: <20090203195645.GG20654@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Nick Dokos <nicholas.dokos@hp.com>
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39872 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZBCUbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 15:31:44 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n13KVRO3021722
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 12:31:39 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KEI00H01BEJMK00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Feb 2009 12:31:27 -0800 (PST)
In-reply-to: <20090203195645.GG20654@shell>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 03, 2009  14:56 -0500, Valerie Aurora Henson wrote:
> Possible solutions:
> 
> Link libext2fs with libe2p
> Open code 64-bit block counts
> Require users of libe2p to link with libext2fs
> Move ext2fs_blocks_count() and friends into a header file and inline them

I would probably do the latter.  The functions are small enough that
inlining them is likely equivalent in terms of instructions compared
to jumping to a new function.

> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index 6d2ce70..1923793 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -20,6 +20,7 @@
>  #include <time.h>
>  
>  #include "e2p.h"
> +#include "ext2fs/ext2fs.h"
>  
>  static void print_user (unsigned short uid, FILE *f)
>  {
> @@ -219,9 +220,9 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
>         fprintf(f, "Filesystem OS type:       %s\n", str);
>         free(str);
>         fprintf(f, "Inode count:              %u\n", sb->s_inodes_count);
> -       fprintf(f, "Block count:              %u\n", sb->s_blocks_count);
> -       fprintf(f, "Reserved block count:     %u\n", sb->s_r_blocks_count);
> -       fprintf(f, "Free blocks:              %u\n", sb->s_free_blocks_count);
> +       fprintf(f, "Block count:              %llu\n", ext2fs_blocks_count(sb));
> +       fprintf(f, "Reserved block count:     %llu\n", ext2fs_r_blocks_count(sb));
> +       fprintf(f, "Free blocks:              %llu\n", ext2fs_free_blocks_count(sb));
>         fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
>         fprintf(f, "First block:              %u\n", sb->s_first_data_block);
>         fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

