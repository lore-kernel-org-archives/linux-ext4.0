From: Greg Harm <gharm@google.com>
Subject: Re: [PATCH] Ext4: Don't normalize an falloc request if it can fit in
 1 extent.
Date: Fri, 28 Oct 2011 12:05:30 -0700
Message-ID: <CABFC-fM8pMoJ=hUKOixNkva98P6_XD5PxXq3Tq0vE+5u-iEz3A@mail.gmail.com>
References: <1319824917-28345-1-git-send-email-gharm@google.com> <472B9A86-7C0A-4AAC-882E-9A739BBBE523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab1J1TGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 15:06:06 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id p9SJ64gK013901
	for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 12:06:05 -0700
Received: from vws15 (vws15.prod.google.com [10.241.21.143])
	by hpaq3.eem.corp.google.com with ESMTP id p9SJ62XO023918
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 12:06:03 -0700
Received: by vws15 with SMTP id 15so6164055vws.10
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 12:06:02 -0700 (PDT)
In-Reply-To: <472B9A86-7C0A-4AAC-882E-9A739BBBE523@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 28, 2011 at 11:47 AM, Andreas Dilger <aedilger@gmail.com> w=
rote:
> On 2011-10-28, at 12:01 PM, Greg Harm <gharm@google.com> wrote:
>> If an fallocate request fits in EXT_UNINIT_MAX_LEN, then set the
>> EXT4_GET_BLOCKS_NO_NORMALIZE flag. For larger fallocate requests,
>> let mballoc.c normalize the request.
>> This fixes a problem where large requests were being split
>> into non-contiguous extents due to haldar@google.com's
>> "ext4: do not normalize block requests from fallocate."
>>
>> Testing: Checked that 8.x MB falloc'ed files are still laid down
>> next to each other (contiguously).
>> Checked that the maximum size extent (127.9MB) is allocated as 1
>> extent.
>> Checked that a 1GB file is somewhat contiguous (often 5-6
>> non-contiguous extents now).
>> Checked that a 120MB file can still be falloc'ed even if there are n=
o
>> single extents large enough to hold it.
>
> It would be great to add these test cases to xfstests so that this do=
esn't break in the future.
Hi Andreas,

I totally agree. I have that on my TODO list (but no current ETA).

Thanks,
Greg

>> Signed-off-by: Greg Harm <gharm@google.com>
>> ---
>> fs/ext4/extents.c | =A0 13 ++++++++++---
>> 1 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 57cf568..9819216 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3761,6 +3761,7 @@ long ext4_fallocate(struct file *file, int mod=
e, loff_t offset, loff_t len)
>> =A0 =A0int ret2 =3D 0;
>> =A0 =A0int retries =3D 0;
>> =A0 =A0struct ext4_map_blocks map;
>> + =A0 =A0int map_blocks_flags;
>> =A0 =A0unsigned int credits, blkbits =3D inode->i_blkbits;
>>
>> =A0 =A0/*
>> @@ -3805,9 +3806,15 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0break;
>> =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 =A0ret =3D ext4_map_blocks(handle, inode, &map,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_GET_BLOCKS_CREATE_=
UNINIT_EXT |
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_GET_BLOCKS_NO_NORM=
ALIZE);
>> + =A0 =A0 =A0 =A0map_blocks_flags =3D EXT4_GET_BLOCKS_CREATE_UNINIT_=
EXT;
>> + =A0 =A0 =A0 =A0/*
>> + =A0 =A0 =A0 =A0 * Don't normalize the request if it can fit in one=
 extent so
>> + =A0 =A0 =A0 =A0 * that it doesn't get unnecessarily split into mul=
tiple
>> + =A0 =A0 =A0 =A0 * extents.
>> + =A0 =A0 =A0 =A0 */
>> + =A0 =A0 =A0 =A0if (len <=3D EXT_UNINIT_MAX_LEN << blkbits)
>> + =A0 =A0 =A0 =A0 =A0 =A0map_blocks_flags |=3D EXT4_GET_BLOCKS_NO_NO=
RMALIZE;
>> + =A0 =A0 =A0 =A0ret =3D ext4_map_blocks(handle, inode, &map, map_bl=
ocks_flags);
>> =A0 =A0 =A0 =A0if (ret <=3D 0) {
>> #ifdef EXT4FS_DEBUG
>> =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(ret <=3D 0);
>> --
>> 1.7.3.1
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
