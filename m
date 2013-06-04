From: =?Big5?B?p7qsZr+r?= <solarispika@gmail.com>
Subject: Re: Question on delalloc
Date: Wed, 5 Jun 2013 01:30:22 +0800
Message-ID: <CAJ1XODRNm6RyCNdQrUTKe2hOvECDVmxuzv6BUFY8eSX_MVSWSQ@mail.gmail.com>
References: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
	<51ADF914.6070209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46866 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3FDRaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jun 2013 13:30:22 -0400
Received: by mail-ob0-f181.google.com with SMTP id 16so863416obc.40
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jun 2013 10:30:22 -0700 (PDT)
In-Reply-To: <51ADF914.6070209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,
    I've found a mistake I'd made. I used to take for granted that
ext4 using ordered mode journal will have ext4_writepage do the
writing.
But with delalloc enabled, no matter what journal mode one uses, ext4
will use ext4_da_writepages do handle those delayed buffer heads'
writing.
Thanks for your advice, I know what you meant:) Though what I tried to
said is that delalloc'd data will stop kjournald from writing them
back when it would like to do so, therefore those delalloc'd data will
stay in memory more longer than those non-delalloc'd ones. As
described in http://lwn.net/Articles/322823/. Sorry for my unclear
statement.

Sung Po-Han


2013/6/4 Eric Sandeen <sandeen@redhat.com>:
> On 6/3/13 2:00 PM, =A7=BA=ACf=BF=AB wrote:
>> Hi everybody,
>>
>> I am new to ext4 and doing research on Android with ext4 as file
>> system. These days, I have a question on ext4's delayed allocation
>> against ext4_sync_file.
>> I have learned that delalloc won't guarantee file data's integrity o=
n
>> power failure, since those delayed allocated buffer heads won't be
>> handled by jbd2.
>
> I just want to address your first assertion regarding delalloc:
>
>> In order to protect data, user programs need to fsync
>> those files to be secured.
>
> This is true with or without delayed allocation.
>
> With delayed allocation, the blocks are chosen a the time of the IO.
> Without delayed allocation, the blocks are chosen at the write syscal=
l time.
>
> But in both cases, data is only in memory after the write(), and is n=
ot
> guaranteed to be on disk until an fsync or similar data integrity sys=
call.
>
> http://lwn.net/Articles/457667/
>
> -Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
