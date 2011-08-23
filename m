From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: attempt to fix race in bigalloc code path
Date: Tue, 23 Aug 2011 09:12:10 +0800
Message-ID: <CAGBYx2YD5gC6--DqL9XR5ZVDynybA8jmBy9v0YXQGfCH1AeAkw@mail.gmail.com>
References: <CAGBYx2ZTzrLR2yRRnCu3pvFWvofYzJp7+WsdQt2=Y7yWGEzyTg@mail.gmail.com>
	<CAGr1F2EG32dkeo+6DU4caQdJtFBLN7kpF9a4Gj_vr+awdGZ6jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33140 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab1HWBML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 21:12:11 -0400
Received: by pzk37 with SMTP id 37so9533696pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 18:12:10 -0700 (PDT)
In-Reply-To: <CAGr1F2EG32dkeo+6DU4caQdJtFBLN7kpF9a4Gj_vr+awdGZ6jw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 23, 2011 at 1:30 AM, Aditya Kali <adityakali@google.com> wr=
ote:
> On Mon, Aug 22, 2011 at 6:54 AM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m> wrote:
>> Hi,
>>
>> I can not find the patch - attempt to fix race in bigalloc code path=
 -
>> in the mailing list.
>>
>> I don't think this patch can work. =A0set_buffers_da_mapped() is cal=
led
>> under i_data_sem, so it can not lock page. =A0If the page is not loc=
ked,
>> calling page_has_buffers() is not secure as Jan pointed out
>> previously. =A0If a page is partially mapped(block size < page size)=
,
>> setting BH_Da_Mapped without locking page is not safe too.
>>
> The BH_Da_Mapped is set only during page writeback when the page is
> locked (in write_cache_pages_da). So, the setting of BH_Da_Mapped
> should be safe, no ?
Sorry for noise and thank you for your explanation, you are right.
IMHO, we can clear BH_Delayed and set BH_Mapped instead.

Yongqiang.
>
>> BTW: =A0find_delalloc_range() does not lock page as ext4_fiemap_cb()=
=2E
>> As Jan said, it can crash system. =A0BUT we can not lock page in bot=
h
>> scenarios, because i_data_sem is hold. So delayed extent list is
>> necessary. =A0I have finished the code implementing delayed extent l=
ist,
>> which needs some further testing.
>>
>>
>> What are your opinions?
>>
> I agree that having a delayed extent list will greatly simply this
> solution in this case.
>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
