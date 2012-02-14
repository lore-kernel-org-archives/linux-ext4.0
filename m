From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of
 cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Tue, 14 Feb 2012 13:24:59 -0800
Message-ID: <CAGr1F2HwdCQyz=U5EkhYMA2WXMrwxPzftj3A_EmDRXdPPVBJpw@mail.gmail.com>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
 <CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
 <20120210025526.GB21496@thunk.org> <CAFZ0FUVOnE9iLkXbwdmNAPGGBFaZ=7jqv1DRfbvTn16ubm4_SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62950 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760867Ab2BNVZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2012 16:25:19 -0500
Received: by pbcun15 with SMTP id un15so800075pbc.19
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2012 13:25:19 -0800 (PST)
In-Reply-To: <CAFZ0FUVOnE9iLkXbwdmNAPGGBFaZ=7jqv1DRfbvTn16ubm4_SA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robin,


On Tue, Feb 14, 2012 at 12:01 AM, Robin Dong <hao.bigrat@gmail.com> wro=
te:
>
> =E5=9C=A8 2012=E5=B9=B42=E6=9C=8810=E6=97=A5 =E4=B8=8A=E5=8D=8810:55=EF=
=BC=8CTed Ts'o <tytso@mit.edu> =E5=86=99=E9=81=93=EF=BC=9A
> > On Thu, Feb 02, 2012 at 03:48:49PM +0800, Robin Dong wrote:
> >>
> >> The reason is ext4_has_free_clusters reporting wrong
> >> result. Actually, the unit of argument "dirty_clusters" is block, =
so
> >> we should tranform the sbi->s_dirtyclusters_counter to block , jus=
t
> >> like "free_clusters".
> >
> > I've been looking at the the delayed allocation reservation code, a=
nd
> > I think it's a lot more confused that this. =C2=A0Some places we ar=
e
> > playing with fields as if they are clusters, and some times as if t=
hey
> > are blocks, and I've definitely found places where we're not handli=
ng
> > quota correctly with bigalloc (ext4_map_blocks is calling
> > ext4_da_update_reserve_space() with a value which is clearly in uni=
ts
> > of blocks, but we are treating that vale as if it is clusters, etc.=
)
> >
> > So I think the problem is a lot larger than what you pointed out, a=
nd
> > we shouldn't fix it just by throwing in an EXT4_C2B call. =C2=A0If
> > s_dirtyclusters_counter should be denominated in blocks, then we ne=
ed
> > to rename it. =C2=A0And there there's this comment which made me wi=
nce:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Note that in case of bigalloc,=
 i_reserved_meta_blocks,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * i_reserved_data_blocks, etc. r=
efer to number of clusters.
> >
> > Argh, no. =C2=A0If something is denominated in clusters, then it sh=
ould be
> > appropriately named as such.
> >
> > Actually, I think the problem is a lot bigger than this, and it's a
> > conceptual one. =C2=A0When we try writing to a block which does not=
 have a
