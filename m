From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of
 cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Wed, 15 Feb 2012 11:19:33 +0800
Message-ID: <CAFZ0FUUGpkVCmRuLN-iQ2N73D3wN+0Y6k_3TA4FzjVow=P447A@mail.gmail.com>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
	<CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
	<20120210025526.GB21496@thunk.org>
	<CAFZ0FUVOnE9iLkXbwdmNAPGGBFaZ=7jqv1DRfbvTn16ubm4_SA@mail.gmail.com>
	<CAGr1F2HwdCQyz=U5EkhYMA2WXMrwxPzftj3A_EmDRXdPPVBJpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41210 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757702Ab2BODTd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Feb 2012 22:19:33 -0500
Received: by obcva7 with SMTP id va7so866555obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2012 19:19:33 -0800 (PST)
In-Reply-To: <CAGr1F2HwdCQyz=U5EkhYMA2WXMrwxPzftj3A_EmDRXdPPVBJpw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2012=C4=EA2=D4=C215=C8=D5 =C9=CF=CE=E75:24=A3=ACAditya Kali <adi=
tyakali@google.com> =D0=B4=B5=C0=A3=BA
> Hi Robin,
>
>
> On Tue, Feb 14, 2012 at 12:01 AM, Robin Dong <hao.bigrat@gmail.com> w=
rote:
>>
>> =D4=DA 2012=C4=EA2=D4=C210=C8=D5 =C9=CF=CE=E710:55=A3=ACTed Ts'o <ty=
tso@mit.edu> =D0=B4=B5=C0=A3=BA
>> > On Thu, Feb 02, 2012 at 03:48:49PM +0800, Robin Dong wrote:
>> >>
>> >> The reason is ext4_has_free_clusters reporting wrong
>> >> result. Actually, the unit of argument "dirty_clusters" is block,=
 so
>> >> we should tranform the sbi->s_dirtyclusters_counter to block , ju=
st
>> >> like "free_clusters".
>> >
>> > I've been looking at the the delayed allocation reservation code, =
and
>> > I think it's a lot more confused that this.  Some places we are
>> > playing with fields as if they are clusters, and some times as if =
they
>> > are blocks, and I've definitely found places where we're not handl=
ing
>> > quota correctly with bigalloc (ext4_map_blocks is calling
>> > ext4_da_update_reserve_space() with a value which is clearly in un=
its
>> > of blocks, but we are treating that vale as if it is clusters, etc=
=2E)
>> >
>> > So I think the problem is a lot larger than what you pointed out, =
and
>> > we shouldn't fix it just by throwing in an EXT4_C2B call.  If
>> > s_dirtyclusters_counter should be denominated in blocks, then we n=
eed
>> > to rename it.  And there there's this comment which made me wince:
>> >
>> >           * Note that in case of bigalloc, i_reserved_meta_blocks,
>> >           * i_reserved_data_blocks, etc. refer to number of cluste=
rs.
>> >
>> > Argh, no.  If something is denominated in clusters, then it should=
 be
