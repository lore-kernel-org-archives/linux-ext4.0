From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-delayed-allocation.patch
Date: Fri, 12 Jan 2007 17:52:29 +0300
Message-ID: <m31wm05mc2.fsf@bzzz.home.net>
References: <m37iwjwumf.fsf@bzzz.home.net> <m3tzznvfnz.fsf@bzzz.home.net>
	<45A79F07.7010204@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:54150 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751200AbXALOwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2007 09:52:34 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <45A79F07.7010204@bull.net> (Valerie Clement's message of "Fri\,
	12 Jan 2007 15\:45\:27 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


ah, you're right. thanks!

thanks, Alex

>>>>> Valerie Clement (VC) writes:

 VC> Hi Alex,
 VC> I tested your patch on my system with a 20TB device, but some test=
s
 VC> failed. Looking at the code, I saw that the support of 48-bit bloc=
k
 VC> number in extents is lacking.

 VC> I made some changes in the code (see the patch in attachment) and =
now
 VC> all my tests are OK.
 VC> The patch is not complete, I didn't update calls to wb_debug() whi=
ch
 VC> dump "ee_start".

 VC> Hope this helps.

 VC>   Val=E9rie

 VC> Index: linux-2.6.20-rc1/fs/ext4/writeback.c
 VC> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 VC> --- linux-2.6.20-rc1.orig/fs/ext4/writeback.c	2007-01-09 18:41:27.=
000000000 +0100
 VC> +++ linux-2.6.20-rc1/fs/ext4/writeback.c	2007-01-11 13:25:38.00000=
0000 +0100
 VC> @@ -274,7 +274,8 @@ static int ext4_wb_submit_extent(struct=20
 VC>  	struct inode *inode =3D wc->mapping->host;
 VC>  	int blkbits =3D inode->i_blkbits;
 VC>  	struct page *page;
 VC> -	unsigned long blk, off, len, remain;
 VC> +	ext4_fsblk_t off;
 VC> +	unsigned long blk, len, remain;
 VC>  	unsigned long pstart, plen, prev;
 VC>  	struct bio *bio =3D NULL;
 VC>  	int nr_pages;
 VC> @@ -332,6 +333,7 @@ alloc_new_bio:
 VC>  			nr_pages =3D (ex->ee_len - (blk - ex->ee_block));
 VC>  			nr_pages =3D (nr_pages >> (PAGE_CACHE_SHIFT - blkbits));
 VC>  			off =3D ex->ee_start + (blk - ex->ee_block);
 VC> +			off |=3D (ext4_fsblk_t) ex->ee_start_hi << 32;
 VC>  			bio =3D ext4_wb_bio_alloc(inode, off, nr_pages + 2);
 VC>  			if (bio =3D=3D NULL)
 VC>  				return -ENOMEM;
 VC> @@ -377,7 +379,9 @@ ext4_wb_find_goal(struct inode *inode, s
 	=09
 VC>  		/* try to predict block placement */
 VC>  		if ((ex =3D path[depth].p_ext))
 VC> -			return ex->ee_start + (block - ex->ee_block);
 VC> +			return ((ex->ee_start
 VC> +				| ((ext4_fsblk_t) ex->ee_start_hi << 32))
 VC> +				+ (block - ex->ee_block);
=20
 VC>  		/* it looks index is empty
 VC>  		 * try to find starting from index itself */
 VC> @@ -416,7 +420,8 @@ static int ext4_wb_handle_extent(struct=20
 VC>  				(unsigned) ec->ec_block,
 VC>  				(unsigned) ec->ec_len,
 VC>  				(unsigned) ec->ec_start);
 VC> -		nex.ee_start =3D ec->ec_start;
 VC> +		nex.ee_start =3D ec->ec_start & 0xffffffff;
 VC> +		nex.ee_start_hi =3D (ec->ec_start >> 32) & 0xffff;
 VC>  		nex.ee_block =3D ec->ec_block;
 VC>  		nex.ee_len =3D ec->ec_len;
 VC>  		err =3D ext4_wb_submit_extent(wc, NULL, &nex, 0);
 VC> @@ -488,8 +493,8 @@ static int ext4_wb_handle_extent(struct=20
 VC>  			pblock, count, inode->i_ino, ec->ec_len);
=20
 VC>  	/* insert new extent */
 VC> -	nex.ee_start =3D pblock;
 VC> -	nex.ee_start_hi =3D 0;
 VC> +	nex.ee_start =3D pblock & 0xffffffff;
 VC> +	nex.ee_start_hi =3D (pblock >> 32) & 0xffff;
 VC>  	nex.ee_len =3D count;
 VC>  	nex.ee_block =3D ec->ec_block;
 VC>  	err =3D ext4_ext_insert_extent(handle, inode, path, &nex);
 VC> @@ -520,7 +525,9 @@ static int ext4_wb_handle_extent(struct=20
 VC>  	/* block have been allocated for data, so time to drop dirty
 VC>  	 * in correspondend buffer_heads to prevent corruptions */
 VC>  	for (i =3D 0; i < nex.ee_len; i++)
 VC> -		unmap_underlying_metadata(sb->s_bdev, nex.ee_start + i);
 VC> +		unmap_underlying_metadata(sb->s_bdev,
 VC> +				((ext4_fsblk_t) nex.ee_start_hi << 32)
 VC> +				+ nex.ee_start + i);
=20
 VC>  	/* correct on-disk inode size */
 VC>  	if (nex.ee_len > 0) {
