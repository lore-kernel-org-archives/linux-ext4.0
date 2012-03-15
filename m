From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [RFC] enable ext4 allocate blocks across group boundary
Date: Thu, 15 Mar 2012 10:36:24 +0800
Message-ID: <CAFZ0FUVBBmtLkmYmBbN_WyLWU2GwJHyS=cX_MC0oFiZbxf0LEQ@mail.gmail.com>
References: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63738 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2COCgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 22:36:25 -0400
Received: by yhmm54 with SMTP id m54so2615958yhm.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 19:36:24 -0700 (PDT)
In-Reply-To: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2012=C4=EA3=D4=C215=C8=D5 =C9=CF=CE=E78:52=A3=ACYongqiang Yang <=
xiaoqiangnk@gmail.com> =D0=B4=B5=C0=A3=BA
> Hello List,
>
> Here is a proposal to enable ext4 allocate blocks across group bounda=
ry.
>
> Now ext4 allocates blocks within a single block group by locking a
> group.   Flex_bg puts metadata blocks together, as a result,it
> enlarges contiguous blocks.  So we can enable ext4 allocate blocks
> within a flex block group. Inode allocation takes group lock as block
> allocation,  I am not sure if we should allocate inode within single
> group as before.
>
> If we do this, then the new group boundary will be flex block group
> boundary.  I am not sure if it is worth doing.

IMO, since the max size of one ext4-extent is just 128MB, maybe a
contiguous space
beyond a single block group can not be used efficiently.

>
>
> Any ideas?
>
> --
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
