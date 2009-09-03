From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Thu, 3 Sep 2009 16:00:49 +0800
Message-ID: <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:45216 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZICIAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 04:00:47 -0400
Received: by pxi42 with SMTP id 42so1529058pxi.20
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 01:00:50 -0700 (PDT)
In-Reply-To: <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gmail.com> =
wrote:
> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote:
>> If we allocate the donor file once for all, it will have a better ch=
ance
>> to be continuous.
>>
>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>
> Seems like an improvement, but I'm not seeing any special handling fo=
r
> sparse files. =C2=A0(Not before or after this patch.)
>
> Seems like there should be an outer loop that identifies contiguous
> data block sets in a sparse file and defrags them individually as
> opposed to trying to defrag the entire file at once.
>
> My impression is that with a large sparse file, e4defrag currently
> (with or without this patch) would fallocate a full non-sparse donor
> set of blocks the full size of the original file, then swap in just
> the truly allocated blocks?
Thanks for the reminder. The original code takes good care of sparse
files in join_extents(). Please ignore my patch.

Sorry for the noise.

>
> If so, that is not very optimum.
>
> Greg
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
