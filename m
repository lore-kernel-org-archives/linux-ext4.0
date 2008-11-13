From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: calculate journal credits correctly
Date: Wed, 12 Nov 2008 16:03:42 -0800
Message-ID: <1226534622.12488.25.camel@mingming-laptop>
References: <20081103033920.GC29102@mit.edu>
	 <1226001075-16457-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Aneesh Kumar <aneesh.kumar@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34913 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYKMADo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 19:03:44 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAD03HVx007593
	for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2008 17:03:17 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAD03h5W163328
	for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2008 17:03:43 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAD03Dvc005937
	for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2008 17:03:14 -0700
In-Reply-To: <1226001075-16457-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-11-06=E5=9B=9B=E7=9A=84 14:51 -0500=EF=BC=8CTheodore Ts'=
o=E5=86=99=E9=81=93=EF=BC=9A
> This fixes a 2.6.27 regression which was introduced in commit a02908f=
1.
>=20
> We weren't passing the chunk parameter down to the two subections,
> ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), with
> the result that massively overestimate the amount of credits needed b=
y
> ext4_da_writepages, especially in the non-extents case.  This causes
> failures especially on /boot partitions, which tend to be small and
> non-extent using since GRUB doesn't handle extents.
>=20
> Thanks to Joseph Fannin for reporting this bug.
>=20
Thanks for fixing this up!

However, looking at the code path, I wasn't sure if we got the delalloc
credits right.  In ext4_da_writepages()->mpage_da_writepages(),  the
credits is calculated based on the assumption that mpage_da_writepages(=
)
doing* one* single chunk of contigugous allocation? So only one single
extent credit is reserved (here you see the "chunk" flag passed from th=
e
ext4_da_writepages)

__mpage_da_writepage() does do single chunk of block allocation at a
time, but mpage_da_writepages()->write_cache_pages() will loop the page
vectors and probably will calling writepage->__mpage_da_writepage->
mpage_da_map_blocks() multiple times?  Am I  missing anything?


> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8dbf695..5a130b5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4580,9 +4580,10 @@ static int ext4_indirect_trans_blocks(struct i=
node *inode, int nrblocks,
>  static int ext4_index_trans_blocks(struct inode *inode, int nrblocks=
, int chunk)
>  {
>  	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> -		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
> -	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
> +		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
> +	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
>  }
> +
>  /*
>   * Account for index blocks, block groups bitmaps and block group
>   * descriptor blocks if modify datablocks and index blocks

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
