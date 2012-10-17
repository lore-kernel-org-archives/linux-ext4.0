From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: Re: [PATCH 01/10] ext4: balloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 22:22:40 +0530
Message-ID: <CANBXnMkKaLf82yUuHYAaxU=+ATDtTn_3NE2m9_sX2z+bK+oUuQ@mail.gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
	<alpine.LFD.2.00.1210171359270.30534@dhcp-1-104.brq.redhat.com>
	<CAFLxGvzKGJ0-Mau+21sSi+A5WKtbvF=+YxrKxVFta0Ecx6y_Jg@mail.gmail.com>
	<CANBXnMkoFo1HdQZkOq0HR4aLX_LObXB2=mEpiHBwK2CSK_hCKA@mail.gmail.com>
	<alpine.LFD.2.00.1210171609040.30534@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42698 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2JQQwl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 12:52:41 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1883409eaa.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 09:52:40 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1210171609040.30534@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

>> >> Hi Adil,
>> >>
>> >> let me ask you something. How useful do you think those changes are ?
>> >> Have you learned anything by creating those patches ?
>>
>> I am newbie. I just thought of starting with cleanup thing. I know
>> that from functionality point of view, I am not adding anything but
>> thought if it helps in coding guideline compliance and uniformity of
>> code.
>> Now I understand that this is not required. In future, I will avoid
>> submitting such patches.
>
> So you've learned something :). But seriously such patches are
> causing more problems than it solves. It's perfectly fine to clean
> up the code in the area you're changing anyway, but making coding
> style patches just for a sake of it is not usually useful. Moreover
> it is not useful for you as well, because you're not going to learn
> anything.

I agree with you, it makes sense.

>
> There are plenty of real problem to be solved, but it actually
> involves reading and understanding the code first.
>
> Just for example:
>
>  - get familiar with xfstests
>  - there might still be problems with unified ext4 driver where
>    we might use options not suited for respective file system
>  - there are still issues with bigalloc
>  - I suspect that there will be some problems with file system >16TB
>  - recently there has been some reports from bigzilla.kernel.org
>  - or you can just read the code, trying to understand how it works
>    and soon or later you will find something to fix :) I am sure
>    about that.
>
> Maybe someone else have better suggestions...

Thanks a lot Lukas for your suggestions. I'll definitely look into
that as I really wanted to learn and contribute. I have seen bits and
pieces in xfs but didnt get more documentation on implementation part,
shall try to work upon that. More suggestions for newbie's like me,
are welcome :)

Thanks a lot.

Rgds,
Adil

>
> Good luck!
> -Lukas
>
>>
>> >>
>> >> Just to clarify why I am asking such weird questions. It's not one of
>> >> those sneer questions, I would really like to know.
>> >>>  linux-3.7-rc1/fs/ext4/balloc.c |    8 ++++----
>> >
>> > The really sad thing is that this patch does not even apply because
>> > the path is malformed.
>>
>> I am sorry, seems I am missing something. I tried with my local repo
>> and it worked :(
>> Its not the right place to ask, so I'll look what went wrong with the patches.
>>
>> Rgds,
>> Adil
>>
>> >
>> > --
>> > Thanks,
>> > //richard
>>
