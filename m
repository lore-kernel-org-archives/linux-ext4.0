From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: Rework the ext4_da_writepages
Date: Mon, 11 Aug 2008 14:50:04 -0700
Message-ID: <1218491404.6766.22.camel@mingming-laptop>
References: <1218450188-9643-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1218450188-9643-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44118 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYHKVuK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2008 17:50:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7BLo7iv032284
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:50:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BLo7MX012776
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:50:07 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BLo6Zt021083
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:50:07 -0400
In-Reply-To: <1218450188-9643-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-11=E4=B8=80=E7=9A=84 15:53 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> With the below changes we reserve credit needed to insert only one ex=
tent
> resulting from a call to single get_block. That make sure we don't ta=
ke
> too much journal credits during writeout. We also don't limit the pag=
es
> to write. That means we loop through the dirty pages building largest
> possible contiguous block request. Then we issue a single get_block r=
equest.
> We may get less block that we requested. If so we would end up not ma=
pping
> some of the buffer_heads. That means those buffer_heads are still mar=
ked delay.
> Later in the writepage callback via __mpage_writepage we redirty thos=
e pages.
>=20
> We should also not limit/throttle wbc->nr_to_write in the filesystem =
writepages
> callback. That cause wrong behaviour in generic_sync_sb_inodes caused=
 by
