From: Zhao Cai <zhaocai@me.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 16:43:01 -0400
Message-ID: <D9710D79-4BC6-485C-865B-11C445D47C06@me.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
 <4DB584B0.3000101@redhat.com>
 <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com>
 <D949F3DA-E240-4BCF-A213-E4745FFE5D99@me.com> <4DB59D03.7020707@redhat.com>
 <F4A9E9C5-21DE-44A9-AA83-285BF5279345@me.com>
 <05B9E852-8558-4A57-B386-E29EBC16595C@me.com> <4DB5D715.3040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@gmail.com>,
	ext4 mailing list <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:38295 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1DYUng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 16:43:36 -0400
Received: from cai-zhao-2.umelst.maine.edu ([130.111.219.42])
 by asmtp028.mac.com
 (Oracle Communications Messaging Exchange Server 7u4-20.01 64bit (built Nov 21
 2010)) with ESMTPSA id <0LK800E9H6VQJT40@asmtp028.mac.com> for
 linux-ext4@vger.kernel.org; Mon, 25 Apr 2011 13:43:04 -0700 (PDT)
In-reply-to: <4DB5D715.3040809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 25, 2011, at 4:18 PM, Eric Sandeen wrote:

> On 4/25/11 3:07 PM, Zhao Cai wrote:
>> In that case, how to make sure all the jbd2 transactions are fininsh=
ed before reboot? is it ext4_freeze and jbd2_journal_flush?
>=20
> the remount readonly path should do this, I think.
>=20
> ext4_remount
> 	ext4_mark_recovery_complete
> 		jbd2_journal_lock_updates
> 		jbd2_journal_flush
>=20
> -Eric
>>=20
Thanks, Eric. I appreciate your very prompt help. That clarify my quest=
ion.

-Zhao

>>=20
>>=20
>>=20
>> On Apr 25, 2011, at 12:12 PM, Zhao Cai wrote:
>>=20
>>> On Apr 25, 2011, at 12:10 PM, Eric Sandeen wrote:
>>>=20
>>>> On 4/25/11 11:05 AM, Zhao Cai wrote:
>>>>> Sorry, my mistake. It happens only when ext4 is the root file sys=
tem.=20
>>>>=20
>>>> that makes sense, since root is never actually unmounted; it just =
goes to readonly.
>>>>=20
>>>> -Eric
>>>=20
>>> Thanks. That means it is designed to be like this!
>>>=20
>>>>> -Zhao
>>>>>=20
>>>>>=20
>>>>> On Apr 25, 2011, at 11:02 AM, Amir Goldstein wrote:
>>>>>=20
>>>>>> On Monday, April 25, 2011, Eric Sandeen <sandeen@redhat.com> wro=
te:
>>>>>>> On 4/24/11 11:12 PM, Zhao Cai wrote:
>>>>>>>> I would appreciate if anyone can give me an answer. Is it desi=
gned to
>>>>>>>> be like this?
>>>>>>>>=20
>>>>>>>> Detailed situation: The system is ubuntu 11.04 installed in VM=
ware. I
>>>>>>>> notice that ext4_put_super() is called when I unmount a non-ro=
ot ext4
>>>>>>>> partition. But it is not when I restart or shutdown the system=
=2E
>>>>>>>=20
>>>>>>> Even for a non-root filesystem?
>>>>>>>=20
>>>>>>> I don't know if ubuntu does anything special, but I would expec=
t that during a system shutdown, non-root filesystems would be unmounte=
d, and you'd get put_super called.  Unless the fs is busy and it can't =
be unmounted for some reason...
>>>>>>=20
>>>>>> This strangely reminds me of my report that xfstests sometimes f=
ails
>>>>>> to umount on Ubuntu 10.10.
>>>>>> But I could be just trying to hold on to the hope of somebody el=
se
>>>>>> solving my problems...
>>>>>>=20
>>>>>>>=20
>>>>>>> -Eric
>>>>>>>=20
>>>>>>>> Thanks=E3=80=82
>>>>>>>>=20
>>>>>>>> -- All the best,
>>>>>>>>=20
>>>>>>>> Zhao Cai
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> -- To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-ext4" in the body of a message to majordomo@vger.kernel.=
org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
>>>>>>>=20
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-ext4" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>>=20
>>>>>=20
>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
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
