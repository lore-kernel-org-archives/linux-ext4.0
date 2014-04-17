From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 1/3] ext4: fix COLLAPSE_RANGE failure issue on ext4 with
 1KB block size
Date: Thu, 17 Apr 2014 18:23:07 +0900
Message-ID: <007f01cf5a1e$a4ca6500$ee5f2f00$@samsung.com>
References: <002901cf59c3$16b21ca0$441655e0$@samsung.com>
 <alpine.LFD.2.00.1404171017220.2143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:18316 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDQJXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 05:23:09 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N460036O4QKWKE0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 18:23:08 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1404171017220.2143@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, 17 Apr 2014, Namjae Jeon wrote:
>=20
> > Date: Thu, 17 Apr 2014 07:27:45 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
> >     'Luk=E1=B9 Czerner' <lczerner@redhat.com>
> > Subject: [PATCH 1/3] ext4: fix COLLAPSE_RANGE failure issue on ext4=
 with 1KB
> >     block size
> >
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > When formatting with 1KB or 2KB(not aligned with PAGE SIZE) block s=
ize,
> > xfstests generic/075 and 091 are failing. The offset supplied to fu=
nction
> > truncate_pagecache_range is block size aligned. In this function st=
art offset
> > is re-aligned to PAGE_SIZE by rounding_up to the next page boundary=
=2E
> > Due to this rounding up, old data remains in the page cache when bl=
ocksize is
> > less than page size and start offset is not aligned with page size.
> > In case of collapse range, we need to align start offset to page si=
ze boundary
> > by doing a round down operation instead of round up.
>=20
> Great, thanks for finding it.
>=20
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/extents.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 1bb3e4b..f386dd6 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -5404,8 +5404,8 @@ int ext4_collapse_range(struct inode *inode, =
loff_t offset, loff_t len)
> >  	struct super_block *sb =3D inode->i_sb;
> >  	ext4_lblk_t punch_start, punch_stop;
> >  	handle_t *handle;
> > -	unsigned int credits;
> > -	loff_t new_size;
> > +	unsigned int credits, rounding;
> > +	loff_t new_size, ioffset;
> >  	int ret;
> >
> >  	/* Collapse range works only on fs block size aligned offsets. */
> > @@ -5428,8 +5428,11 @@ int ext4_collapse_range(struct inode *inode,=
 loff_t offset, loff_t len)
> >  			return ret;
> >  	}
> >
> > +	rounding =3D max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACH=
E_SIZE);
> > +	ioffset =3D offset & ~(rounding - 1);
>=20
> That looks like you're expecting that block size might be bigger
> than page size. That's definitely not the case at the moment as we
> can not have block size > page size. There is a discussion to
> support this in the future, but even when the infrastructure is done
> we would have to revisit the code anyway. So I do not think this is
> needed. Just always round it down to PAGE_SIZE (since that's what
> truncate_pagecache is actually using)
Right :), I will change it.

>=20
> > +
> >  	/* Write out all dirty pages */
> > -	ret =3D filemap_write_and_wait_range(inode->i_mapping, offset, -1=
);
> > +	ret =3D filemap_write_and_wait_range(inode->i_mapping, ioffset, -=
1);
> >  	if (ret)
> >  		return ret;
> >
> > @@ -5451,7 +5454,7 @@ int ext4_collapse_range(struct inode *inode, =
loff_t offset, loff_t len)
> >  		goto out_mutex;
> >  	}
> >
> > -	truncate_pagecache_range(inode, offset, -1);
> > +	truncate_pagecache_range(inode, ioffset, -1);
>=20
> As I mentioned in a different email we can just use
> truncate_pagecache(). In fact we should use it because we want to
> remove private COWed pages as well I think.
Okay, If you send the updated your patch, I will create the patch base =
on your patch again.

Thanks :)
>=20
> Thanks!
> -Lukas
>=20
> >
> >  	/* Wait for existing dio to complete */
> >  	ext4_inode_block_unlocked_dio(inode);
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
