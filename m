From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error path
Date: Thu, 14 Apr 2011 10:46:00 +0300
Message-ID: <BANLkTinCdpMoEf_Qwq48vPsfxmsFtoOG3g@mail.gmail.com>
References: <20110414064441.GA3499@darkstar>
	<BANLkTinPupXGmYTq16hcgexdUP+czYRc4A@mail.gmail.com>
	<4DA6A262.6060202@tieto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yang Rui Rui <ruirui.r.yang@tieto.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60316 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1DNHqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 03:46:01 -0400
Received: by yia27 with SMTP id 27so606610yia.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 00:46:00 -0700 (PDT)
In-Reply-To: <4DA6A262.6060202@tieto.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 10:29 AM, Yang Rui Rui <ruirui.r.yang@tieto.com=
> wrote:
> Hi,
>
> Thanks for your comment. BTW, why linux-kernel mainling list is remov=
ed from
> cc?
> Is it ext4 list prefer or something else?

ext4 list is the place to post fixes for ext4.
LKML need not be bothered with these specific patches.

>
> On 04/14/2011 03:01 PM, Amir Goldstein wrote:
>>
>> Hi Yang ,
>>
>> The patch looks correct, but in my opinion a nicer fix would be to s=
et
>> e4b->bd_bitmap_page =3D page;
>> or
>> e4b->bd_buddy_page =3D page;
>> right after assigning a new value to the temp variable 'page'.
>> and keeping the cleanup code in the error path as it is.
>>
>> It's a matter of taste and code readability.
>
> I agree with you for common case, but this function is not so readabl=
e
> already.
> Two many if conditions and indent. I would prefer just fix this probl=
em as
> this patch.

As I said it's a matter of taste so I'm not going to argue.
One argument in favor of your patch is that it adds fewer lines.

> Then rewrite the function as more small size functions for example th=
e get
> page part.
>

If you are going to audit code or rework functions in mballoc.c,
I suggest that you first take look at my patches to remove alloc_semp.
Those already involve some rework in mballoc.c.
See online version at:
https://github.com/amir73il/ext4-snapshots/tree/alloc_semp

>>
>> Amir.
>>
>> On Thu, Apr 14, 2011 at 9:44 AM, Yang Ruirui<ruirui.r.yang@tieto.com=
>
>> =C2=A0wrote:
>>>
>>> Add missing page_cache_release in the error path of ext4_mb_load_bu=
ddy
>>>
>>> Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>
>>> ---
>>> =EF=BF=BDfs/ext4/mballoc.c | =EF=BF=BD =EF=BF=BD2 ++
>>> =EF=BF=BD1 file changed, 2 insertions(+)
>>>
>>> --- linux-2.6.orig/fs/ext4/mballoc.c =EF=BF=BD =EF=BF=BD2011-04-14 =
14:04:48.000000000
>>> +0800
>>> +++ linux-2.6/fs/ext4/mballoc.c 2011-04-14 14:33:28.702958245 +0800
>>> @@ -1273,6 +1273,8 @@ repeat_load_buddy:
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDreturn 0;
>>>
>>> =EF=BF=BDerr:
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD if (page)
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD page_cache_release(page);
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (e4b->bd_bitmap_page)
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BDpage_cache_release(e4b->bd_bitmap_page);
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (e4b->bd_buddy_page)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-in=
fo.html
>>>
>
>
> --
> Thanks
> Yang Ruirui
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
