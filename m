From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xfstests: failure to umount ext4
Date: Wed, 23 Mar 2011 17:33:19 +0200
Message-ID: <AANLkTi=JvL6LoL=VOrHoiQKheqzDrVwOQtWAkumzaBk5@mail.gmail.com>
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
	<4D8A0A70.9030201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: XFS <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51090 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab1CWPdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 11:33:20 -0400
Received: by qyg14 with SMTP id 14so7177758qyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 08:33:20 -0700 (PDT)
In-Reply-To: <4D8A0A70.9030201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 4:57 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 3/23/11 9:36 AM, Amir Goldstein wrote:
>> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
>>>
>>> I've been running xfstests on ext4 and I always get annoying failur=
es to umount:
>>>
>>> 213 8s ... 31s
>>> umount: /mnt/test/ext4: device is busy.
>>> =A0 =A0 =A0 =A0(In some cases useful info about processes that use
>>> =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>>>
>>> post 198 mostly fails to umount as well.
>>> and post 124 always fails to umount.
>>>
>>> My server is Ubuntu 10.10, running kernel 2.6.38.
>>>
>>> Is there any known issue about this? because I could find it on goo=
gle
>>> or on the XFS list.
>>>
>>
>> Hi All,
>>
>> Has anyone seen these failures when running xfstests on ext4?
>> My test and scratch partitions are dedicated for xfstests.
>
> I've not seen it, can you investigate with lsof etc?

OK. I have not given complete information.
It does not fail indefinably. I can umount the fs immediately after the=
 failure.
Only the test fails because fsck sees a mounted fs.
There must be a bit of a delay in the umount that causes the problem.

>
> They both work for me on a quick test, anyway, on a .38
> kernel.

Problem existed for me in .37 as well. I don't think it is kernel (or
fs) related.
I think it is a system problem, but I fall short of ideas how to fix it=
=2E

>
> What are you using for your partitions under test?
>

Currently, I have /dev/sda5,6,7,8.
I used to work with LVM, but lstat64 didn't like the /dev/mapper links,
so I switched to raw partitions.
Although I was puzzled that xfstests could not work over LVM partitions
It could when I changed lstat64 to stat64, but then I changed it back
thinking it was causing my problems.

> -Eric
>
>> Thanks,
>> Amir.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
