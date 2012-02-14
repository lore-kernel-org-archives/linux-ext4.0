From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of
 cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Tue, 14 Feb 2012 16:01:36 +0800
Message-ID: <CAFZ0FUVOnE9iLkXbwdmNAPGGBFaZ=7jqv1DRfbvTn16ubm4_SA@mail.gmail.com>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
	<CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
	<20120210025526.GB21496@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>, Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37721 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab2BNIBh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Feb 2012 03:01:37 -0500
Received: by obcva7 with SMTP id va7so7744213obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2012 00:01:36 -0800 (PST)
In-Reply-To: <20120210025526.GB21496@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2012=C4=EA2=D4=C210=C8=D5 =C9=CF=CE=E710:55=A3=ACTed Ts'o <tytso=
@mit.edu> =D0=B4=B5=C0=A3=BA
> On Thu, Feb 02, 2012 at 03:48:49PM +0800, Robin Dong wrote:
>>
>> The reason is ext4_has_free_clusters reporting wrong
>> result. Actually, the unit of argument "dirty_clusters" is block, so
>> we should tranform the sbi->s_dirtyclusters_counter to block , just
>> like "free_clusters".
>
> I've been looking at the the delayed allocation reservation code, and
> I think it's a lot more confused that this.  Some places we are
> playing with fields as if they are clusters, and some times as if the=
y
> are blocks, and I've definitely found places where we're not handling
> quota correctly with bigalloc (ext4_map_blocks is calling
> ext4_da_update_reserve_space() with a value which is clearly in units
> of blocks, but we are treating that vale as if it is clusters, etc.)
>
> So I think the problem is a lot larger than what you pointed out, and
> we shouldn't fix it just by throwing in an EXT4_C2B call.  If
> s_dirtyclusters_counter should be denominated in blocks, then we need
> to rename it.  And there there's this comment which made me wince:
>
>           * Note that in case of bigalloc, i_reserved_meta_blocks,
>           * i_reserved_data_blocks, etc. refer to number of clusters.
>
> Argh, no.  If something is denominated in clusters, then it should be
> appropriately named as such.
>
> Actually, I think the problem is a lot bigger than this, and it's a
> conceptual one.  When we try writing to a block which does not have a
> mapping, and bigalloc is enabled, there are three cases:
>
> 1) This is the first time the cluster has ever been written to; hence=
,
> even though we are dirtying a block, we need to reserve room for the
> entire cluster.
>
> 2) While the block has not been mapped (and so the data on disk is
> uninitialized) the cluster has indeed been allocated, so we don't nee=
d
> to reserve any additional room for the block.
>
> 3) One or more blocks in the cluster have already been written to via
> delayed allocation, but the cluster itself has not been selected
> (allocated) yet.  But since the space for the entire cluster was
> reserved when the first block in the cluster was dirtied (case #1), w=
e
> don't need to reserve any more space.
>
> We aren't handling these cases correctly today, since we don't have
> this logic here.  These cases don't matter if you're only using
> fallocate() and direct I/O, but if you are using buffered writes and
> delayed allocation, they obviously matter a huge amount.
>
> And I don't think we're handling it correctly.   Argh...
>
>                                                 - Ted

Hi, Ted and Aditya

I am trying to fix this "bigalloc quota reservation in
delay-allocation" problem recently, and I feel confusion about these
code below in ext4_ext_map_blocks():

        if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
                unsigned int reserved_clusters;
                /*
                 * Check how many clusters we had reserved this allocat=
ed range
                 */
                reserved_clusters =3D get_reserved_cluster_alloc(inode,
                                                map->m_lblk, allocated)=
;
                if (map->m_flags & EXT4_MAP_FROM_CLUSTER) {
                        if (reserved_clusters) {
                                ......
                                ext4_da_update_reserve_space(inode,
                                                reserved_clusters, 0);
                        }
                } else {
                        BUG_ON(allocated_clusters < reserved_clusters);
                        /* We will claim quota for all newly allocated =
blocks.*/
                        ext4_da_update_reserve_space(inode, allocated_c=
lusters,
                                                        1);
                        if (reserved_clusters < allocated_clusters) {
                                struct ext4_inode_info *ei =3D EXT4_I(i=
node);
                                int reservation =3D allocated_clusters =
-
                                                  reserved_clusters;
                                dquot_reserve_block(inode,
                                                EXT4_C2B(sbi, reservati=
on));
                                spin_lock(&ei->i_block_reservation_lock=
);
                                ei->i_reserved_data_blocks +=3D reserva=
tion;
                                spin_unlock(&ei->i_block_reservation_lo=
ck);
                        }
                }
        }

if we have allocated 3 clusters, why should we add "reservation" back
to i_reservd_data_blocks ? (Aditya Kali 's long comment dose not make
sense to me) Maybe we don't need to do ext4_da_update_reserve_space
when the new block is allocated from "implied_cluster"? Why not just
change them to:

        if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
                if ( !(map->m_flags & EXT4_MAP_FROM_CLUSTER) )
                        /* We will claim quota for all newly allocated =
blocks.*/
                        ext4_da_update_reserve_space(inode, allocated_c=
lusters,
                                                        1);
        }

--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
