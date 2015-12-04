From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] filefrag: accommodate holes when calculating expected
 values
Date: Fri, 4 Dec 2015 15:11:03 -0800
Message-ID: <20151204231103.GK10580@birch.djwong.org>
References: <20151203203726.GH10580@birch.djwong.org>
 <8B852D41-28F6-4280-9DF0-7A370ADC5B2D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27330 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbbLDXLI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 18:11:08 -0500
Content-Disposition: inline
In-Reply-To: <8B852D41-28F6-4280-9DF0-7A370ADC5B2D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2015 at 03:06:04PM -0700, Andreas Dilger wrote:
> On Dec 3, 2015, at 1:37 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > Currently, filefrag's "expected physical block" column expects extent
> > records to be physically adjacent regardless of the amount of logical
> > block space between the two records.  This means that if we punch a
> > hole in a file, we get reports like this:
> > 
> > ext:   logical_offset:   physical_offset: length:  expected: flags:
> > 4:     4096..    8343:   57376..  61623:   4248:
> > 5:     8345..   10313:   61625..  63593:   1969:   61624:
> > 
> > Notice how it expects 8345 to map to 61624, and scores this against
> > the fragmentation of the file.  Flagging this as "unexpected" is
> > incorrect because the gap in the logical mapping is exactly the same
> > size as the gap in the physical extents.
> > 
> > Furthermore, this particular mapping leaves the door open to the
> > optimal mapping -- if a write to block 8344 causes it to be mapped to
> > 61624, the entire range 4096-10313 can be mapped with a single extent.
> > Until that happens, there's no way to combine extents 4 and 5 because
> > of the gap in the logical mapping at block 8344.
> > 
> > Therefore, tweak the extent report to account for holes.
> > 
> > v2: Make it work for extents crossing FIEMAP calls, and clean up the
> > FIBMAP version to report correct expected values.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > misc/filefrag.c |   74 +++++++++++++++++++++++++++++++++----------------------
> > 1 file changed, 45 insertions(+), 29 deletions(-)
> > 
> > diff --git a/misc/filefrag.c b/misc/filefrag.c
> > index 5bcde91..5ad6ee0 100644
> > --- a/misc/filefrag.c
> > +++ b/misc/filefrag.c
> > @@ -208,6 +208,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
> > 	__u64 buf[2048];	/* __u64 for proper field alignment */
> > 	struct fiemap *fiemap = (struct fiemap *)buf;
> > 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
> > +	struct fiemap_extent fm_last;
> > 	int count = (sizeof(buf) - sizeof(*fiemap)) /
> > 			sizeof(struct fiemap_extent);
> > 	unsigned long long expected = 0;
> > @@ -219,6 +220,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
> > 	int rc;
> > 
> > 	memset(fiemap, 0, sizeof(struct fiemap));
> > +	memset(&fm_last, 0, sizeof(struct fiemap_extent));
> 
> This could just be an initializer at declaration time?

Yeah.  I was tempted to just fm_last = {0} but couldn't remember if that's
valid C or a gcc-ism. :)

