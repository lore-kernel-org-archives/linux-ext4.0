From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] enable ext4 allocate blocks across group boundary
Date: Thu, 15 Mar 2012 12:15:22 +0800
Message-ID: <CAGBYx2aCtiy+ALRHMBh4sbUCBChWpwUH6wdBRVeZ1ENEJue6LA@mail.gmail.com>
References: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
	<B931D1EA-1D19-4054-9427-F1212D2837A7@dilger.ca>
	<CAGBYx2b9nKmzm6kAestOJdoA2Ufwjkbk2za=0FL7smh_Bq0yPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42258 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab2COEPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 00:15:22 -0400
Received: by yenl12 with SMTP id l12so2619685yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 21:15:22 -0700 (PDT)
In-Reply-To: <CAGBYx2b9nKmzm6kAestOJdoA2Ufwjkbk2za=0FL7smh_Bq0yPA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 10:49 AM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
> On Thu, Mar 15, 2012 at 10:34 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>> On 2012-03-14, at 6:52 PM, Yongqiang Yang wrote:
>>> Here is a proposal to enable ext4 allocate blocks across group boun=
dary.
>>>
>>> Now ext4 allocates blocks within a single block group by locking a
>>> group. =A0 Flex_bg puts metadata blocks together, as a result,it
>>> enlarges contiguous blocks. =A0So we can enable ext4 allocate block=
s
>>> within a flex block group. Inode allocation takes group lock as blo=
ck
>>> allocation, =A0I am not sure if we should allocate inode within sin=
gle
>>> group as before.
>>>
>>> If we do this, then the new group boundary will be flex block group
>>> boundary. =A0I am not sure if it is worth doing.
>>
>> The maximum extent size is the same as a single block group, so ther=
e
>> is relatively little value in doing this, IMHO.
> nope. =A0The value comes from 2 aspects: 1. the preallocation can
> preallocate much more space , 2. if =A0tail blocks of a group and hea=
d
> blocks of the next group is free, then they can be treated as
> contiguous blocks.
Here I meant they can be seen in buddy allocator.

Yongqiang.
>
> =A0I had a rough look at the code, current code does not handle the s=
ituation.
>
> Yongqiang.
>>
>> Cheers, Andreas
>>
>>
>>
>>
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
