From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH v2] ext4: avoid eh_entries overflow before insert extent_idx
Date: Fri, 24 Jun 2011 16:27:29 +0800
Message-ID: <BANLkTi=E5xZG6ey3FyDXV=-O7=+V6Mb2WQ@mail.gmail.com>
References: <1308818837-5243-1-git-send-email-sanbai@taobao.com>
	<4E035453.8080808@redhat.com>
	<BANLkTinmwdXURNGw+OsMRST4x_S+z+R4Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Robin Dong <sanbai@taobao.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64565 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1FXI1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 04:27:30 -0400
Received: by iyb12 with SMTP id 12so2203687iyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jun 2011 01:27:30 -0700 (PDT)
In-Reply-To: <BANLkTinmwdXURNGw+OsMRST4x_S+z+R4Sw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/24 Yongqiang Yang <xiaoqiangnk@gmail.com>:
> On Thu, Jun 23, 2011 at 10:57 PM, Eric Sandeen <sandeen@redhat.com> w=
rote:
>> On 6/23/11 3:47 AM, Robin Dong wrote:
>>> If eh_entries is equal to (or greater than) eh_max, the operation o=
f
>>> inserting new extent_idx will make number of entries overflow.
>>> So check eh_entries before inserting the new extent_idx.
>>
>> Do you have any testcase you can share which shows this bug?
> I am not sure if Robin has any test case.
>
> According to code, I think there is no bug case. =A0Because this
> function is called by ext4_ext_split() and ext4_ext_split() is called
> only if the index block has free space.
>
> I think the right logic should be as this patch shows, that is, we
> should lookup the capacity before insertion.

Exactly!  :-)

--=20
--
Best Regard
Robin Dong


>
> Yongqiang.
>>
>> Thanks,
>> -Eric
>>
>>> Signed-off-by: Robin Dong <sanbai@taobao.com>
>>> ---
>>> =A0fs/ext4/extents.c | =A0 18 ++++++++++--------
>>> =A01 files changed, 10 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index eb63c7b..792e77e 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -776,6 +776,16 @@ static int ext4_ext_insert_index(handle_t *han=
dle, struct inode *inode,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0logi=
cal, le32_to_cpu(curp->p_idx->ei_block));
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>>> =A0 =A0 =A0 }
>>> +
>>> + =A0 =A0 if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0>=3D le16_to_c=
pu(curp->p_hdr->eh_max))) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"eh_en=
tries %d >=3D eh_max %d!",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(curp->p_hdr->eh_entries),
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(curp->p_hdr->eh_max));
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>>> + =A0 =A0 }
>>> +
>>> =A0 =A0 =A0 len =3D EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
>>> =A0 =A0 =A0 if (logical > le32_to_cpu(curp->p_idx->ei_block)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* insert after */
>>> @@ -805,14 +815,6 @@ static int ext4_ext_insert_index(handle_t *han=
dle, struct inode *inode,
>>> =A0 =A0 =A0 ext4_idx_store_pblock(ix, ptr);
>>> =A0 =A0 =A0 le16_add_cpu(&curp->p_hdr->eh_entries, 1);
>>>
>>> - =A0 =A0 if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0> le16_to_cpu(=
curp->p_hdr->eh_max))) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"eh_en=
tries %d > eh_max %d!",
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(curp->p_hdr->eh_entries),
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(curp->p_hdr->eh_max));
>>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>>> - =A0 =A0 }
>>> =A0 =A0 =A0 if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode, "ix > EXT_LAST_=
INDEX!");
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
