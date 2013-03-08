From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 08 Mar 2013 10:18:14 -0700
Message-ID: <513A1D56.1010402@wwwdotorg.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost> <5138EEBD.5000705@wwwdotorg.org> <alpine.LFD.2.00.1303080818510.24359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:55733 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab3CHRSR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 12:18:17 -0500
In-Reply-To: <alpine.LFD.2.00.1303080818510.24359@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2013 12:23 AM, Luk=E1=9A Czerner wrote:
> On Thu, 7 Mar 2013, Stephen Warren wrote:
>=20
>> Date: Thu, 07 Mar 2013 12:47:09 -0700
>> From: Stephen Warren <swarren@wwwdotorg.org>
>> To: Luk=E1=9A Czerner <lczerner@redhat.com>
>> Cc: Theodore Ts'o <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
>>     linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
>> Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
>>
>> On 03/06/2013 12:13 AM, Luk=E1=9A Czerner wrote:
>>> On Tue, 5 Mar 2013, Stephen Warren wrote:
>>>
>>>> Date: Tue,  5 Mar 2013 13:25:18 -0700
>>>> From: Stephen Warren <swarren@wwwdotorg.org>
>>>> To: Theodore Ts'o <tytso@mit.edu>
>>>> Cc: Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
>>>>     Stephen Warren <swarren@nvidia.com>
>>>> Subject: [PATCH] mke2fs: restore verbose message for BLKDISCARD
>>>>
>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> mke2fs on a large slow eMMC device may appear to hang while execut=
ing
>>>> ioctl(BLKDISCARD). CTRL-C and CTRL-\ don't appear to respond, or r=
espond
>>>> extremely slowly. -v doesn't give any hints what's happening. Only=
 strace
>>>> is a clue. Make -v print some clues to make it easier to track dow=
n the
>>>> apparent hang.
>>>>
>>>> This change re-uses the original messages that were implemented as=
 part
>>>> of 5827d24 "mke2fs support for BLKDISCARD" in order to easily re-u=
se the
>>>> translations of that message. Note that this patch prints the firs=
t
>>>> message before executing the IOCTL, so the user is told what's goi=
ng on
>>>> before the long wait.
>>>>
>>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>>
>>> Note that you've added the message only around the first 4k discard
>>> which is only used to test whether the device actually support the
>>> discard... which is not very useful and it can not even know whethe=
r
>>> the whole device discard will succeed/fail so it is misleading.
>>
>> Oops. I certainly should looked at the code better.
>>
>>> Moreover there actually is a message saying that we're "Discarding
>>> device blocks" and it even shows the progress. The step in which
>>> we're doing the discard (and update the progress) is given by
>>> DISCARD_STEP_MB =3D 2048MB. And all that in non verbose mode as wel=
l.
>>
>> That said, it's that very first call to io_channel_discard() that is
>> hanging then; I don't see the existing message at all. With my chang=
e, I
>> do see the new message that I added. (So, no stdio flushing issue he=
re).
>=20
> It's just one fs block discard, are you sure about that ?

Yes:

root@localhost:~# strace -e ioctl ./e2fsprogs/misc/mke2fs -v /dev/mmcbl=
k1p1
mke2fs 1.43-WIP (21-Jan-2013)
ioctl(3, BLKGETSIZE64, 0xbe940110)      =3D 0
fs_types for mke2fs.conf resolution: 'ext2'
ioctl(3, BLKSSZGET, 0xbe940360)         =3D 0
ioctl(3, BLKPBSZGET, 0xbe940364)        =3D 0
ioctl(3, BLKDISCARDZEROES, 0xbe940324)  =3D 0
ioctl(3, BLKROGET, 0xbe940324)          =3D 0
Calling BLKDISCARD from 0 to 4096 ioctl(3, BLKDISCARD

>> I will go investigate why this API is hanging. Sorry for the noise.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
