From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 15:18:29 -0500
Message-ID: <4DB5D715.3040809@redhat.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com> <4DB584B0.3000101@redhat.com> <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com> <D949F3DA-E240-4BCF-A213-E4745FFE5D99@me.com> <4DB59D03.7020707@redhat.com> <F4A9E9C5-21DE-44A9-AA83-285BF5279345@me.com> <05B9E852-8558-4A57-B386-E29EBC16595C@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@gmail.com>,
	ext4 mailing list <linux-ext4@vger.kernel.org>
To: Zhao Cai <zhaocai@me.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1DYUSd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 16:18:33 -0400
In-Reply-To: <05B9E852-8558-4A57-B386-E29EBC16595C@me.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/25/11 3:07 PM, Zhao Cai wrote:
> In that case, how to make sure all the jbd2 transactions are fininshe=
d before reboot? is it ext4_freeze and jbd2_journal_flush?

the remount readonly path should do this, I think.

ext4_remount
	ext4_mark_recovery_complete
		jbd2_journal_lock_updates
		jbd2_journal_flush

-Eric

> Thanks.
> --
> All the best,
>=20
> Zhao Cai
>=20
>=20
> On Apr 25, 2011, at 12:12 PM, Zhao Cai wrote:
>=20
>> On Apr 25, 2011, at 12:10 PM, Eric Sandeen wrote:
>>
>>> On 4/25/11 11:05 AM, Zhao Cai wrote:
>>>> Sorry, my mistake. It happens only when ext4 is the root file syst=
em.=20
>>>
>>> that makes sense, since root is never actually unmounted; it just g=
oes to readonly.
>>>
>>> -Eric
>>
>> Thanks. That means it is designed to be like this!
>>
>>>> -Zhao
>>>>
>>>>
>>>> On Apr 25, 2011, at 11:02 AM, Amir Goldstein wrote:
>>>>
>>>>> On Monday, April 25, 2011, Eric Sandeen <sandeen@redhat.com> wrot=
e:
>>>>>> On 4/24/11 11:12 PM, Zhao Cai wrote:
>>>>>>> I would appreciate if anyone can give me an answer. Is it desig=
ned to
>>>>>>> be like this?
>>>>>>>
>>>>>>> Detailed situation: The system is ubuntu 11.04 installed in VMw=
are. I
>>>>>>> notice that ext4_put_super() is called when I unmount a non-roo=
t ext4
>>>>>>> partition. But it is not when I restart or shutdown the system.
>>>>>>
>>>>>> Even for a non-root filesystem?
>>>>>>
>>>>>> I don't know if ubuntu does anything special, but I would expect=
 that during a system shutdown, non-root filesystems would be unmounted=
, and you'd get put_super called.  Unless the fs is busy and it can't b=
e unmounted for some reason...
>>>>>
>>>>> This strangely reminds me of my report that xfstests sometimes fa=
ils
>>>>> to umount on Ubuntu 10.10.
>>>>> But I could be just trying to hold on to the hope of somebody els=
e
>>>>> solving my problems...
>>>>>
>>>>>>
>>>>>> -Eric
>>>>>>
>>>>>>> Thanks=E3=80=82
>>>>>>>
>>>>>>> -- All the best,
>>>>>>>
>>>>>>> Zhao Cai
>>>>>>>
>>>>>>>
>>>>>>> -- To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-ext4" in the body of a message to majordomo@vger.kernel.o=
rg
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
ext4" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
>>>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
