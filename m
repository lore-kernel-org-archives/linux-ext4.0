From: Yang Rui Rui <ruirui.r.yang@tieto.com>
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error
 path
Date: Thu, 14 Apr 2011 15:29:38 +0800
Message-ID: <4DA6A262.6060202@tieto.com>
References: <20110414064441.GA3499@darkstar> <BANLkTinPupXGmYTq16hcgexdUP+czYRc4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58975 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab1DNHSr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 03:18:47 -0400
In-Reply-To: <BANLkTinPupXGmYTq16hcgexdUP+czYRc4A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Thanks for your comment. BTW, why linux-kernel mainling list is removed=
 from cc?
Is it ext4 list prefer or something else?

On 04/14/2011 03:01 PM, Amir Goldstein wrote:
> Hi Yang ,
>
> The patch looks correct, but in my opinion a nicer fix would be to se=
t
> e4b->bd_bitmap_page =3D page;
> or
> e4b->bd_buddy_page =3D page;
> right after assigning a new value to the temp variable 'page'.
> and keeping the cleanup code in the error path as it is.
>
> It's a matter of taste and code readability.

I agree with you for common case, but this function is not so readable =
already.
Two many if conditions and indent. I would prefer just fix this problem=
 as this patch.
Then rewrite the function as more small size functions for example the =
get page part.

>
> Amir.
>
> On Thu, Apr 14, 2011 at 9:44 AM, Yang Ruirui<ruirui.r.yang@tieto.com>=
  wrote:
>> Add missing page_cache_release in the error path of ext4_mb_load_bud=
dy
>>
>> Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>
>> ---
>> =EF=BF=BDfs/ext4/mballoc.c | =EF=BF=BD =EF=BF=BD2 ++
>> =EF=BF=BD1 file changed, 2 insertions(+)
>>
>> --- linux-2.6.orig/fs/ext4/mballoc.c =EF=BF=BD =EF=BF=BD2011-04-14 1=
4:04:48.000000000 +0800
>> +++ linux-2.6/fs/ext4/mballoc.c 2011-04-14 14:33:28.702958245 +0800
>> @@ -1273,6 +1273,8 @@ repeat_load_buddy:
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDreturn 0;
>>
>> =EF=BF=BDerr:
>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD if (page)
>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD page_cache_release(page);
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (e4b->bd_bitmap_page)
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BDpage_cache_release(e4b->bd_bitmap_page);
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (e4b->bd_buddy_page)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-inf=
o.html
>>


--=20
Thanks
Yang Ruirui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
