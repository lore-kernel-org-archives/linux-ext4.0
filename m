From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH 1/3] ext4: s_freeclusters_counter should not tranform to
 unit of block before assigning to "free_clusters" in ext4_has_free_cluste
Date: Mon, 16 Apr 2012 11:35:44 +0800
Message-ID: <CAFZ0FUWbYrB8mfM9oQYd1x4wTbLmk8kOHzmDpiCK-ZLhqajbVg@mail.gmail.com>
References: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
	<20120324210518.GB5883@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2DPDfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Apr 2012 23:35:45 -0400
Received: by obbta14 with SMTP id ta14so3082751obb.19
        for <linux-ext4@vger.kernel.org>; Sun, 15 Apr 2012 20:35:44 -0700 (PDT)
In-Reply-To: <20120324210518.GB5883@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2012=C4=EA3=D4=C225=C8=D5 =C9=CF=CE=E75:05=A3=ACTed Ts'o <tytso@=
mit.edu> =D0=B4=B5=C0=A3=BA
> On Tue, Mar 13, 2012 at 07:38:16PM +0800, Robin Dong wrote:
>> Creating 4-byte files until ENOSPC in a delay-allocation and bigallo=
c ext4 fs and then sync it, the dmseg will report like:
>>
>>       [  482.154538] EXT4-fs (sdb6): delayed block allocation failed=
 for inode 1664 at logical offset 0 with max blocks 1 with error -28
>>       [  482.154540] EXT4-fs (sdb6): This should not happen!! Data w=
ill be lost
>>
>> The reason is ext4_has_free_clusters reporting wrong
>> result. Actually, the unit of sbi->s_dirtyclusters_counter is block,
>> so we should tranform it to cluster for argument "dirty_clusters",
>> just like "free_clusters".
>
> We have a bigger problem here, which is that this is not the only
> place where s_dirty_clusters_counter is being used in units of
> clusters.  (See ext4_claim_free_clusters, which when called by mballo=
c
> is using units of clusters.)
>
> We definitely have brokeness here, but this is not the whole story.
> We need to take a step back here and decide whether the correct units
> is clusters or blocks.  Ultimately I think it does need to be
> clusters, because we can't just convert blocks and clusters by using
> B2C; we could dirty 3 blocks, but if those 3 blocks span two 64-block
> clusters, what's important is that we have to reserve space for 2
> clusters.  We can't just calculate "3 >> 6" and assume that we can
> reserve 0 clusters and be done with it!

Hi, Ted

Actually, I have complete this logic in my "[PATCH 2/3] ext4: modify
the implementation of quota reservation in bigalloc-delay-allocation"
(http://marc.info/?l=3Dlinux-ext4&m=3D133163876628132&w=3D2)  patch,
when those 3 blocks span two clusters, the logic in
ext4_ext_map_blocks() will check whether a block is already in a
delay-allocated-cluster (or already be
allocated in disk) and ultimately reserved 2 clusters for the 3 blocks.

Imaging block0 and block1 in cluster0, block2 in cluster1. When
ext4_da_map_blocks() process block0, we will call
ext4_da_reserve_space() (which will
reserve a cluster) and bump s_dirtycluster_counter , but when process
block1, ext4_ext_map_blocks will return flag with
EXT4_MAP_FROM_CLUSTER
and we will not bump s_dirtycluster_counter this time since block1 is
belong to a already reserved cluster.

Maybe I misunderstanding your meaning, could you please point out my fa=
ult?

Thanks.

>
> This is one of the places where I think we need to solve things by
> having a better data structure for tracking which pages have been
> subject to delayed allocation, since if we touch another block in a
> cluster where we've done a delayed allocation, we don't need to bump
> s_dirtyclusters_counter.  However, if this is the first time we've
> touched a block in a particular cluster, then we *do* need to bump
> s_dirtyclusters_counter --- and if we need to search all of the pages
> in the page cache to make this determination, it's going to be
> painful....
>
>                                        - Ted



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
