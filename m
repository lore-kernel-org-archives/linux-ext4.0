From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] enable ext4 allocate blocks across group boundary
Date: Thu, 15 Mar 2012 10:49:19 +0800
Message-ID: <CAGBYx2b9nKmzm6kAestOJdoA2Ufwjkbk2za=0FL7smh_Bq0yPA@mail.gmail.com>
References: <CAGBYx2aETBVb2hMyEBC91meRwr_Z+cnMNwF+ZBU4nk1PdedygA@mail.gmail.com>
	<B931D1EA-1D19-4054-9427-F1212D2837A7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2COCtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 22:49:20 -0400
Received: by yhmm54 with SMTP id m54so2624508yhm.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2012 19:49:19 -0700 (PDT)
In-Reply-To: <B931D1EA-1D19-4054-9427-F1212D2837A7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 10:34 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2012-03-14, at 6:52 PM, Yongqiang Yang wrote:
>> Here is a proposal to enable ext4 allocate blocks across group bound=
ary.
>>
>> Now ext4 allocates blocks within a single block group by locking a
>> group. =A0 Flex_bg puts metadata blocks together, as a result,it
>> enlarges contiguous blocks. =A0So we can enable ext4 allocate blocks
>> within a flex block group. Inode allocation takes group lock as bloc=
k
>> allocation, =A0I am not sure if we should allocate inode within sing=
le
>> group as before.
>>
>> If we do this, then the new group boundary will be flex block group
>> boundary. =A0I am not sure if it is worth doing.
>
> The maximum extent size is the same as a single block group, so there
> is relatively little value in doing this, IMHO.
nope.  The value comes from 2 aspects: 1. the preallocation can
preallocate much more space , 2. if  tail blocks of a group and head
blocks of the next group is free, then they can be treated as
contiguous blocks.

  I had a rough look at the code, current code does not handle the situ=
ation.

Yongqiang.
>
> Cheers, Andreas
>
>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
