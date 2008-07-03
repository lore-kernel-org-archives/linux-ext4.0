From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Gentoo with ext4-patch-queue snapshots
Date: Thu, 03 Jul 2008 10:38:40 -0700
Message-ID: <1215106720.6880.5.camel@mingming-laptop>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
	 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
	 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
	 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
	 <3.0.6.32.20080701175011.02437350@pop.west.cox.net>
	 <1215019194.6788.10.camel@mingming-laptop>
	 <1215030837.6788.37.camel@mingming-laptop>
	 <cc723f590807030707j5ec31f0p5db26bf8529c61ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:53068 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYGCRin (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 13:38:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m63HcfGo031689
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 13:38:41 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m63HcfXm161982
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 11:38:41 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m63HcfhZ029398
	for <linux-ext4@vger.kernel.org>; Thu, 3 Jul 2008 11:38:41 -0600
In-Reply-To: <cc723f590807030707j5ec31f0p5db26bf8529c61ef@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-03=E5=9B=9B=E7=9A=84 19:37 +0530=EF=BC=8CAneesh Kumar=
=E5=86=99=E9=81=93=EF=BC=9A
> [sending via gmail  ]
>=20
> On Thu, Jul 03, 2008 at 05:03:25PM +0530, Aneesh Kumar K.V wrote:
> > On Wed, Jul 02, 2008 at 10:19:54AM -0700, Mingming Cao wrote:
> > >
> > > On Tue, 2008-07-01 at 17:50 +0000, Gary Hawco wrote:
> > > > Mingming,
> > > >
> > > > Can you post that patch somewhere for download? I access my ema=
il using
> > > > Windows Vista, not in linux, so it would be very laborious to h=
and copy
> > > > this patch and recreate it in linux.
> > > >
> > > Patch attached.
> > >
> > > > Updated the 2.6.26-rc8 kernel with the latest snapshot from tod=
ay at
> > > > 1833hrs GMT. All hell broke loose in Gentoo, The new kernel wou=
ldn't allow
> > > > the system to remount read/write on boot.  But it worked fine i=
n Slackware.
> > > > Gentoo with the experimental openrc-0.2.5 and baselayout2 appar=
ently does
> > > > not like ext4.
> > > >
> > >
> >
> > I think we need to protect i_disksize update with i_data_sem. Other=
wise
> > a parallel writepages and write_end can cause issues. I guess that =
is
> > what Gary is finding. I also did some cleanup for the patch
> >
>=20
> better one moving ext4_truncate i_disksize update under i_data_sem.
> ext4_ext_truncate is already doing this.
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fcaafe4..05e9790 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1893,18 +1893,29 @@ static int ext4_da_write_begin(struct file
> *file, struct address_space *mapping,
>  /*
>   * Check if we should update i_disksize
>   * when write to the end of file but not require block allocation
> + * We check only the buffer head mapping the offset.
> + * ex: File with blocksize 1K page size 4K
> + * block 1 and 2 are holes, block 3 is mapped and half filled
> + * seek to block 1 and write ( marked the buffer delay )
> + * seek to block 3 and extent the end of file with end of file still
> + * falling within block 3. Here the writepages won't update the i_di=
sksize
> + * properly because it allocate only block 1. So we need to update
> + * i_disksize in write_end checking only the offset
> + *
>   */

Okay, Iwill add this comment

> -static int ext4_da_should_update_i_disksize(struct page *page,
> -					 unsigned long offset)
> +static int ext4_da_should_update_i_disksize(struct address_space *ma=
pping,
> +					struct page *page, unsigned long offset)
>  {
> -	struct buffer_head *bh;
> -	unsigned int idx;
>  	int i;
> +	unsigned int idx;
> +	struct buffer_head *bh;
> +	struct inode *inode =3D mapping->host;
> +	unsigned blocksize =3D inode->i_sb->s_blocksize;
>=20
We could use page->mapping->host to get the inode pointer, so no need t=
o
pass the mapping pointer. But I am fine with this.

>  	bh =3D page_buffers(page);
> -	idx =3D offset/bh->b_size;
> +	idx =3D (offset + blocksize - 1)/blocksize;
>=20
> -	for (i=3D0; i < idx; i++)
> +	for (i =3D 1; i < idx; i++)
>  		bh =3D bh->b_this_page;
>=20
Ack

>  	if (!buffer_mapped(bh) || (buffer_delay(bh)))
> @@ -1934,15 +1945,20 @@ static int ext4_da_write_end(struct file *fil=
e,
>=20
>  	new_i_size =3D pos + copied;
>  	if (new_i_size > EXT4_I(inode)->i_disksize)
> -		if (ext4_da_should_update_i_disksize(page, end)) {
> +		if (ext4_da_should_update_i_disksize(mapping, page, end)) {
>  			/*
>  			 * Updating i_disksize when extending file without
>  			 * need block allocation
>  			 */
> -			if (ext4_should_order_data(inode))
> -				ret =3D ext4_jbd2_file_inode(handle, inode);
> +			down_write(&EXT4_I(inode)->i_data_sem);
> +			if (new_i_size > EXT4_I(inode)->i_disksize) {
> +				if (ext4_should_order_data(inode))
> +					ret =3D ext4_jbd2_file_inode(handle,
> +									inode);
>=20
> -			EXT4_I(inode)->i_disksize =3D new_i_size;
> +				EXT4_I(inode)->i_disksize =3D new_i_size;
> +			}
> +			up_write(&EXT4_I(inode)->i_data_sem);
>  		}
>  	ret2 =3D generic_write_end(file, mapping, pos, len, copied,
>  							page, fsdata);
> @@ -2987,6 +3003,11 @@ void ext4_truncate(struct inode *inode)
>  	 */
>  	if (ext4_orphan_add(handle, inode))
>  		goto out_stop;
> +	/*
> +	 * From here we block out all ext4_get_block() callers who want to
> +	 * modify the block allocation tree.
> +	 */
> +	down_write(&ei->i_data_sem);
>=20
>  	/*
>  	 * The orphan list entry will now protect us from any crash which
> @@ -2997,12 +3018,6 @@ void ext4_truncate(struct inode *inode)
>  	 */
>  	ei->i_disksize =3D inode->i_size;
>=20
> -	/*
> -	 * From here we block out all ext4_get_block() callers who want to
> -	 * modify the block allocation tree.
> -	 */
> -	down_write(&ei->i_data_sem);
> -
>  	if (n =3D=3D 1) {		/* direct blocks */
>  		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
>  			       i_data + EXT4_NDIR_BLOCKS);
>=20

Ack.

I will merge the update to the parent patch, thanx

Mingming
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
