From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V5] ext4: fix BUG when calling ext4_error with locked
	block group
Date: Tue, 02 Dec 2008 14:47:36 -0800
Message-ID: <1228258056.6378.20.camel@mingming-laptop>
References: <1228198197-23752-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48563 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYLBWrn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 17:47:43 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB2Ml1ZL004959
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 15:47:01 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB2MlhgV219620
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 15:47:43 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB2MlcgT004134
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 15:47:42 -0700
In-Reply-To: <1228198197-23752-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-12-02=E4=BA=8C=E7=9A=84 11:39 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> The mballoc code likes to call ext4_error while it is holding locked
> block groups.  This can causes a scheduling in atomic context BUG.  W=
e
> can't just unlock the block group and relock it after/if ext4_error
> returns since that might result in race conditions in the case where
> the filesystem is set to continue after finding errors.
>=20
> -V5 changes:
> update ext4_commit_super to use the percpu free blocks and free inode=
s
> counter values.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h    |   47 +++++++++++++++++++++++++++++++++++++++++++=
++++
>  fs/ext4/mballoc.c |   30 +++++++++++++++---------------
>  fs/ext4/mballoc.h |   47 -------------------------------------------=
----
>  fs/ext4/super.c   |   45 +++++++++++++++++++++++++++++++++++++++++++=
--
>  4 files changed, 105 insertions(+), 64 deletions(-)



>  void ext4_update_dynamic_rev(struct super_block *sb)
>  {
>  	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> @@ -2820,8 +2858,11 @@ static void ext4_commit_super(struct super_blo=
ck *sb,
>  		set_buffer_uptodate(sbh);
>  	}
>  	es->s_wtime =3D cpu_to_le32(get_seconds());
> -	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
> -	es->s_free_inodes_count =3D cpu_to_le32(ext4_count_free_inodes(sb))=
;
> +	ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
> +					&EXT4_SB(sb)->s_freeblocks_counter));
> +	es->s_free_inodes_count =3D cpu_to_le32(percpu_counter_sum_positive=
(
> +					&EXT4_SB(sb)->s_freeinodes_counter));
> +
>  	BUFFER_TRACE(sbh, "marking dirty");
>  	mark_buffer_dirty(sbh);
>  	if (sync) {

I thought the per cpu s_freeblocks_counter is not as accurate as the su=
m
of group free blocks counters, we are depending on
ext4_count_free_blocks() to gets the accurate free blocks counter
flushed to disk...

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
