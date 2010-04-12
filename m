From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: No space left on device after many files creation
Date: Mon, 12 Apr 2010 17:00:37 -0500
Message-ID: <4BC39805.7090807@redhat.com>
References: <4BC38EB9.8080501@gmail.com> <4BC39098.4030704@redhat.com> <4BC39762.9080406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: cy6erGn0m <cy6ergn0m@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab0DLWAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 18:00:42 -0400
In-Reply-To: <4BC39762.9080406@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

cy6erGn0m wrote:
> In the past I have done the same test for ext3 and it was created ~10=
M
> files in one firectory at working filesystem (/home) and it was no
> issues reached.
>=20
> On ext4 i found inodes max size is limited as you wrote:
> [root@cgmachine sandbox]# df -i /e4
> =D0=A4=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0=D1=8F =D1=81=D0=B8=D1=81=D1=
=82=D0=B5=D0=BC=D0=B0      =D0=98=D0=BD=D0=BE=D0=B4=D0=BE=D0=B2   =D0=98=
=D1=81=D0=BF=D0=BE=D0=BB   =D0=A1=D0=B2=D0=BE=D0=B1  =D0=98=D1=81=D0=BF=
 % =D1=81=D0=BC=D0=BE=D0=BD=D1=82=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=D0=
=B0 =D0=BD=D0=B0
> (file system/inodes/used/free/used%/mounted on)
> /dev/sda4               1,8M    1,8M       0  100% /e4
> [root@cgmachine sandbox]#
>=20
> Why inodes count limit is so small by default? Is it depends on
> partition size?

it does depend on partition size; the inode_ratio =3D 16384 in mke2fs.c=
onf
says 1 inode per 16k of filesystem space.

the inode size was also increased a couple years ago, and the default
inode count was reduced by half so that the total size remained the sam=
e.

-Eric

> Eric Sandeen wrote:
>> cy6erGn0m wrote:
>>  =20
>>> I have found issue with ext4 partition.
>>> I created many many empty files with the following way:
>>> [cy6ergn0m@cgmachine heap]$ seq 1 10000000 | xargs touch
>>>
>>> But this command crashes asfter a while with a error 'no space left=
 on
>>> device'. At the same time, df -h shows that I have 7Gb free on this=
 file
>>> system. So, I can't create any file in any directory at this filesy=
stem.
>>>
>>> [cy6ergn0m@cgmachine heap]$ pwd
>>> /e4/sandbox/heap
>>> [cy6ergn0m@cgmachine heap]$ ls -1 | wc -l
>>> 1261144
>>> [cy6ergn0m@cgmachine heap]$ df -h /e4
>>> =D0=A4=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0=D1=8F =D1=81=D0=B8=D1=81=
=D1=82=D0=B5=D0=BC=D0=B0      =D0=A0=D0=B0=D0=B7=D0=BC  =D0=98=D1=81=D0=
=BF  =D0=94=D0=BE=D1=81=D1=82  =D0=98=D1=81=D0=BF% =D1=81=D0=BC=D0=BE=D0=
=BD=D1=82=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=D0=B0 =D0=BD=D0=B0
>>> (filesystem/size/used/available/used%/mounted)
>>> /dev/sda4              28G  7.2G   19G  28% /e4
>>>    =20
>> try df -i
>>
>> There is a limited number of inodes that you can create, as set
>> at mkfs time.
>>
>> -Eric
>>
>>  =20
>>> [cy6ergn0m@cgmachine heap]$ touch ttt
>>> touch: =D0=BD=D0=B5=D0=B2=D0=BE=D0=B7=D0=BC=D0=BE=D0=B6=D0=BD=D0=BE=
 =D0=B2=D1=8B=D0=BF=D0=BE=D0=BB=D0=BD=D0=B8=D1=82=D1=8C touch =D0=B4=D0=
=BB=D1=8F `ttt': =D0=9D=D0=B0 =D1=83=D1=81=D1=82=D1=80=D0=BE=D0=B9=D1=81=
=D1=82=D0=B2=D0=B5 =D0=BA=D0=BE=D0=BD=D1=87=D0=B8=D0=BB=D0=BE=D1=81=D1=8C=
 =D0=BC=D0=B5=D1=81=D1=82=D0=BE
>>> (touch: failed to execute touch for 'ttt': No space left on device)
>>>
>>>
>>>    =20
>>  =20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
