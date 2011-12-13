From: Eric Gouriou <egouriou@google.com>
Subject: Re: [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
Date: Mon, 12 Dec 2011 16:01:56 -0800
Message-ID: <CAMUAhYRgnQoKSPtRpSa+W+afyezQAVJ8jZykQHfjuZ2gggrs=w@mail.gmail.com>
References: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
	<CAMUAhYSCFivbHbmeRRGxSC1qiFq1OQbhajNLCXn28rvvGTGPkg@mail.gmail.com>
	<CAGBYx2boc0OtAOq7BNurQkCZG0Oeyf2LLd+F-9EvwL31CNccmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"achender@linux.vnet.ibm.com" <achender@linux.vnet.ibm.com>,
	"hughd@google.com" <hughd@google.com>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41716 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1LMAB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2011 19:01:58 -0500
Received: by qcqz2 with SMTP id z2so4091042qcq.19
        for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 16:01:57 -0800 (PST)
In-Reply-To: <CAGBYx2boc0OtAOq7BNurQkCZG0Oeyf2LLd+F-9EvwL31CNccmw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Yet another resend, without HTML and _with_ the list CC'ed. Apologies
for the spam]

On Fri, Dec 9, 2011 at 19:36, Yongqiang Yang <xiaoqiangnk@gmail.com> wr=
ote:
>
>
> On Saturday, December 10, 2011, Eric Gouriou <egouriou@google.com> wr=
ote:
>> On Tue, Dec 6, 2011 at 21:21, Yongqiang Yang <xiaoqiangnk@gmail.com>
>> wrote:
>>> If a file is fallocated on a hole, map->m_lblk + map->m_len may be
>>> greater
>>> than ee_block + ee_len.
>>
>> Could you please detail a scenario that leads to this check being in=
valid?
>> As I'm to blame for the faulty BUG_ON I'd like to use this as an
>> opportunity
>> to get properly edified.
> It's easy to reproduce, I think. =C2=A0 Just need to write beyond fal=
located
> blocks, write back would submit a request to ext4_map_blocks with blo=
cks
> part of which are fallocated while other part of which are not, then =
the
> bug-on would happen.

Thanks, this makes sense.

>
> I met the bug_on during fsx and after the patch applied it works norm=
al.
>
> I think Allison also tested with this patch.
>
> Yongqiang..
>
>>
>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Reviewed-by: Eric Gouriou <egouriou@google.com>

 Thanks - Eric

>>> ---
>>> =C2=A0fs/ext4/extents.c | =C2=A0 =C2=A01 -
>>> =C2=A01 files changed, 0 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index 6f0300e..29bb629 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -2943,7 +2943,6 @@ static int ext4_ext_convert_to_initialized(ha=
ndle_t
>>> *handle,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Pre-conditions */
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!ext4_ext_is_uninitialized(ex));
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!in_range(map->m_lblk, ee_block, =
ee_len));
>>> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(map->m_lblk + map->m_len > ee_block +=
 ee_len);
>>
>> For a bit I thought this would break the fast path logic, however it=
 gets
>> protected by the checks marked /*L1*/ and /*L2*/ since m_lblk =3D=3D=
 ee_block
>> (L1) and m_len < ee_len (L2).
>>
>> =C2=A0Regards - Eric
>>
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Attempt to transfer newly initialized=
 blocks from the currently
>>> --
>>> 1.7.5.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
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