> wbc->nr_to_write being <=3D 0
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Updated in patch queue.
> ---
>  fs/ext4/inode.c |  200 ++++++++++++++++++++++++++++-----------------=
---------
>  1 files changed, 104 insertions(+), 96 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a66bba..26e30ed 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -41,6 +41,8 @@
>  #include "acl.h"
>  #include "ext4_extents.h"
>=20
> +#define MPAGE_DA_EXTENT_TAIL 0x01
> +
>  static inline int ext4_begin_ordered_truncate(struct inode *inode,
>  					      loff_t new_size)
>  {
> @@ -1604,11 +1606,13 @@ static void ext4_da_page_release_reservation(=
struct page *page,
>  	unsigned long first_page, next_page;	/* extent of pages */
>  	get_block_t *get_block;
>  	struct writeback_control *wbc;
> +	int io_done;
> +	long pages_written;
>  };
>=20
>  /*
>   * mpage_da_submit_io - walks through extent of pages and try to wri=
te
> - * them with __mpage_writepage()
> + * them with writepage() call back
>   *
>   * @mpd->inode: inode
>   * @mpd->first_page: first page of the extent
> @@ -1623,18 +1627,11 @@ static void ext4_da_page_release_reservation(=
struct page *page,
>  static int mpage_da_submit_io(struct mpage_da_data *mpd)
>  {
>  	struct address_space *mapping =3D mpd->inode->i_mapping;
> -	struct mpage_data mpd_pp =3D {
> -		.bio =3D NULL,
> -		.last_block_in_bio =3D 0,
> -		.get_block =3D mpd->get_block,
> -		.use_writepage =3D 1,
> -	};
>  	int ret =3D 0, err, nr_pages, i;
>  	unsigned long index, end;
>  	struct pagevec pvec;
>=20
>  	BUG_ON(mpd->next_page <=3D mpd->first_page);
> -
>  	pagevec_init(&pvec, 0);
>  	index =3D mpd->first_page;
>  	end =3D mpd->next_page - 1;
> @@ -1652,8 +1649,9 @@ static int mpage_da_submit_io(struct mpage_da_d=
ata *mpd)
>  				break;
>  			index++;
>=20
> -			err =3D __mpage_writepage(page, mpd->wbc, &mpd_pp);
> -
> +			err =3D mapping->a_ops->writepage(page, mpd->wbc);
> +			if (!err)
> +				mpd->pages_written++;
>  			/*
>  			 * In error case, we have to continue because
>  			 * remaining pages are still locked
> @@ -1664,9 +1662,6 @@ static int mpage_da_submit_io(struct mpage_da_d=
ata *mpd)
>  		}
>  		pagevec_release(&pvec);
>  	}
> -	if (mpd_pp.bio)
> -		mpage_bio_submit(WRITE, mpd_pp.bio);
> -
>  	return ret;
>  }
>=20
> @@ -1689,7 +1684,7 @@ static void mpage_put_bnr_to_bhs(struct mpage_d=
a_data *mpd, sector_t logical,
>  	int blocks =3D exbh->b_size >> inode->i_blkbits;
>  	sector_t pblock =3D exbh->b_blocknr, cur_logical;
>  	struct buffer_head *head, *bh;
> -	unsigned long index, end;
> +	pgoff_t index, end;
>  	struct pagevec pvec;
>  	int nr_pages, i;
>=20
> @@ -1774,13 +1769,11 @@ static inline void __unmap_underlying_blocks(=
struct inode *inode,
>   *
>   * The function skips space we know is already mapped to disk blocks=
=2E
>   *
> - * The function ignores errors ->get_block() returns, thus real
> - * error handling is postponed to __mpage_writepage()
>   */
>  static void mpage_da_map_blocks(struct mpage_da_data *mpd)
>  {
> +	int err =3D 0;
>  	struct buffer_head *lbh =3D &mpd->lbh;
> -	int err =3D 0, remain =3D lbh->b_size;
>  	sector_t next =3D lbh->b_blocknr;
>  	struct buffer_head new;
>=20
> @@ -1790,35 +1783,32 @@ static void mpage_da_map_blocks(struct mpage_=
da_data *mpd)
>  	if (buffer_mapped(lbh) && !buffer_delay(lbh))
>  		return;
>=20
> -	while (remain) {
> -		new.b_state =3D lbh->b_state;
> -		new.b_blocknr =3D 0;
> -		new.b_size =3D remain;
> -		err =3D mpd->get_block(mpd->inode, next, &new, 1);
> -		if (err) {
> -			/*
> -			 * Rather than implement own error handling
> -			 * here, we just leave remaining blocks
> -			 * unallocated and try again with ->writepage()
> -			 */
> -			break;
> -		}
> -		BUG_ON(new.b_size =3D=3D 0);
> +	new.b_state =3D lbh->b_state;
> +	new.b_blocknr =3D 0;
> +	new.b_size =3D lbh->b_size;
> +
> +	/*
> +	 * If we didn't accumulate anything
> +	 * to write simply return
> +	 */
> +	if (!new.b_size)
> +		return;
> +	err =3D mpd->get_block(mpd->inode, next, &new, 1);
> +	if (err)
> +		return;
> +	BUG_ON(new.b_size =3D=3D 0);
>=20
> -		if (buffer_new(&new))
> -			__unmap_underlying_blocks(mpd->inode, &new);
> +	if (buffer_new(&new))
> +		__unmap_underlying_blocks(mpd->inode, &new);
>=20
> -		/*
> -		 * If blocks are delayed marked, we need to
> -		 * put actual blocknr and drop delayed bit
> -		 */
> -		if (buffer_delay(lbh) || buffer_unwritten(lbh))
> -			mpage_put_bnr_to_bhs(mpd, next, &new);
> +	/*
> +	 * If blocks are delayed marked, we need to
> +	 * put actual blocknr and drop delayed bit
> +	 */
> +	if (buffer_delay(lbh) || buffer_unwritten(lbh))
> +		mpage_put_bnr_to_bhs(mpd, next, &new);
>=20
> -		/* go for the remaining blocks */
> -		next +=3D new.b_size >> mpd->inode->i_blkbits;
> -		remain -=3D new.b_size;
> -	}
> +	return;
>  }
>=20
>  #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
> @@ -1864,13 +1854,9 @@ static void mpage_add_bh_to_extent(struct mpag=
e_da_data *mpd,
>  	 * need to flush current  extent and start new one
>  	 */
>  	mpage_da_map_blocks(mpd);
> -
> -	/*
> -	 * Now start a new extent
> -	 */
> -	lbh->b_size =3D bh->b_size;
> -	lbh->b_state =3D bh->b_state & BH_FLAGS;
> -	lbh->b_blocknr =3D logical;
> +	mpage_da_submit_io(mpd);
> +	mpd->io_done =3D 1;
> +	return;
>  }
>=20
>  /*
> @@ -1890,17 +1876,35 @@ static int __mpage_da_writepage(struct page *=
page,
>  	struct buffer_head *bh, *head, fake;
>  	sector_t logical;
>=20
> +	if (mpd->io_done) {
> +		/*
> +		 * Rest of the page in the page_vec
> +		 * redirty then and skip then. We will
> +		 * try to to write them again after
> +		 * starting a new transaction
> +		 */
> +		redirty_page_for_writepage(wbc, page);
> +		unlock_page(page);
> +		return MPAGE_DA_EXTENT_TAIL;
> +	}
>  	/*
>  	 * Can we merge this page to current extent?
>  	 */
>  	if (mpd->next_page !=3D page->index) {
>  		/*
>  		 * Nope, we can't. So, we map non-allocated blocks
> -		 * and start IO on them using __mpage_writepage()
> +		 * and start IO on them using writepage()
>  		 */
>  		if (mpd->next_page !=3D mpd->first_page) {
>  			mpage_da_map_blocks(mpd);
>  			mpage_da_submit_io(mpd);
> +			/*
> +			 * skip rest of the page in the page_vec
> +			 */
> +			mpd->io_done =3D 1;
> +			redirty_page_for_writepage(wbc, page);
> +			unlock_page(page);
> +			return MPAGE_DA_EXTENT_TAIL;
>  		}
>=20
>  		/*
> @@ -1931,6 +1935,8 @@ static int __mpage_da_writepage(struct page *pa=
ge,
>  		set_buffer_dirty(bh);
>  		set_buffer_uptodate(bh);
>  		mpage_add_bh_to_extent(mpd, logical, bh);
> +		if (mpd->io_done)
> +			return MPAGE_DA_EXTENT_TAIL;
>  	} else {
>  		/*
>  		 * Page with regular buffer heads, just add all dirty ones
> @@ -1939,8 +1945,12 @@ static int __mpage_da_writepage(struct page *p=
age,
>  		bh =3D head;
>  		do {
>  			BUG_ON(buffer_locked(bh));
> -			if (buffer_dirty(bh))
> +			if (buffer_dirty(bh) &&
> +				(!buffer_mapped(bh) || buffer_delay(bh))) {
>  				mpage_add_bh_to_extent(mpd, logical, bh);
> +				if (mpd->io_done)
> +					return MPAGE_DA_EXTENT_TAIL;
> +			}
>  			logical++;
>  		} while ((bh =3D bh->b_this_page) !=3D head);
>  	}
> @@ -1959,22 +1969,13 @@ static int __mpage_da_writepage(struct page *=
page,
>   *
>   * This is a library function, which implements the writepages()
>   * address_space_operation.
> - *
> - * In order to avoid duplication of logic that deals with partial pa=
ges,
> - * multiple bio per page, etc, we find non-allocated blocks, allocat=
e
> - * them with minimal calls to ->get_block() and re-use __mpage_write=
page()
> - *
> - * It's important that we call __mpage_writepage() only once for eac=
h
> - * involved page, otherwise we'd have to implement more complicated =
logic
> - * to deal with pages w/o PG_lock or w/ PG_writeback and so on.
> - *
> - * See comments to mpage_writepages()
>   */
>  static int mpage_da_writepages(struct address_space *mapping,
>  			       struct writeback_control *wbc,
>  			       get_block_t get_block)
>  {
>  	struct mpage_da_data mpd;
> +	long to_write;
>  	int ret;
>=20
>  	if (!get_block)
> @@ -1988,17 +1989,22 @@ static int mpage_da_writepages(struct address=
_space *mapping,
>  	mpd.first_page =3D 0;
>  	mpd.next_page =3D 0;
>  	mpd.get_block =3D get_block;
> +	mpd.io_done =3D 0;
> +	mpd.pages_written =3D 0;
> +
> +	to_write =3D wbc->nr_to_write;
>=20
>  	ret =3D write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd)=
;
>=20
>  	/*
>  	 * Handle last extent of pages
>  	 */
> -	if (mpd.next_page !=3D mpd.first_page) {
> +	if (!mpd.io_done && mpd.next_page !=3D mpd.first_page) {
>  		mpage_da_map_blocks(&mpd);
>  		mpage_da_submit_io(&mpd);
>  	}
>=20
> +	wbc->nr_to_write =3D to_write - mpd.pages_written;
>  	return ret;
>  }
>=20
> @@ -2210,10 +2216,7 @@ static int ext4_da_writepages(struct address_s=
pace *mapping,
>  	int ret =3D 0;
>  	long to_write;
>  	loff_t range_start =3D 0;
> -	int blocks_per_page =3D PAGE_CACHE_SIZE >> inode->i_blkbits;
> -	int max_credit_blocks =3D ext4_journal_max_transaction_buffers(inod=
e);
> -	int need_credits_per_page =3D  ext4_writepages_trans_blocks(inode, =
1);
> -	int max_writeback_pages =3D (max_credit_blocks / blocks_per_page) /=
 need_credits_per_page;
> +	long pages_skipped =3D 0;
>=20
>  	/*
>  	 * No pages to write? This is mainly a kludge to avoid starting
> @@ -2223,45 +2226,35 @@ static int ext4_da_writepages(struct address_=
space *mapping,
>  	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIR=
TY))
>  		return 0;
>=20
> -	if (wbc->nr_to_write > mapping->nrpages)
> -		wbc->nr_to_write =3D mapping->nrpages;
> -
> -	to_write =3D wbc->nr_to_write;
> -
> -	if (!wbc->range_cyclic) {
> +	if (!wbc->range_cyclic)
>  		/*
>  		 * If range_cyclic is not set force range_cont
>  		 * and save the old writeback_index
>  		 */
>  		wbc->range_cont =3D 1;
> -		range_start =3D  wbc->range_start;
> -	}
>=20
> -	while (!ret && to_write) {
> -		/*
> -		 * set the max dirty pages could be write at a time
> -		 * to fit into the reserved transaction credits
> -		 */
> -		if (wbc->nr_to_write > max_writeback_pages)
> -			wbc->nr_to_write =3D max_writeback_pages;
> +	range_start =3D  wbc->range_start;
> +	pages_skipped =3D wbc->pages_skipped;
> +
> +restart_loop:
> +	to_write =3D wbc->nr_to_write;
> +	while (!ret && to_write > 0) {
>=20
>  		/*
> -		 * Estimate the worse case needed credits to write out
> -		 * to_write pages
> +		 * we  insert one extent at a time. So we need
> +		 * credit needed for single extent allocation.
> +		 * journalled mode is currently not supported
> +		 * by delalloc
>  		 */
> -		needed_blocks =3D ext4_writepages_trans_blocks(inode,
> -							     wbc->nr_to_write);
> -		while (needed_blocks > max_credit_blocks) {
> -			wbc->nr_to_write--;
> -			needed_blocks =3D ext4_writepages_trans_blocks(inode,
> -							     wbc->nr_to_write);
> -		}
> +		BUG_ON(ext4_should_journal_data(inode));
> +		needed_blocks =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> +
>  		/* start a new transaction*/
>  		handle =3D ext4_journal_start(inode, needed_blocks);
>  		if (IS_ERR(handle)) {
>  			ret =3D PTR_ERR(handle);
> -			printk(KERN_EMERG "ext4_da_writepages: jbd2_start: "
> -			       "%ld pages, ino %lu; err %d\n",
> +			printk(KERN_EMERG "%s: jbd2_start: "
> +			       "%ld pages, ino %lu; err %d\n", __func__,
>  			       wbc->nr_to_write, inode->i_ino, ret);
>  			dump_stack();
>  			goto out_writepages;
> @@ -2284,7 +2277,14 @@ static int ext4_da_writepages(struct address_s=
pace *mapping,
>  		ret =3D mpage_da_writepages(mapping, wbc,
>  						ext4_da_get_block_write);
>  		ext4_journal_stop(handle);
> -		if (wbc->nr_to_write) {
> +		if (ret =3D=3D MPAGE_DA_EXTENT_TAIL) {
> +			/*
> +			 * got one extent now try with
> +			 * rest of the pages
> +			 */
> +			to_write +=3D wbc->nr_to_write;
> +			ret =3D 0;
> +		} else if (wbc->nr_to_write) {
>  			/*
>  			 * There is no more writeout needed
>  			 * or we requested for a noblocking writeout
> @@ -2296,10 +2296,18 @@ static int ext4_da_writepages(struct address_=
space *mapping,
>  		wbc->nr_to_write =3D to_write;
>  	}
>=20
> +	if (wbc->range_cont && (pages_skipped !=3D wbc->pages_skipped)) {
> +		/* We skipped pages in this loop */
> +		wbc->range_start =3D range_start;
> +		wbc->nr_to_write =3D to_write +
> +					wbc->pages_skipped - pages_skipped;
> +		wbc->pages_skipped =3D pages_skipped;
> +		goto restart_loop;
> +	}
> +
>  out_writepages:
>  	wbc->nr_to_write =3D to_write;
> -	if (range_start)
> -		wbc->range_start =3D range_start;
> +	wbc->range_start =3D range_start;
>  	return ret;
>  }
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
