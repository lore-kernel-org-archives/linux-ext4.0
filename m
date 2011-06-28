From: Eric Gouriou <egouriou@google.com>
Subject: Re: [PATCH v2] ext4: avoid redundant cache finding if flags not
 cantian PUNCH_OUT
Date: Mon, 27 Jun 2011 17:44:58 -0700
Message-ID: <BANLkTinLRiRakANN-VqEr8mcTdxyT1SGm2oMgKufcnbk=dKnVQ@mail.gmail.com>
References: <1309171513-5246-1-git-send-email-sanbai@taobao.com>
	<20110627195911.GD20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: djwong@us.ibm.com, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:1474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1F1ApC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 20:45:02 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p5S0j0XP007769
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 17:45:00 -0700
Received: from gyd10 (gyd10.prod.google.com [10.243.49.202])
	by kpbe20.cbf.corp.google.com with ESMTP id p5S0iCst023690
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 17:44:59 -0700
Received: by gyd10 with SMTP id 10so2826465gyd.16
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 17:44:58 -0700 (PDT)
In-Reply-To: <20110627195911.GD20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 12:59, Darrick J. Wong <djwong@us.ibm.com> wrot=
e:
> On Mon, Jun 27, 2011 at 06:45:13PM +0800, Robin Dong wrote:
>> Subject: [PATCH v2] ext4: avoid redundant cache finding if flags not=
 cantian
>
> I suspect you mean "contain" as opposed to "cantian".

The patch summary line could also use some shortening.

>> In old code, ext4 will find extent in cache first even flags does
>> not contian PUNCH_OUT, that may waste some time.
>
> Same here ("contian").

How about something along the lines of:
---------
ext4: avoid wasted extent cache lookup if !PUNCH_OUT_EXT

This patch avoids an extraneous lookup of the extent cache
in ext4_ext_map_blocks() when the flag
EXT4_GET_BLOCKS_PUNCH_OUT_EXT is absent.

The existing logic was performing the lookup but not making
use of the result. The patch simply reverses the order of evaluation
in the condition.

Since ext4_ext_in_cache() does not initialize newex on misses, bypassin=
g
its invocation does not introduce any new issue in this regard.
---------

 Regards - Eric

>
> --D
>>
>> Signed-off-by: Robin Dong <sanbai@taobao.com>
>> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>> =C2=A0fs/ext4/extents.c | =C2=A0 =C2=A04 ++--
>> =C2=A01 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index eb63c7b..fed2633 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, stru=
ct inode *inode,
>> =C2=A0 =C2=A0 =C2=A0 trace_ext4_ext_map_blocks_enter(inode, map->m_l=
blk, map->m_len, flags);
>>
>> =C2=A0 =C2=A0 =C2=A0 /* check in cache */
>> - =C2=A0 =C2=A0 if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((flags & EXT4_GET_BLOCK=
S_PUNCH_OUT_EXT) =3D=3D 0)) {
>> + =C2=A0 =C2=A0 if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_ext_in_cache(inode,=
 map->m_lblk, &newex)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!newex.ee_start=
_lo && !newex.ee_start_hi) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if ((flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
