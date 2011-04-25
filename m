From: Zhao Cai <zhaocai@me.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 16:07:55 -0400
Message-ID: <05B9E852-8558-4A57-B386-E29EBC16595C@me.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
 <4DB584B0.3000101@redhat.com>
 <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com>
 <D949F3DA-E240-4BCF-A213-E4745FFE5D99@me.com> <4DB59D03.7020707@redhat.com>
 <F4A9E9C5-21DE-44A9-AA83-285BF5279345@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@gmail.com>,
	ext4 mailing list <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:52870 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1DYUIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 16:08:00 -0400
Received: from cai-zhao-2.umelst.maine.edu ([130.111.219.42])
 by asmtp026.mac.com
 (Oracle Communications Messaging Exchange Server 7u4-20.01 64bit (built Nov 21
 2010)) with ESMTPSA id <0LK800FFI599FU80@asmtp026.mac.com> for
 linux-ext4@vger.kernel.org; Mon, 25 Apr 2011 13:08:00 -0700 (PDT)
In-reply-to: <F4A9E9C5-21DE-44A9-AA83-285BF5279345@me.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In that case, how to make sure all the jbd2 transactions are fininshed =
before reboot? is it ext4_freeze and jbd2_journal_flush?

Thanks.
--
All the best,

Zhao Cai


On Apr 25, 2011, at 12:12 PM, Zhao Cai wrote:

> On Apr 25, 2011, at 12:10 PM, Eric Sandeen wrote:
>=20
>> On 4/25/11 11:05 AM, Zhao Cai wrote:
>>> Sorry, my mistake. It happens only when ext4 is the root file syste=
m.=20
>>=20
>> that makes sense, since root is never actually unmounted; it just go=
es to readonly.
>>=20
>> -Eric
>=20
> Thanks. That means it is designed to be like this!
>=20
>>> -Zhao
>>>=20
>>>=20
>>> On Apr 25, 2011, at 11:02 AM, Amir Goldstein wrote:
>>>=20
>>>> On Monday, April 25, 2011, Eric Sandeen <sandeen@redhat.com> wrote=
:
>>>>> On 4/24/11 11:12 PM, Zhao Cai wrote:
>>>>>> I would appreciate if anyone can give me an answer. Is it design=
ed to
>>>>>> be like this?
>>>>>>=20
>>>>>> Detailed situation: The system is ubuntu 11.04 installed in VMwa=
re. I
>>>>>> notice that ext4_put_super() is called when I unmount a non-root=
 ext4
>>>>>> partition. But it is not when I restart or shutdown the system.
>>>>>=20
>>>>> Even for a non-root filesystem?
>>>>>=20
>>>>> I don't know if ubuntu does anything special, but I would expect =
that during a system shutdown, non-root filesystems would be unmounted,=
 and you'd get put_super called.  Unless the fs is busy and it can't be=
 unmounted for some reason...
>>>>=20
>>>> This strangely reminds me of my report that xfstests sometimes fai=
ls
>>>> to umount on Ubuntu 10.10.
>>>> But I could be just trying to hold on to the hope of somebody else
>>>> solving my problems...
>>>>=20
>>>>>=20
>>>>> -Eric
>>>>>=20
>>>>>> Thanks=E3=80=82
>>>>>>=20
>>>>>> -- All the best,
>>>>>>=20
>>>>>> Zhao Cai
>>>>>>=20
>>>>>>=20
>>>>>> -- To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-ext4" in the body of a message to majordomo@vger.kernel.or=
g
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
>>>>>=20
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>>>>=20
>>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
