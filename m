From: Yang Rui Rui <ruirui.r.yang@tieto.com>
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error
 path
Date: Thu, 14 Apr 2011 16:28:45 +0800
Message-ID: <4DA6B03D.9090601@tieto.com>
References: <20110414064441.GA3499@darkstar>	<BANLkTinPupXGmYTq16hcgexdUP+czYRc4A@mail.gmail.com>	<4DA6A262.6060202@tieto.com> <BANLkTinCdpMoEf_Qwq48vPsfxmsFtoOG3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:59439 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1DNIRy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 04:17:54 -0400
In-Reply-To: <BANLkTinCdpMoEf_Qwq48vPsfxmsFtoOG3g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/14/2011 03:46 PM, Amir Goldstein wrote:
> On Thu, Apr 14, 2011 at 10:29 AM, Yang Rui Rui<ruirui.r.yang@tieto.com>  wrote:
>> Hi,
>>
>> Thanks for your comment. BTW, why linux-kernel mainling list is removed from
>> cc?
>> Is it ext4 list prefer or something else?
>
> ext4 list is the place to post fixes for ext4.
> LKML need not be bothered with these specific patches.
>
>>
>> On 04/14/2011 03:01 PM, Amir Goldstein wrote:
>>>
>>> Hi Yang ,
>>>
>>> The patch looks correct, but in my opinion a nicer fix would be to set
>>> e4b->bd_bitmap_page = page;
>>> or
>>> e4b->bd_buddy_page = page;
>>> right after assigning a new value to the temp variable 'page'.
>>> and keeping the cleanup code in the error path as it is.
>>>
>>> It's a matter of taste and code readability.
>>
>> I agree with you for common case, but this function is not so readable
>> already.
>> Two many if conditions and indent. I would prefer just fix this problem as
>> this patch.
>
> As I said it's a matter of taste so I'm not going to argue.
> One argument in favor of your patch is that it adds fewer lines.
>
>> Then rewrite the function as more small size functions for example the get
>> page part.
>>
>
> If you are going to audit code or rework functions in mballoc.c,
> I suggest that you first take look at my patches to remove alloc_semp.
> Those already involve some rework in mballoc.c.
> See online version at:
> https://github.com/amir73il/ext4-snapshots/tree/alloc_semp

Thanks, will take a look.

>
>>>
>>> Amir.
>>>
>>> On Thu, Apr 14, 2011 at 9:44 AM, Yang Ruirui<ruirui.r.yang@tieto.com>
>>>   wrote:
>>>>
>>>> Add missing page_cache_release in the error path of ext4_mb_load_buddy
>>>>
>>>> Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>


-- 
Thanks
Yang Ruirui
