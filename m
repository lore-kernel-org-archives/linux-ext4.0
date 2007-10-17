From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2 statfs improvement for block and inode free count
Date: Wed, 17 Oct 2007 17:15:01 -0600
Message-ID: <20071017231501.GL8122@schatzie.adilger.int>
References: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com> <20071016150033.677efd09.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:46172 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbXJQXPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2007 19:15:04 -0400
Content-Disposition: inline
In-Reply-To: <20071016150033.677efd09.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 16, 2007  15:00 -0700, Andrew Morton wrote:
> On Fri, 13 Jul 2007 18:36:54 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > @@ -1136,12 +1136,12 @@ static int ext2_statfs (struct dentry * 
> >  	buf->f_type = EXT2_SUPER_MAGIC;
> >  	buf->f_bsize = sb->s_blocksize;
> >  	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
> > -	buf->f_bfree = ext2_count_free_blocks(sb);
> > + 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
> >  	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
> >  	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
> >  		buf->f_bavail = 0;
> >  	buf->f_files = le32_to_cpu(es->s_inodes_count);
> > -	buf->f_ffree = ext2_count_free_inodes(sb);
> > + 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
> >  	buf->f_namelen = EXT2_NAME_LEN;
> >  	fsid = le64_to_cpup((void *)es->s_uuid) ^
> >  	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
> > 
> 
> Guys, I have this patch in a stalled state pending some convincing
> demonstration/argument that it's actually a worthwhile change.

Is it just this part of the change, or the whole "overhead" calculation?
It looks like this is also missing the "overhead_last" part of the change?
The filesystem overhead is static outside of fs resize and there is no
point in recalculating it.  In fact there was a cond_resched() added in
there expressly because it was causing hiccups in the low-latency tests,
so it is a non-trivial CPU user.

> How much hurt will it cause on large-numa, and how much benefit do we get
> for that hurt? 

To be honest, I suspect the tradeoff depends on the size of the filesystem
and the number of CPUs.  It might not make sense for ext2, but it likely
does for ext4.  If you consider that ext2_count_free_*() will walk all
of the block group descriptors (1 per 128MB on a 4kB filesystem, 1 per
8MB on a 1kB filesystem) and look at average filesystem sizes these days
(80GB let's say for small ones, 8TB for big ones) that means 640 loops
for an average fs, 64k loops for a big fs.

We might also consider using percpu_counter_read() and ensure the value
is >= 0, since these values do not have to be exact.  We can't use
percpu_counter_read_positive() since it will return 1 block free if the
percpu value is negative.

Using just percpu_counter_read() means we are inaccurate by at most
(+/-)NR_CPUS * num_online_cpus * 2 blocks, but on average this will be
0 blocks.

What's also missing from these patches somehow (was in the original patch
I sent) is the update of the superblock fields.

 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
 	buf->f_bfree = ext3_count_free_blocks (sb);
+	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = ext3_count_free_inodes (sb);
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	return 0;

Without this, e2fsck will report spurious when doing a read-only check,
even if the fs is idle:

	Pass 5: Checking group summary information
	Free blocks count wrong (83302, counted=83276).
	Fix? no

	Free inodes count wrong (99987, counted=99972).

Yes, I know you aren't guaranteed consistency on a read-only e2fsck, but
we should at least allow the problem to be addressed if it is easy.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
