From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext2 statfs improvement for block and inode free count
Date: Tue, 16 Oct 2007 15:00:33 -0700
Message-ID: <20071016150033.677efd09.akpm@linux-foundation.org>
References: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761926AbXJPWA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2007 18:00:58 -0400
In-Reply-To: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 13 Jul 2007 18:36:54 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> 
> More statfs() improvements for ext2. ext2 already maintains
> percpu counters for free blocks and inodes. Derive free
> block count and inode count by summing up percpu counters,
> instead of counting up all the groups in the filesystem
> each time.
> 
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> Acked-by: Andreas Dilger <adilger@clusterfs.com>
> 
>  fs/ext2/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22/fs/ext2/super.c
> ===================================================================
> --- linux-2.6.22.orig/fs/ext2/super.c	2007-07-13 20:06:38.000000000 -0700
> +++ linux-2.6.22/fs/ext2/super.c	2007-07-13 20:06:51.000000000 -0700
> @@ -1136,12 +1136,12 @@ static int ext2_statfs (struct dentry * 
>  	buf->f_type = EXT2_SUPER_MAGIC;
>  	buf->f_bsize = sb->s_blocksize;
>  	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
> -	buf->f_bfree = ext2_count_free_blocks(sb);
> + 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
>  	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
>  	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
>  		buf->f_bavail = 0;
>  	buf->f_files = le32_to_cpu(es->s_inodes_count);
> -	buf->f_ffree = ext2_count_free_inodes(sb);
> + 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
>  	buf->f_namelen = EXT2_NAME_LEN;
>  	fsid = le64_to_cpup((void *)es->s_uuid) ^
>  	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
> 

Guys, I have this patch in a stalled state pending some convincing
demonstration/argument that it's actually a worthwhile change.

How much hurt will it cause on large-numa, and how much benefit do we get
for that hurt? 
