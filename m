From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: question about punch hole
Date: Sat, 27 Aug 2011 17:33:50 +0800
Message-ID: <CAGBYx2a114E10ZDE4_HyuaiFiL6uUp0rSFXfeKHSUaWrw-c8Zg@mail.gmail.com>
References: <CAGBYx2abeJQBuZDV11WtrprmareZWSNkv-HGdLMvYoMB36mqZA@mail.gmail.com>
	<4E581FB3.3020504@linux.vnet.ibm.com>
	<CAGBYx2YLEV5XESia_4A7DRJ3vWW=nPLh9fNwdVfJFCmNk7XHTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47438 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1H0Jdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Aug 2011 05:33:52 -0400
Received: by pzk37 with SMTP id 37so5558777pzk.1
        for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 02:33:52 -0700 (PDT)
In-Reply-To: <CAGBYx2YLEV5XESia_4A7DRJ3vWW=nPLh9fNwdVfJFCmNk7XHTg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 27, 2011 at 5:04 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> On Sat, Aug 27, 2011 at 6:35 AM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> On 08/25/2011 07:53 PM, Yongqiang Yang wrote:
>>>
>>> Hi Allison,
>>>
>>> Currently, punch hole flushes all pages to disk and releases pages =
in
>>> page cache, and then calls ext4_ext_map_blocks.
>>>
>>> Assume that if a new page in the punching's range is mapped after
>>> releasing pages and before down_write i_data_sem,
>>> then ext4_ext_map_blocks will release map info of the page in exten=
t
>>> tree. =A0However, up layers does not know this, and they think the =
page
>>> is mapped.
>>>
>>> I can not find how punch hole handle the situation above. =A0Could =
you
>>> shed a light on it?
>>>
>>>
>> Hi Yongqiang
>>
>> This is a really good question and at the moment Im still looking in=
to it.
>> =A0:) =A0The calling sequence in punch hole was modeled after trunca=
te, which
>> also only locks i_data_sem when modifying the extent tree.
>> ext4_ext_map_blocks when called with the punch hole flag, only relea=
ses
>> blocks in the extent tree, using the same routines truncate does, bu=
t it
>> does not modify the state of the pages. Though that still does not p=
revent
>> the race condition you describe, so I am still investigating it.
>> I've found that I can catch a lot of race conditions by simply runni=
ng the
>> stress test over night, and so far I havnt had anything like this co=
me up,
>> but that certainly doesnt mean its not there. =A0I will let you know=
 what I
>> find. =A0Thx!
>
> Hi Allison,
>
> I had a look at truncate code, truncates and writes are serialized by
> inode->i_mutex in vfs layer, =A0but fallocate does not take i_mutex, =
so
> we need to take i_mutex in punching hole as well, I think. =A0Falloca=
te
> behaves differently with punching hole, so it is safe without taking
> i_mutex.
It seems that race exists between reads and punching hole as well.  If
a read comes after releasing pages and before down_write(i_data_sem),
then a page will be mapped, if the page is written later, it will
introduce an error. truncate avoids this situation by set file size
before truncating pages.

Yongqiang.

>
>
> What's your opinion?
>
> Yongqiang.
>>
>> Allison Henderson
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



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
