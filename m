From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 18:02:16 +0300
Message-ID: <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
	<4DB584B0.3000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zhao Cai <zhaocai@me.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40987 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab1DYPCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 11:02:17 -0400
Received: by eyx24 with SMTP id 24so718185eyx.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 08:02:16 -0700 (PDT)
In-Reply-To: <4DB584B0.3000101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, April 25, 2011, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/24/11 11:12 PM, Zhao Cai wrote:
>> I would appreciate if anyone can give me an answer. Is it designed t=
o
>> be like this?
>>
>> Detailed situation: The system is ubuntu 11.04 installed in VMware. =
I
>> notice that ext4_put_super() is called when I unmount a non-root ext=
4
>> partition. But it is not when I restart or shutdown the system.
>
> Even for a non-root filesystem?
>
> I don't know if ubuntu does anything special, but I would expect that=
 during a system shutdown, non-root filesystems would be unmounted, and=
 you'd get put_super called. =C2=A0Unless the fs is busy and it can't b=
e unmounted for some reason...

This strangely reminds me of my report that xfstests sometimes fails
to umount on Ubuntu 10.10.
But I could be just trying to hold on to the hope of somebody else
solving my problems...

>
> -Eric
>
>> Thanks=E3=80=82
>>
>> -- All the best,
>>
>> Zhao Cai
>>
>>
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-ext4" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