>> > appropriately named as such.
>> >
>> > Actually, I think the problem is a lot bigger than this, and it's =
a
>> > conceptual one.  When we try writing to a block which does not hav=
e a
>> > mapping, and bigalloc is enabled, there are three cases:
>> >
>> > 1) This is the first time the cluster has ever been written to; he=
nce,
>> > even though we are dirtying a block, we need to reserve room for t=
he
>> > entire cluster.
>> >
>> > 2) While the block has not been mapped (and so the data on disk is
>> > uninitialized) the cluster has indeed been allocated, so we don't =
need
>> > to reserve any additional room for the block.
>> >
>> > 3) One or more blocks in the cluster have already been written to =
via
>> > delayed allocation, but the cluster itself has not been selected
>> > (allocated) yet.  But since the space for the entire cluster was
>> > reserved when the first block in the cluster was dirtied (case #1)=
, we
>> > don't need to reserve any more space.
>> >
>> > We aren't handling these cases correctly today, since we don't hav=
e
>> > this logic here.  These cases don't matter if you're only using
>> > fallocate() and direct I/O, but if you are using buffered writes a=
nd
>> > delayed allocation, they obviously matter a huge amount.
>> >
>>
>> > And I don't think we're handling it correctly.   Argh...
>> >
>
> I thought we do handle these cases correctly after the 'ext4: attempt
> to fix race in bigalloc code path' change. May be I missed something
> or the code changed somewhere. If there is a testcase that fails, I
> can take a look.
>
>> >                                                 - Ted
>>
>> Hi, Ted and Aditya
>>
>> I am trying to fix this "bigalloc quota reservation in
>> delay-allocation" problem recently, and I feel confusion about these
>> code below in ext4_ext_map_blocks():
>>
>>        if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
>>                unsigned int reserved_clusters;
>>                /*
>>                 * Check how many clusters we had reserved this alloc=
ated range
>>                 */
>>                reserved_clusters =3D get_reserved_cluster_alloc(inod=
e,
>>                                                map->m_lblk, allocate=
d);
>>                if (map->m_flags & EXT4_MAP_FROM_CLUSTER) {
>>                        if (reserved_clusters) {
>>                                ......
>>                                ext4_da_update_reserve_space(inode,
>>                                                reserved_clusters, 0)=
;
>>                        }
>>                } else {
>>                        BUG_ON(allocated_clusters < reserved_clusters=
);
>>                        /* We will claim quota for all newly allocate=
d blocks.*/
>>                        ext4_da_update_reserve_space(inode, allocated=
_clusters,
>>                                                        1);
>>                        if (reserved_clusters < allocated_clusters) {
>>                                struct ext4_inode_info *ei =3D EXT4_I=
(inode);
>>                                int reservation =3D allocated_cluster=
s -
>>                                                  reserved_clusters;
>>                                dquot_reserve_block(inode,
>>                                                EXT4_C2B(sbi, reserva=
tion));
>>                                spin_lock(&ei->i_block_reservation_lo=
ck);
>>                                ei->i_reserved_data_blocks +=3D reser=
vation;
>>                                spin_unlock(&ei->i_block_reservation_=
lock);
>>                        }
>>                }
>>        }
>>
>> if we have allocated 3 clusters, why should we add "reservation" bac=
k
>> to i_reservd_data_blocks ?
> Because we will end up here again next time when we write blocks
> [10-11] and try to claim space for them. At this time, there will be
> no more reserved blocks left (unless you give them back) and you will
> hit the warning in ext4_da_update_reserve_space():
>
>        if (unlikely(used > ei->i_reserved_data_blocks)) {
>                ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used =
%d "
>                         "with only %d reserved data blocks\n",
>                         __func__, inode->i_ino, used,
>                         ei->i_reserved_data_blocks);
>                WARN_ON(1);
>                used =3D ei->i_reserved_data_blocks;
>        }
>
>
>> (Aditya Kali 's long comment dose not make
>> sense to me) Maybe we don't need to do ext4_da_update_reserve_space
>> when the new block is allocated from "implied_cluster"? Why not just
>> change them to:
>>
>>        if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
>>                if ( !(map->m_flags & EXT4_MAP_FROM_CLUSTER) )
>>                        /* We will claim quota for all newly allocate=
d blocks.*/
>>                        ext4_da_update_reserve_space(inode, allocated=
_clusters,
>>                                                        1);
>>        }
>>
>
> This won't work in all cases, like the one given in the long comment.
> With above change, ext4_da_update_reserve_space() will get called
> again the next time for some delayed allocated blocks in the same
> cluster, but there isn't any reserved blocks left to claim.
> The flag 'EXT4_MAP_FROM_CLUSTER' is not a sufficient check to
> determine 'how many' clusters we need to claim. This is because
> get_implied_cluster_alloc() only checks within already allocated
> extents (and not in the page cache). So, I had to add the function
> get_reserved_cluster_alloc() to check if there are any delayed
> allocated blocks still in the page-cache.

But I found the code in ext4_ext_map_blocks():

        if ((sbi->s_cluster_ratio > 1) &&
            ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
                map->m_flags |=3D EXT4_MAP_FROM_CLUSTER;

thus, even the delayed allocated block in the page-cache (have not be
allocated) already have been checked. Therefore in my opinion, the
EXT4_MAP_FROM_CLUSTER is a sufficient check.

=46ollow the case of your long comment :) ,  process will go like this
in MY CODE ABOVE :

[0-3], [4-7], [8-11]

1. delay-allocation write blocks 10&11
    we reserve 1 cluster, the i_reserved_data_blocks is 1 now
2. delay-allocation write blocks 3 to 8
    we reserve other 2 clusters, so 3 clusters totally, the
i_reserved_data_blocks is 3 now
3. writeout the blocks 3 to 8
    claim all 3 clusters, i_reserved_data_blocks is 0 now
    At this moment, we really have allocated 3 clusters, and the
remain 10&11 block would never occupy another cluster (it would
definitely go into the [8-11] cluster), so, why need we reserve one
more cluster quota ?
4.  writeout the 10&11 blocks
    the 10&11 blocks will be set EXT4_MAP_FROM_CLUSTER flag ( by
get_implied_cluster_alloc as the 8~9 block have been allocated), and
it will not call ext4_da_update_reserve_space any more

As this, no warning, no reserve-and-release ping pong....at least in my=
 imaging

Could you please point out what I missed ?

Thanks

> You will also miss the other case (when EXT4_MAP_FROM_CLUSTER is set)
> where we had reserved the cluster, but ended up not allocating it.
> Since this cluster was not allocated, we need to update the reserved
> space without claiming quota (ext4_da_update_reserve_space(inode,
> reserved_clusters, 0) --- notice the last argument is '0').
>
> I know its kinda messy, but I think it works. Also, since we don't
> keep track of delayed extents, its harder to check in one go.
>
> As for your proposed fix earlier, the correct solution will be to not
> convert 'free_clusters' value into blocks.
>
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index f9e2cd8..2c518f8 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -426,7 +426,7 @@ static int ext4_has_free_clusters(struct ext4_sb_=
info *sbi,
>
>         if (free_clusters - (nclusters + root_clusters + dirty_cluste=
rs) <
>                                         EXT4_FREECLUSTERS_WATERMARK) =
{
> -               free_clusters  =3D EXT4_C2B(sbi,
> percpu_counter_sum_positive(fcc));
> +               free_clusters  =3D percpu_counter_sum_positive(fcc);
>                 dirty_clusters =3D percpu_counter_sum_positive(dcc);
>         }
>         /* Check whether we have space after accounting for current
>
>
> We were incorrectly converting clusters to blocks and so estimating
> that we have more free clusters available than what we actually do.
> Hence the dmesg errors at write time.
>
>>
>> --
>> --
>> Best Regard
>> Robin Dong
>
>
> Thanks,
> Aditya



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
