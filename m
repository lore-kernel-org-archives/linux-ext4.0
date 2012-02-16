From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of
 cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Thu, 16 Feb 2012 12:12:28 -0800
Message-ID: <CAGr1F2EtO6Oyf7RTfVwgAd2hC6wtYJLoS39mGM0N4qW3F-GXFQ@mail.gmail.com>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
 <CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
 <20120210025526.GB21496@thunk.org> <CAFZ0FUVOnE9iLkXbwdmNAPGGBFaZ=7jqv1DRfbvTn16ubm4_SA@mail.gmail.com>
 <CAGr1F2HwdCQyz=U5EkhYMA2WXMrwxPzftj3A_EmDRXdPPVBJpw@mail.gmail.com> <CAFZ0FUUGpkVCmRuLN-iQ2N73D3wN+0Y6k_3TA4FzjVow=P447A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2BPUMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 15:12:49 -0500
Received: by daed14 with SMTP id d14so2384911dae.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2012 12:12:48 -0800 (PST)
In-Reply-To: <CAFZ0FUUGpkVCmRuLN-iQ2N73D3wN+0Y6k_3TA4FzjVow=P447A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 14, 2012 at 7:19 PM, Robin Dong <hao.bigrat@gmail.com> wrot=
e:
> But I found the code in ext4_ext_map_blocks():
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((sbi->s_cluster_ratio > 1) &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_find_delalloc_cluster(i=
node, map->m_lblk, 0))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map->m_flags |=
=3D EXT4_MAP_FROM_CLUSTER;
>
> thus, even the delayed allocated block in the page-cache (have not be
> allocated) already have been checked. Therefore in my opinion, the
> EXT4_MAP_FROM_CLUSTER is a sufficient check.
>
> Follow the case of your long comment :) , =C2=A0process will go like =
this
> in MY CODE ABOVE :
>
> [0-3], [4-7], [8-11]
>
> 1. delay-allocation write blocks 10&11
> =C2=A0 =C2=A0we reserve 1 cluster, the i_reserved_data_blocks is 1 no=
w
> 2. delay-allocation write blocks 3 to 8
> =C2=A0 =C2=A0we reserve other 2 clusters, so 3 clusters totally, the
> i_reserved_data_blocks is 3 now
> 3. writeout the blocks 3 to 8
> =C2=A0 =C2=A0claim all 3 clusters, i_reserved_data_blocks is 0 now
> =C2=A0 =C2=A0At this moment, we really have allocated 3 clusters, and=
 the
> remain 10&11 block would never occupy another cluster (it would
> definitely go into the [8-11] cluster), so, why need we reserve one
> more cluster quota ?
> 4. =C2=A0writeout the 10&11 blocks
> =C2=A0 =C2=A0the 10&11 blocks will be set EXT4_MAP_FROM_CLUSTER flag =
( by
> get_implied_cluster_alloc as the 8~9 block have been allocated), and
> it will not call ext4_da_update_reserve_space any more
>
> As this, no warning, no reserve-and-release ping pong....at least in =
my imaging
>
I couldn't look into this in detail, but your logic seems totally
fine. But when I wrote this code, I remember being able to reproduce
the quota warnings by running xfstests (some corner case that needed
this code).

> Could you please point out what I missed ?
>
> Thanks
>

--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
