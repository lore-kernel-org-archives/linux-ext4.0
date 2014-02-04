From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] e2fsck: read-ahead metadata during pass1 and pass2
Date: Mon, 3 Feb 2014 17:26:10 -0800
Message-ID: <20140204012610.GC9176@birch.djwong.org>
References: <20140201103721.9011.5971.stgit@birch.djwong.org>
 <20140201103741.9011.90207.stgit@birch.djwong.org>
 <E0EB42E0-44E6-4061-B381-812577C71489@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBDB0Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 20:26:16 -0500
Content-Disposition: inline
In-Reply-To: <E0EB42E0-44E6-4061-B381-812577C71489@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 03, 2014 at 02:20:01PM -0700, Andreas Dilger wrote:
> On Feb 1, 2014, at 3:37 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> > index 7554f4e..590e1bd 100644
> > --- a/e2fsck/pass1.c
> > +++ b/e2fsck/pass1.c
> > @@ -574,6 +577,20 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
> > 	return 0;
> > }
> > 
> > +static void *pass1_readahead(void *p)
> > +{
> > +	errcode_t err;
> > +	e2fsck_t ctx = (e2fsck_t)p;
> > +
> > +	printf("%s: START READAHEAD\n", __func__);
> > +	err = ext2fs_readahead(ctx->fs, EXT2FS_READ_BBITMAP |
> > +			       EXT2FS_READ_IBITMAP | EXT2FS_READ_ITABLE,
> > +			       0, ctx->fs->group_desc_count);
> 
> This is basically launching readahead for the whole filesystem in one
> shot.  That might be OK for small filesystems or running a single large
> filesystem on a big machine, but could cause memory pressure and cache
> eviction for many/large filesystems.
> 
> Have you done any tests to see what a limited readahead would do for
> performance (say 8-16 groups ahead)?

Yes.  I didn't see any significant speedups with a flexbg filesystem unless I
could readahead at least couple of flexbgs worth.  On the other hand, getting
so far ahead of the checker thread that it thrashes memory is clearly
counterproductive.  

For now I've set it to calculate the number of groups it takes to fill half of
memory with full inode tables, and it does incremental readahead in that
amount.  Partially filled (or totally empty) blockgroups of course reduce the
amount of memory used even further, but at least this lets us establish some
sort of upper bound.  Unfortunately, it's still a crude one since I'm using
sysconf(_SC_NUM_PAGES).

With this incremental thing hooked up, I can still observe speedups even on
low memory VMs (64GB fs, 2.5G metadata, 512M RAM).

As far as pass2 goes, I put in some more code so that we can call
fadvise(DONTNEED) on dir blocks after we're done with them.  I've seen a rather
small improvement.

> Also, the bitmaps are not needed until pass 5, but would benefit from
> being prefetched along with the inode table for non-flex_bg filesystems.
> Probably there is little to no benefit to prefetching them in pass1 for
> flex_bg filesystems.

If run during pass 5, the bitmap readahead thread doesn't seem to be able to
stay far enough ahead of ext2fs_read_bitmaps() to matter much.  However, pass 4
seems fairly IO-light and CPU-heavy, so when I moved bitmap readahead to pass
4, the (rather tiny) amount of time spent in P5 decreased.

I didn't do much with P3a other than hoping that everything we read in P2 is
still in cache.  It ran slower anyway.

--D

> Cheers, Andreas
> 
> > +	printf("%s: READAHEAD=%d\n", __func__, (int)err);
> > +
> > +	return NULL;
> > +}
> > +
> > void e2fsck_pass1(e2fsck_t ctx)
> > {
> > 	int	i;
> > @@ -600,6 +617,15 @@ void e2fsck_pass1(e2fsck_t ctx)
> > 	init_resource_track(&rtrack, ctx->fs->io);
> > 	clear_problem_context(&pctx);
> > 
> > +	if (getenv("READAHEAD")) {
> > +#ifdef HAVE_PTHREAD_H
> > +		pthread_t tid;
> > +		pthread_create(&tid, NULL, pass1_readahead, ctx);
> > +#else
> > +		pass1_readahead(ctx);
> > +#endif
> > +	}
> > +
> > 	if (!(ctx->options & E2F_OPT_PREEN))
> > 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
> > 
> > diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> > index 5a2745a..bd7323f 100644
> > --- a/e2fsck/pass2.c
> > +++ b/e2fsck/pass2.c
> > @@ -44,6 +44,9 @@
> > #define _GNU_SOURCE 1 /* get strnlen() */
> > #include "config.h"
> > #include <string.h>
> > +#ifdef HAVE_PTHREAD_H
> > +#include <pthread.h>
> > +#endif
> > 
> > #include "e2fsck.h"
> > #include "problem.h"
> > @@ -79,6 +82,29 @@ struct check_dir_struct {
> > 	e2fsck_t ctx;
> > };
> > 
> > +struct pass2_readahead_data {
> > +	ext2_filsys fs;
> > +	ext2_dblist dblist;
> > +};
> > +
> > +static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
> > +			       void *priv_data)
> > +{
> > +	db->blockcnt = 1;
> > +}
> > +
> > +static void *pass2_readahead(void *p)
> > +{
> > +	errcode_t err;
> > +	struct pass2_readahead_data *pr = p;
> > +
> > +	printf("%s: START READAHEAD\n", __func__);
> > +	err = ext2fs_readahead_dblist(pr->fs, pr->dblist);
> > +	ext2fs_free_dblist(pr->dblist);
> > +	ext2fs_free_mem(&pr);
> > +	printf("%s: END READAHEAD %d\n", __func__, (int)err);
> > +}
> > +
> > void e2fsck_pass2(e2fsck_t ctx)
> > {
> > 	struct ext2_super_block *sb = ctx->fs->super;
> > @@ -146,6 +172,41 @@ void e2fsck_pass2(e2fsck_t ctx)
> > 	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
> > 		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
> > 
> > +	if (getenv("READAHEAD")) {
> > +#ifdef HAVE_PTHREAD_H
> > +		pthread_t tid;
> > +#endif
> > +		struct pass2_readahead_data *pr;
> > +		errcode_t err;
> > +
> > +		err = ext2fs_get_mem(sizeof(*pr), &pr);
> > +		if (err)
> > +			goto no_readahead;
> > +		pr->fs = fs;
> > +		err = ext2fs_copy_dblist(fs->dblist, &pr->dblist);
> > +		if (err) {
> > +			ext2fs_free_mem(&pr);
> > +			goto no_readahead;
> > +		}
> > +		err = ext2fs_dblist_iterate2(pr->dblist, readahead_dir_block,
> > +					     NULL);
> > +		if (err) {
> > +			ext2fs_free_dblist(pr->dblist);
> > +			ext2fs_free_mem(&pr);
> > +			goto no_readahead;
> > +		}
> > +#ifdef HAVE_PTHREAD_H
> > +		err = pthread_create(&tid, NULL, pass2_readahead, pr);
> > +#else
> > +		pass2_readahead(pr);
> > +#endif
> > +		if (err) {
> > +			ext2fs_free_dblist(pr->dblist);
> > +			ext2fs_free_mem(&pr);
> > +		}
> > +	}
> > +
> > +no_readahead:
> > 	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_block,
> > 						 &cd);
> > 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
> > diff --git a/lib/config.h.in b/lib/config.h.in
> > index 35ece01..1dd33b4 100644
> > --- a/lib/config.h.in
> > +++ b/lib/config.h.in
> > @@ -206,6 +206,9 @@
> > /* Define if your <locale.h> file defines LC_MESSAGES. */
> > #undef HAVE_LC_MESSAGES
> > 
> > +/* Define to 1 if you have the `pthread' library (-lpthread). */
> > +#undef HAVE_LIBPTHREAD
> > +
> > /* Define to 1 if you have the <limits.h> header file. */
> > #undef HAVE_LIMITS_H
> > 
> > @@ -314,6 +317,9 @@
> > /* Define to 1 if you have the `prctl' function. */
> > #undef HAVE_PRCTL
> > 
> > +/* Define to 1 if you have the <pthread.h> header file. */
> > +#undef HAVE_PTHREAD_H
> > +
> > /* Define to 1 if you have the `putenv' function. */
> > #undef HAVE_PUTENV
> > 
> > 
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