> 
> > 	if (sync_file)
> > 		flags |= FIEMAP_FLAG_SYNC;
> > @@ -254,6 +256,8 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
> > 		}
> > 
> > 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
> > +			expected = fm_last.fe_physical +
> > +				   fm_ext[i].fe_logical - fm_last.fe_logical;
> 
> Does it make sense to allow two "expected" values? Either the sparse one that
> leaves a gap for the block, or the dense one that packs physical blocks adjacent
> to each other seem acceptable, depending on the application.  It doesn't make
> sense to preserve holes in files that are never going to be modified in-place
> (e.g. core dump or something).  Something like:
> 
> 			expected_dense = fm_last.fe_physical + fm_last.fe_length;
> 			expected_sparse = fm_last.fe_physical +
> 				   fm_ext[i].fe_logical - fm_last.fe_logical;
> 
> 			if (fm_ext[i].fe_logical != 0 &&
> 			    fm_ext[i].fe_physical != expected_dense &&
> 			    fm_ext[i].fe_physical != expected_sparse) {
> 				tot_extents++;

Hmm.  I like that idea, what does everyone else think?

--D

> 
> Cheers, Andreas
> 
> > @@ -265,10 +269,9 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
> > 			if (verbose)
> > 				print_extent_info(&fm_ext[i], n, expected,
> > 						  blk_shift, st);
> > -
> > -			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
> > 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
> > 				last = 1;
> > +			fm_last = fm_ext[i];
> > 			n++;
> > 		}
> > 
> > @@ -287,14 +290,15 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
> > 			   ext2fs_struct_stat *st,
> > 			   unsigned long numblocks, int is_ext2)
> > {
> > -	struct fiemap_extent	fm_ext;
> > +	struct fiemap_extent	fm_ext, fm_last;
> > 	unsigned long		i, last_block;
> > -	unsigned long long	logical;
> > +	unsigned long long	logical, expected = 0;
> > 				/* Blocks per indirect block */
> > 	const long		bpib = st->st_blksize / 4;
> > 	int			count;
> > 
> > 	memset(&fm_ext, 0, sizeof(fm_ext));
> > +	memset(&fm_last, 0, sizeof(fm_last));
> 
> These could be declaration initializers.
> 
> > 	if (force_extent) {
> > 		fm_ext.fe_flags = FIEMAP_EXTENT_MERGED;
> > 	}
> > @@ -322,40 +326,52 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
> > 			return rc;
> > 		if (block == 0)
> > 			continue;
> > -		if (*num_extents == 0) {
> > -			(*num_extents)++;
> > -			if (force_extent) {
> > +
> > +		if (*num_extents == 0 || block != last_block + 1 ||
> > +		    fm_ext.fe_logical + fm_ext.fe_length != logical) {
> > +			/*
> > +			 * This is the start of a new extent; figure out where
> > +			 * we expected it to be and report the extent.
> > +			 */
> > +			if (*num_extents != 0 && fm_last.fe_length) {
> > +				expected = fm_last.fe_physical +
> > +					(fm_ext.fe_logical - fm_last.fe_logical);
> > +				if (expected == fm_ext.fe_physical)
> > +					expected = 0;
> > +			}
> > +			if (force_extent && *num_extents == 0)
> > 				print_extent_header();
> > -				fm_ext.fe_physical = block * st->st_blksize;
> > +			if (force_extent && *num_extents != 0) {
> > +				print_extent_info(&fm_ext, *num_extents - 1,
> > +						  expected, blk_shift, st);
> > 			}
> > -		}
> > -		count++;
> > -		if (force_extent && last_block != 0 &&
> > -		    (block != last_block + 1 ||
> > -		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
> > -			print_extent_info(&fm_ext, *num_extents - 1,
> > -					  (last_block + 1) * st->st_blksize,
> > -					  blk_shift, st);
> > -			fm_ext.fe_length = 0;
> > +			if (verbose && expected != 0) {
> > +				printf("Discontinuity: Block %llu is at %llu "
> > +				       "(was %llu)\n",
> > +					fm_ext.fe_logical / st->st_blksize,
> > +					fm_ext.fe_physical / st->st_blksize,
> > +					expected / st->st_blksize);
> > +			}
> > +			/* create the new extent */
> > +			fm_last = fm_ext;
> > 			(*num_extents)++;
> > -			fm_ext.fe_logical = logical;
> > 			fm_ext.fe_physical = block * st->st_blksize;
> > -		} else if (last_block && (block != last_block + 1)) {
> > -			if (verbose)
> > -				printf("Discontinuity: Block %ld is at %lu (was "
> > -				       "%lu)\n", i, block, last_block + 1);
> > -			fm_ext.fe_length = 0;
> > -			(*num_extents)++;
> > 			fm_ext.fe_logical = logical;
> > -			fm_ext.fe_physical = block * st->st_blksize;
> > +			fm_ext.fe_length = 0;
> > 		}
> > 		fm_ext.fe_length += st->st_blksize;
> > 		last_block = block;
> > 	}
> > -
> > -	if (force_extent)
> > -		print_extent_info(&fm_ext, *num_extents - 1,
> > -				  last_block * st->st_blksize, blk_shift, st);
> > +	if (force_extent && *num_extents != 0) {
> > +		if (fm_last.fe_length) {
> > +			expected = fm_last.fe_physical +
> > +				   (fm_ext.fe_logical - fm_last.fe_logical);
> > +			if (expected == fm_ext.fe_physical)
> > +				expected = 0;
> > +		}
> > +		print_extent_info(&fm_ext, *num_extents - 1, expected,
> > +				  blk_shift, st);
> > +	}
> > 
> > 	return count;
> > }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


