From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: question about punch hole
Date: Sat, 27 Aug 2011 18:09:51 -0700
Message-ID: <4E59955F.4030301@linux.vnet.ibm.com>
References: <CAGBYx2abeJQBuZDV11WtrprmareZWSNkv-HGdLMvYoMB36mqZA@mail.gmail.com> <4E581FB3.3020504@linux.vnet.ibm.com> <CAGBYx2YLEV5XESia_4A7DRJ3vWW=nPLh9fNwdVfJFCmNk7XHTg@mail.gmail.com> <CAGBYx2a114E10ZDE4_HyuaiFiL6uUp0rSFXfeKHSUaWrw-c8Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47821 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1H1BJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Aug 2011 21:09:54 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7S0u1mQ021380
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 20:56:01 -0400
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7S19qaC255998
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 21:09:52 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7S1FcSJ002018
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 19:15:38 -0600
In-Reply-To: <CAGBYx2a114E10ZDE4_HyuaiFiL6uUp0rSFXfeKHSUaWrw-c8Zg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/27/2011 02:33 AM, Yongqiang Yang wrote:
> On Sat, Aug 27, 2011 at 5:04 PM, Yongqiang Yang<xiaoqiangnk@gmail.com>  wrote:
>> On Sat, Aug 27, 2011 at 6:35 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com>  wrote:
>>> On 08/25/2011 07:53 PM, Yongqiang Yang wrote:
>>>>
>>>> Hi Allison,
>>>>
>>>> Currently, punch hole flushes all pages to disk and releases pages in
>>>> page cache, and then calls ext4_ext_map_blocks.
>>>>
>>>> Assume that if a new page in the punching's range is mapped after
>>>> releasing pages and before down_write i_data_sem,
>>>> then ext4_ext_map_blocks will release map info of the page in extent
>>>> tree.  However, up layers does not know this, and they think the page
>>>> is mapped.
>>>>
>>>> I can not find how punch hole handle the situation above.  Could you
>>>> shed a light on it?
>>>>
>>>>
>>> Hi Yongqiang
>>>
>>> This is a really good question and at the moment Im still looking into it.
>>>   :)  The calling sequence in punch hole was modeled after truncate, which
>>> also only locks i_data_sem when modifying the extent tree.
>>> ext4_ext_map_blocks when called with the punch hole flag, only releases
>>> blocks in the extent tree, using the same routines truncate does, but it
>>> does not modify the state of the pages. Though that still does not prevent
>>> the race condition you describe, so I am still investigating it.
>>> I've found that I can catch a lot of race conditions by simply running the
>>> stress test over night, and so far I havnt had anything like this come up,
>>> but that certainly doesnt mean its not there.  I will let you know what I
>>> find.  Thx!
>>
>> Hi Allison,
>>
>> I had a look at truncate code, truncates and writes are serialized by
>> inode->i_mutex in vfs layer,  but fallocate does not take i_mutex, so
>> we need to take i_mutex in punching hole as well, I think.  Fallocate
>> behaves differently with punching hole, so it is safe without taking
>> i_mutex.
> It seems that race exists between reads and punching hole as well.  If
> a read comes after releasing pages and before down_write(i_data_sem),
> then a page will be mapped, if the page is written later, it will
> introduce an error. truncate avoids this situation by set file size
> before truncating pages.
>
> Yongqiang.
>

Hi Yongqiang,

Alrighty, I found the code for truncate that you are referring to and 
what you are saying makes a lot of sense, so I will add a fix for it in 
the punch hole patch set I am working on at the moment.  Thx for finding 
this one for me  :)

Allison Henderson

>>
>>
>> What's your opinion?
>>
>> Yongqiang.
>>>
>>> Allison Henderson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>>
>
>
>

