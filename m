From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 18 Dec 2009 15:11:54 -0800
Message-ID: <6601abe90912181511t45eaaed6kb62d9c4ea5175ed6@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
	 <20091218121008.GE9437@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:40783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZLRXL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 18:11:59 -0500
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id nBINBvCI025609
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 23:11:57 GMT
Received: from qw-out-2122.google.com (qwi5.prod.google.com [10.241.195.5])
	by wpaz1.hot.corp.google.com with ESMTP id nBINBs9p026838
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 15:11:55 -0800
Received: by qw-out-2122.google.com with SMTP id 5so60853qwi.5
        for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 15:11:54 -0800 (PST)
In-Reply-To: <20091218121008.GE9437@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 18, 2009 at 4:10 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Fri, Dec 18, 2009 at 05:19:46PM +0530, Aneesh Kumar K.V wrote:
>> On Thu, Dec 10, 2009 at 09:28:28AM -0800, Curt Wohlgemuth wrote:
>> > This fixes a bug in which new blocks returned from an extent creat=
ed with
>> > ext4_ext_zeroout() can have dirty metadata still associated with t=
hem.
>> >
>> > =A0 =A0 Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>
> A better option would be to do the unmap during fallocate.

The problem here is that we'll also call unmap_underlying_metadata()
on these same blocks when they get written to, and the extents become
initialized.  At that point, the buffers are marked as 'new' and so
__block_write_full_page() and friends will again try to clear out any
old metadata.

You could argue that since there won't be any metadata that this
second call will be fast, but still...

Curt

>
> commit 87b3121fd9d1223acb08326fc0c9711b0bc3cfeb
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: =A0 Fri Dec 18 17:38:15 2009 +0530
>
> =A0 =A0ext4: unmap the underlying metadata when allocating blocks via=
 fallocate
>
> =A0 =A0This become important when we are running with nojournal mode.=
 We
> =A0 =A0may end up allocating recently freed metablocks for fallocate.=
 We
> =A0 =A0want to make sure we unmap the old mapping so that when we con=
vert
> =A0 =A0the fallocated uninitialized extent to initialized extent we d=
on't
> =A0 =A0have the old mapping around. Leaving the old mapping can cause
> =A0 =A0file system corruption
>
> =A0 =A0Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.c=
om>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ab31e65..7c0fcae 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1768,6 +1768,20 @@ static inline void set_bitmap_uptodate(struct =
buffer_head *bh)
> =A0 =A0 =A0 =A0set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
> =A0}
>
> +/*
> + * __unmap_underlying_bh_blocks - just a helper function to unmap
> + * set of blocks described by @bh
> + */
> +static inline void __unmap_underlying_bh_blocks(struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh)
> +{
> + =A0 =A0 =A0 struct block_device *bdev =3D inode->i_sb->s_bdev;
> + =A0 =A0 =A0 int blocks, i;
> +
> + =A0 =A0 =A0 blocks =3D bh->b_size >> inode->i_blkbits;
> + =A0 =A0 =A0 for (i =3D 0; i < blocks; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unmap_underlying_metadata(bdev, bh->b_b=
locknr + i);
> +}
> =A0#endif /* __KERNEL__ */
>
> =A0#endif /* _EXT4_H */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3a7928f..4e646a5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3508,6 +3508,8 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret2 =3D ext4_journal_=
stop(handle);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_new(&map_bh))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __unmap_underlying_bh_b=
locks(inode, &map_bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((block + ret) >=3D (EXT4_BLOCK_ALI=
GN(offset + len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0blkbits) >> blkbits))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_size =3D offset + =
len;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5352db1..7b44737 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2073,22 +2073,6 @@ static void mpage_put_bnr_to_bhs(struct mpage_=
da_data *mpd, sector_t logical,
> =A0 =A0 =A0 =A0}
> =A0}
>
> -
> -/*
> - * __unmap_underlying_blocks - just a helper function to unmap
> - * set of blocks described by @bh
> - */
> -static inline void __unmap_underlying_blocks(struct inode *inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh)
> -{
> - =A0 =A0 =A0 struct block_device *bdev =3D inode->i_sb->s_bdev;
> - =A0 =A0 =A0 int blocks, i;
> -
> - =A0 =A0 =A0 blocks =3D bh->b_size >> inode->i_blkbits;
> - =A0 =A0 =A0 for (i =3D 0; i < blocks; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unmap_underlying_metadata(bdev, bh->b_b=
locknr + i);
> -}
> -
> =A0static void ext4_da_block_invalidatepages(struct mpage_da_data *mp=
d,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0sector_t logical, long blk_cnt)
> =A0{
> @@ -2243,7 +2227,7 @@ static int mpage_da_map_blocks(struct mpage_da_=
data *mpd)
> =A0 =A0 =A0 =A0new.b_size =3D (blks << mpd->inode->i_blkbits);
>
> =A0 =A0 =A0 =A0if (buffer_new(&new))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __unmap_underlying_blocks(mpd->inode, &=
new);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __unmap_underlying_bh_blocks(mpd->inode=
, &new);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If blocks are delayed marked, we need to
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