> > mapping, and bigalloc is enabled, there are three cases:
> >
> > 1) This is the first time the cluster has ever been written to; hen=
ce,
> > even though we are dirtying a block, we need to reserve room for th=
e
> > entire cluster.
> >
> > 2) While the block has not been mapped (and so the data on disk is
> > uninitialized) the cluster has indeed been allocated, so we don't n=
eed
> > to reserve any additional room for the block.
> >
> > 3) One or more blocks in the cluster have already been written to v=
ia
> > delayed allocation, but the cluster itself has not been selected
> > (allocated) yet. =C2=A0But since the space for the entire cluster w=
as
> > reserved when the first block in the cluster was dirtied (case #1),=
 we
> > don't need to reserve any more space.
> >
> > We aren't handling these cases correctly today, since we don't have
> > this logic here. =C2=A0These cases don't matter if you're only usin=
g
> > fallocate() and direct I/O, but if you are using buffered writes an=
d
> > delayed allocation, they obviously matter a huge amount.
> >
>
> > And I don't think we're handling it correctly. =C2=A0 Argh...
> >

I thought we do handle these cases correctly after the 'ext4: attempt
to fix race in bigalloc code path' change. May be I missed something
or the code changed somewhere. If there is a testcase that fails, I
can take a look.

> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - Ted
>
> Hi, Ted and Aditya
>
> I am trying to fix this "bigalloc quota reservation in
> delay-allocation" problem recently, and I feel confusion about these
> code below in ext4_ext_map_blocks():
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (flags & EXT4_GET_BLOCKS_DELALLOC_RESER=
VE) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int r=
eserved_clusters;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Check how m=
any clusters we had reserved this allocated range
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserved_clust=
ers =3D get_reserved_cluster_alloc(inode,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0map->m_lblk, allocated);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (map->m_fla=
gs & EXT4_MAP_FROM_CLUSTER) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (reserved_clusters) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0......
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_da_update_reserve_space(=
inode,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0reserved_clusters, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0BUG_ON(allocated_clusters < reserved_clusters);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* We will claim quota for all newly allocated blocks.*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ext4_da_update_reserve_space(inode, allocated_clusters,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (reserved_clusters < allocated_clusters) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_inode_info *ei =3D=
 EXT4_I(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int reservation =3D allocated=
_clusters -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserved_clusters;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dquot_reserve_block(inode,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0EXT4_C2B(sbi, reservation));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&ei->i_block_reserv=
ation_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ei->i_reserved_data_blocks +=3D=
 reservation;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&ei->i_block_rese=
rvation_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> if we have allocated 3 clusters, why should we add "reservation" back
> to i_reservd_data_blocks ?
Because we will end up here again next time when we write blocks
[10-11] and try to claim space for them. At this time, there will be
no more reserved blocks left (unless you give them back) and you will
hit the warning in ext4_da_update_reserve_space():

	if (unlikely(used > ei->i_reserved_data_blocks)) {
		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
			 "with only %d reserved data blocks\n",
			 __func__, inode->i_ino, used,
			 ei->i_reserved_data_blocks);
		WARN_ON(1);
		used =3D ei->i_reserved_data_blocks;
	}


> (Aditya Kali 's long comment dose not make
> sense to me) Maybe we don't need to do ext4_da_update_reserve_space
> when the new block is allocated from "implied_cluster"? Why not just
> change them to:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (flags & EXT4_GET_BLOCKS_DELALLOC_RESER=
VE) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ( !(map->m_=
flags & EXT4_MAP_FROM_CLUSTER) )
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* We will claim quota for all newly allocated blocks.*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ext4_da_update_reserve_space(inode, allocated_clusters,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>

This won't work in all cases, like the one given in the long comment.
With above change, ext4_da_update_reserve_space() will get called
again the next time for some delayed allocated blocks in the same
cluster, but there isn't any reserved blocks left to claim.
The flag 'EXT4_MAP_FROM_CLUSTER' is not a sufficient check to
determine 'how many' clusters we need to claim. This is because
get_implied_cluster_alloc() only checks within already allocated
extents (and not in the page cache). So, I had to add the function
get_reserved_cluster_alloc() to check if there are any delayed
allocated blocks still in the page-cache.
You will also miss the other case (when=C2=A0EXT4_MAP_FROM_CLUSTER is s=
et)
where we had reserved the cluster, but ended up not allocating it.
Since this cluster was not allocated, we need to update the reserved
space without claiming quota (ext4_da_update_reserve_space(inode,
reserved_clusters, 0) --- notice the last argument is '0').

I know its kinda messy, but I think it works. Also, since we don't
keep track of delayed extents, its harder to check in one go.

As for your proposed fix earlier, the correct solution will be to not
convert 'free_clusters' value into blocks.

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f9e2cd8..2c518f8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -426,7 +426,7 @@ static int ext4_has_free_clusters(struct ext4_sb_in=
fo *sbi,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (free_clusters - (nclusters + root_clust=
ers + dirty_clusters) <
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4=
_FREECLUSTERS_WATERMARK) {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_clusters =C2=A0=
=3D EXT4_C2B(sbi,
percpu_counter_sum_positive(fcc));
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_clusters =C2=A0=
=3D percpu_counter_sum_positive(fcc);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dirty_clusters =
=3D percpu_counter_sum_positive(dcc);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Check whether we have space after accoun=
ting for current


We were incorrectly converting clusters to blocks and so estimating
that we have more free clusters available than what we actually do.
Hence the dmesg errors at write time.

>
> --
> --
> Best Regard
> Robin Dong


Thanks,
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
