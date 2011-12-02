From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 4/6] ext4: remove code related to punching hole from ext4_ext_insert_extent
Date: Fri, 2 Dec 2011 09:09:33 +0800
Message-ID: <CAGBYx2ZVMaYofC6WBQrKCD9H1Kw9KrkipS9jTRECw-1m14_tgg@mail.gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
	<1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
	<4ED7E9C9.2020307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61541 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1LBBJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 20:09:34 -0500
Received: by ghrr1 with SMTP id r1so2415888ghr.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Dec 2011 17:09:33 -0800 (PST)
In-Reply-To: <4ED7E9C9.2020307@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 2, 2011 at 4:55 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 11/16/2011 07:03 PM, Yongqiang Yang wrote:
>>
>> Punch hole should never call ext4_ext_insert_extent, so this patch
>> removes code related to it from ext4_ext_insert_extent.
>>
>> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/extents.c | =A0 =A02 --
>> =A01 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 6888d1a..720070d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -1737,8 +1737,6 @@ int ext4_ext_insert_extent(handle_t *handle, s=
truct
>> inode *inode,
>> =A0 =A0 =A0 =A0 * There is no free space in the found leaf.
>> =A0 =A0 =A0 =A0 * We're gonna add a new leaf in the tree.
>> =A0 =A0 =A0 =A0 */
>> - =A0 =A0 =A0 if (flag& =A0EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D EXT4_MB_USE_ROOT_BLOCKS;
>> =A0 =A0 =A0 =A0err =3D ext4_ext_create_new_leaf(handle, inode, flags=
, path, newext);
>> =A0 =A0 =A0 =A0if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
>
> Hi Yongqiang,
>
> Actually I believe it does end up inserting an extent if an extent ge=
ts
> split. For example, we punch a hole in the middle of an extent, so we=
 first
> split the extent into three pieces, and remove the middle piece.
>
> Because inserting the extra extents can require extra blocks, the ope=
ration
> may temporarily consume blocks. The problem that this causes is that =
if the
> file system is really full, it can fail with ENOSPC, even though punc=
h hole
> is an operation that is supposed to free blocks. =A0The above
> EXT4_MB_USE_ROOT_BLOCKS flag was put in so that when we punch holes, =
we can
> borrow reserved blocks to complete the operation to avoid the ENOSPC
> problem. =A0I had a script to catch this and added to xfstests (test =
256). So
> unless there was a change somewhere that I missed, it does not make s=
ense to
> me to take it out at this point.
Got it.  Thank you for your explanation.

Yongqiang.
>
> Allison Henderson
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
