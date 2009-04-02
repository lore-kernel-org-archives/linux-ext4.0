From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 2 Apr 2009 16:47:06 +0400
Message-ID: <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
	 <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu>
	 <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com>
	 <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51758 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZDBMrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 08:47:08 -0400
In-Reply-To: <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/4/2 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/4/2 Alexander Beregalov <a.beregalov@gmail.com>:
>> 2009/4/2 Theodore Tso <tytso@mit.edu>:
>>> On Thu, Apr 02, 2009 at 02:53:51AM +0400, Alexander Beregalov wrote=
:
>>>> On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrot=
e:
>>>> > Hi Theodore, Jens
>>>> >
>>>> > kernel is 2.6.29-07099-g8b53ef3
>>>> >
>>>> > Mount failed:
>>>> >
>>>> > EXT4-fs: barriers enabled
>>>> > kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 se=
conds
>>>> > EXT4-fs error (device loop0): ext4_iget: block reference 2703228=
928 >=3D
>>>> > max (524288) in inode #2, offset=3D0
>>>> > EXT4-fs: get root inode failed
>>>> > EXT4-fs (device loop0): mount failed
>>>
>>> I don't get this failure in a Linux 2.6 kernel based off of 5d80f8e=
5
>>> with the )now upstream) ext4 patches merged in. =C2=A0I'm guessing =
sometime
>>> between v2.6.29-3652-g5d80f8e and 2.6.29-07099-g8b53ef3 a regressio=
n
>>> was introduced into the loop driver?
>>
>> It is sparc host again.
>> 2.6.29-06608-g15f7176 worked fine.
>> There was one commit to loop.c:
>> 53d66608 (loop: add ioctl to resize a loop device)
>> and ext4 git pull.
>>
>> I wil try to revert it and probably bisect.
>
> Revert 53d66608 does not help.
> Bisecting...

Done.
fe2c8191faa29d7a09f4962198f6dfab973ceec4 is first bad commit
commit fe2c8191faa29d7a09f4962198f6dfab973ceec4
Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Date:   Tue Mar 31 08:36:10 2009 -0400

    ext4: add checks of block references for non-extent inodes
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
