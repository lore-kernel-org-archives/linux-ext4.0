From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: invalidate pages if delalloc block
	allocation fails.
Date: Mon, 11 Aug 2008 14:50:32 -0700
Message-ID: <1218491432.6766.24.camel@mingming-laptop>
References: <1218450188-9643-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1218450188-9643-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1218450188-9643-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35970 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYHKVue (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 17:50:34 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7BLoXBl007872
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:50:33 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BLoXTX166876
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 15:50:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BLoX1A008318
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 15:50:33 -0600
In-Reply-To: <1218450188-9643-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-11=E4=B8=80=E7=9A=84 15:53 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> We are a bit agressive in invalidating all the pages. But
> it is ok because we really don't know why the block allocation
> failed and it is better to come of the writeback path
> so that user can look for more info.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Added to unstable patch queue for more testing. =20
> ---
>  fs/ext4/inode.c |   63 +++++++++++++++++++++++++++++++++++++++++++++=
+++++++++-
>  1 files changed, 62 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26e30ed..e437a5b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1761,6 +1761,39 @@ static inline void __unmap_underlying_blocks(s=
truct inode *inode,
>  		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
>  }
>=20
> +static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
> +					sector_t logical, long blk_cnt)
> +{
> +	int nr_pages, i;
> +	pgoff_t index, end;
> +	struct pagevec pvec;
> +	struct inode *inode =3D mpd->inode;
> +	struct address_space *mapping =3D inode->i_mapping;
> +
> +	index =3D logical >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
> +	end   =3D (logical + blk_cnt - 1) >>
> +				(PAGE_CACHE_SHIFT - inode->i_blkbits);
> +	while (index <=3D end) {
> +		nr_pages =3D pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
> +		if (nr_pages =3D=3D 0)
> +			break;
> +		for (i =3D 0; i < nr_pages; i++) {
> +			struct page *page =3D pvec.pages[i];
> +			index =3D page->index;
> +			if (index > end)
> +				break;
> +			index++;
> +
> +			BUG_ON(!PageLocked(page));
> +			BUG_ON(PageWriteback(page));
> +			block_invalidatepage(page, 0);
> +			ClearPageUptodate(page);
> +			unlock_page(page);
> +		}
> +	}
> +	return;
> +}
> +
>  /*
>   * mpage_da_map_blocks - go through given space
>   *
> @@ -1794,8 +1827,36 @@ static void mpage_da_map_blocks(struct mpage_d=
a_data *mpd)
>  	if (!new.b_size)
>  		return;
>  	err =3D mpd->get_block(mpd->inode, next, &new, 1);
> -	if (err)
> +	if (err) {
> +
> +		/* If get block returns with error
> +		 * we simply return. Later writepage
> +		 * will redirty the page and writepages
> +		 * will find the dirty page again
> +		 */
> +		if (err =3D=3D -EAGAIN)
> +			return;
> +		/*
> +		 * get block failure will cause us
> +		 * to loop in writepages. Because
> +		 * a_ops->writepage won't be able to
> +		 * make progress. The page will be redirtied
> +		 * by writepage and writepages will again
> +		 * try to write the same.
> +		 */
> +		printk(KERN_EMERG "%s block allocation failed for inode %lu "
> +				  "at logical offset %llu with max blocks "
> +				  "%zd with error %d\n",
> +				  __func__, mpd->inode->i_ino,
> +				  (unsigned long long)next,
> +				  lbh->b_size >> mpd->inode->i_blkbits, err);
> +		printk(KERN_EMERG "This should not happen.!! "
> +					"Data will be lost\n");
> +		/* invlaidate all the pages */
> +		ext4_da_block_invalidatepages(mpd, next,
> +				lbh->b_size >> mpd->inode->i_blkbits);
>  		return;
> +	}
>  	BUG_ON(new.b_size =3D=3D 0);
>=20
>  	if (buffer_new(&new))

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
