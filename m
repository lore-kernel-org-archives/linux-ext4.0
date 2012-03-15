From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] enable ext4 allocate blocks across group boundary
Date: Thu, 15 Mar 2012 10:57:49 +0800
Message-ID: <CAGBYx2YESmmVxr+9=+sPgyepdm=rW2fKGVrp=RGFe=yYOgoN9A@mail.gmail.com>
References: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
	<CAFZ0FUVBBmtLkmYmBbN_WyLWU2GwJHyS=cX_MC0oFiZbxf0LEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2COC5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 22:57:50 -0400
Received: by yenl12 with SMTP id l12so2575595yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 19:57:49 -0700 (PDT)
In-Reply-To: <CAFZ0FUVBBmtLkmYmBbN_WyLWU2GwJHyS=cX_MC0oFiZbxf0LEQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/15 Robin Dong <hao.bigrat@gmail.com>:
> =D4=DA 2012=C4=EA3=D4=C215=C8=D5 =C9=CF=CE=E78:52=A3=ACYongqiang Yang=
 <xiaoqiangnk@gmail.com> =D0=B4=B5=C0=A3=BA
>> Hello List,
>>
>> Here is a proposal to enable ext4 allocate blocks across group bound=
ary.
>>
>> Now ext4 allocates blocks within a single block group by locking a
>> group.   Flex_bg puts metadata blocks together, as a result,it
>> enlarges contiguous blocks.  So we can enable ext4 allocate blocks
>> within a flex block group. Inode allocation takes group lock as bloc=
k
>> allocation,  I am not sure if we should allocate inode within single
>> group as before.
>>
>> If we do this, then the new group boundary will be flex block group
>> boundary.  I am not sure if it is worth doing.
>
> IMO, since the max size of one ext4-extent is just 128MB, maybe a
> contiguous space
> beyond a single block group can not be used efficiently.
I do not think maximum of extent size limits the value of block
allocation across group boundary.

Actually, maximum of contiguous blocks is determined by block
allocation strategy(multi block allocation, preallocation, group
selection ...) rather than others.   Given that ext4 is indirect
mapped and uses current block allocation strategy, contiguous blocks
is still same.

Yongqiang.
>
>>
>>
>> Any ideas?
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> --
> Best Regard
> Robin Dong



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
