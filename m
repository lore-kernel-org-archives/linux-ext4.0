From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2 statfs speed up
Date: Thu, 5 Jul 2007 22:52:23 -0600
Message-ID: <20070706045223.GU5633@schatzie.adilger.int>
References: <1183659089.19473.7.camel@dyn9047017100.beaverton.ibm.com> <20070705210651.GN5633@schatzie.adilger.int> <1183687737.19473.29.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:48705 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXGFEw1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2007 00:52:27 -0400
Content-Disposition: inline
In-Reply-To: <1183687737.19473.29.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 05, 2007  19:08 -0700, Badari Pulavarty wrote:
> On Thu, 2007-07-05 at 15:06 -0600, Andreas Dilger wrote:
> > On Jul 05, 2007  11:11 -0700, Badari Pulavarty wrote:
> > > @@ -1131,17 +1134,22 @@ static int ext2_statfs (struct dentry * 
> > >  	buf->f_bfree = ext2_count_free_blocks(sb);
> > > +	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
> > >  	buf->f_ffree = ext2_count_free_inodes(sb);
> > > +	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
> > 
> > Hmm, this is still sub-optimal.  For ext3 and ext4 it just uses
> > percpu_counter_sum() instead of the slow ext*_count_free_blocks(), which
> > walks all of the groups.  Not that this is a reason to hold this patch,
> > because at least we are removing 1/2 of the overhead for ext2.
> 
> I am wondering why we are not currently using percpu_counter_sum()
> for ext2 ? I see that ext2 already has all the stuff it needs. 
> Can't I just do following ?

Yes, that is exactly what I was asking above.

>  fs/ext2/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc7/fs/ext2/super.c
> ===================================================================
> --- linux-2.6.22-rc7.orig/fs/ext2/super.c	2007-07-05 12:35:15.000000000 -0700
> +++ linux-2.6.22-rc7/fs/ext2/super.c	2007-07-05 20:37:32.000000000 -0700
> @@ -1142,13 +1142,13 @@ static int ext2_statfs (struct dentry * 
>  	buf->f_type = EXT2_SUPER_MAGIC;
>  	buf->f_bsize = sb->s_blocksize;
>  	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
> -	buf->f_bfree = ext2_count_free_blocks(sb);
> +	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
>  	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
>  	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
>  	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
>  		buf->f_bavail = 0;
>  	buf->f_files = le32_to_cpu(es->s_inodes_count);
> -	buf->f_ffree = ext2_count_free_inodes(sb);
> +	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
>  	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
>  	buf->f_namelen = EXT2_NAME_LEN;
>  	fsid = le64_to_cpup((void *)es->s_uuid) ^

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
