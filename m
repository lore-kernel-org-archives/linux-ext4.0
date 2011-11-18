From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 4/6] ext4: remove code related to punching hole from ext4_ext_insert_extent
Date: Fri, 18 Nov 2011 11:19:38 +0800
Message-ID: <CAGBYx2Z=2iocsyspoqt=VmzcSncEEBen9YfFz+Mi3q0EPWsWKA@mail.gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
	<1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
	<FB6BBDEB-61D7-42B2-B532-69ABBF21F125@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37190 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1KRDTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 22:19:39 -0500
Received: by ghbz2 with SMTP id z2so58140ghb.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2011 19:19:39 -0800 (PST)
In-Reply-To: <FB6BBDEB-61D7-42B2-B532-69ABBF21F125@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 18, 2011 at 12:56 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-11-16, at 19:03, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote=
:
>
>> Punch hole should never call ext4_ext_insert_extent, so this patch
>> removes code related to it from ext4_ext_insert_extent.
>
> Is that still true if punch hole is used beyond the end of the file? =
=A0I don't recall whether the semantics of this mean to extend the file=
 size or to shrink it?
Add Allison to cc list.

Punch hole is defined to 'free blocks' in documentation, so the part
beyond the end of a file should be just ignored.  Both ext4 and btrfs
act this way.

Yongqiang.
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> fs/ext4/extents.c | =A0 =A02 --
>> 1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 6888d1a..720070d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -1737,8 +1737,6 @@ int ext4_ext_insert_extent(handle_t *handle, s=
truct inode *inode,
>> =A0 =A0 * There is no free space in the found leaf.
>> =A0 =A0 * We're gonna add a new leaf in the tree.
>> =A0 =A0 */
>> - =A0 =A0if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
>> - =A0 =A0 =A0 =A0flags =3D EXT4_MB_USE_ROOT_BLOCKS;
>> =A0 =A0err =3D ext4_ext_create_new_leaf(handle, inode, flags, path, =
newext);
>> =A0 =A0if (err)
>> =A0 =A0 =A0 =A0goto cleanup;
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
