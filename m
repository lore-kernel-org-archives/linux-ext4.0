From: Zhao Cai <zhaocai@me.com>
Subject: Re: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 12:05:38 -0400
Message-ID: <D949F3DA-E240-4BCF-A213-E4745FFE5D99@me.com>
References: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
 <4DB584B0.3000101@redhat.com>
 <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 mailing list <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from asmtpout019.mac.com ([17.148.16.94]:51970 "EHLO
	asmtpout019.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1DYQFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 12:05:54 -0400
Received: from cai-zhao-2.umelst.maine.edu ([130.111.219.42])
 by asmtp019.mac.com
 (Oracle Communications Messaging Exchange Server 7u4-20.01 64bit (built Nov 21
 2010)) with ESMTPSA id <0LK700006U1E6B80@asmtp019.mac.com> for
 linux-ext4@vger.kernel.org; Mon, 25 Apr 2011 09:05:40 -0700 (PDT)
In-reply-to: <BANLkTimPBdtoNgu2OgUmqj=WHK6JUooFcA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, my mistake. It happens only when ext4 is the root file system.=20

-Zhao


On Apr 25, 2011, at 11:02 AM, Amir Goldstein wrote:

> On Monday, April 25, 2011, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 4/24/11 11:12 PM, Zhao Cai wrote:
>>> I would appreciate if anyone can give me an answer. Is it designed =
to
>>> be like this?
>>>=20
>>> Detailed situation: The system is ubuntu 11.04 installed in VMware.=
 I
>>> notice that ext4_put_super() is called when I unmount a non-root ex=
t4
>>> partition. But it is not when I restart or shutdown the system.
>>=20
>> Even for a non-root filesystem?
>>=20
>> I don't know if ubuntu does anything special, but I would expect tha=
t during a system shutdown, non-root filesystems would be unmounted, an=
d you'd get put_super called.  Unless the fs is busy and it can't be un=
mounted for some reason...
>=20
> This strangely reminds me of my report that xfstests sometimes fails
> to umount on Ubuntu 10.10.
> But I could be just trying to hold on to the hope of somebody else
> solving my problems...
>=20
>>=20
>> -Eric
>>=20
>>> Thanks=E3=80=82
>>>=20
>>> -- All the best,
>>>=20
>>> Zhao Cai
>>>=20
>>>=20
>>> -- To unsubscribe from this list: send the line "unsubscribe
>>> linux-ext4" in the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
