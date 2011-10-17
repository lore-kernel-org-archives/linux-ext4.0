From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: fix wrong verification in ext4_ext_insert_index
Date: Mon, 17 Oct 2011 17:00:24 +0800
Message-ID: <CAGBYx2axPjaUp2P=9Sq_DtPQa97MnJRUrWkxVmE3Rr9nzJVHcA@mail.gmail.com>
References: <1318831867-8225-1-git-send-email-xiaoqiangnk@gmail.com>
	<4E9BEC1C.3050905@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57354 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1JQJAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 05:00:25 -0400
Received: by gyb13 with SMTP id 13so2735711gyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 02:00:25 -0700 (PDT)
In-Reply-To: <4E9BEC1C.3050905@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 17, 2011 at 4:49 PM, Tao Ma <tm@tao.ma> wrote:
> Hi yongqiang,
> On 10/17/2011 02:11 PM, Yongqiang Yang wrote:
>> After inserting an new index, current number of indexes should
>> be greater than original number by 1. =A0So if the new index is
>> less or equal than LAST_INDEX + 1, then indexes are continugous.
>> If new index will be placed on the end, then ix will equals
>> LAST_INDEX + 1. Index entries has been verifiyed in pervious code
>> in ext4_ext_insert_index.
> Thanks for the effort. But actually this is caused by my original pat=
ch
> 4fd30c033, and your fix doesn't resolve the problem I want to fix. So
> consider ix is already overflow, the check can't prevent it from
> stamping on the memory after this extent block. I have sent another f=
ix
> for it.
Thanks!

Sorry!  My working tree is not up to date:-)

Yongqiang.
>
> Thanks
> Tao
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/extents.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 2dff31e..322398e 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -779,7 +779,7 @@ static int ext4_ext_insert_index(handle_t *handl=
e, struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ix =3D curp->p_idx;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
>> + =A0 =A0 if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr) + 1)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode, "ix > EXT_LAST_I=
NDEX!");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 }
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
