From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Date: Tue, 27 Nov 2012 14:55:12 -0600
Message-ID: <50B528B0.9080208@sgi.com>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com> <alpine.LFD.2.00.1211261442490.18234@localhost> <20121126145559.GK31891@thunk.org> <CAPxxNQmgOmEzkmzL7Tei4KAxaP49yx1fmhNgxvwaFNiYVosGtA@mail.gmail.com> <20121127031438.GK6434@dastard> <50B4F38E.8060806@redhat.com> <20121127203537.GM6434@dastard> <50B52475.1020603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	Ryan Wang <openspace.wang@gmail.com>,
	<linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	<xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:32817 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2K0Uyq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 15:54:46 -0500
In-Reply-To: <50B52475.1020603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27/2012 02:37 PM, Eric Sandeen wrote:
> On 11/27/12 2:35 PM, Dave Chinner wrote:
>> On Tue, Nov 27, 2012 at 11:08:30AM -0600, Eric Sandeen wrote:
>>> On 11/26/12 9:14 PM, Dave Chinner wrote:
>>>> On Tue, Nov 27, 2012 at 09:20:47AM +0800, Ryan Wang wrote:
>>>>> 2012/11/26 Theodore Ts'o <tytso@mit.edu>:
>>>>>> On Mon, Nov 26, 2012 at 02:43:40PM +0100, Luk=C3=A1=C5=A1 Czerne=
r wrote:
>>>>>>>> The I checked the script common.rc, and found that it uses
>>>>>>>> df to determine the filesystem type and it uses the realpath
>>>>>>>> "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
>>>>>>>> shows "devtmpfs" instead of "ext4" for /dev/dm-0.
>>>>>>>>
>>>>>>>> I run "mount" and found that devtmpfs is mount on /dev/ on ope=
nsuse
>>>>>>>> ***by default***. Even though  I run "mount -t btrfs /dev/dm-0=
 /somedir",
>>>>>>>> df still showed devtmpfs.
>>>>>>>>
>>>>>>>> Any ideas to kick off the xfstests?
>>>>>>
>>>>>> At least with the df which ships with Debian Testing, df will di=
splay
>>>>>> the file system in use if it matches the device name which is
>>>>>> /etc/mtab.  It looks the issue is that mount is canonicalizing t=
he
>>>>>> device name to be the human friendly version:
>>>>>>
>>>>>> # ls -l /dev/mapper/closure-bigscratch
>>>>>> 0 lrwxrwxrwx 1 root root 7 Nov 16 15:15 /dev/mapper/closure-bigs=
cratch -> ../dm-7
>>>>>> <tytso.root@closure> {/home/tytso/bin}, level 2
>>>>>> # mount /dev/dm-7 /u2
>>>>>> # df /u2
>>>>>> Filesystem                     1K-blocks   Used Available Use% M=
ounted on
>>>>>> /dev/mapper/closure-bigscratch  52403200 224772  52178428   1% /=
u2
>>>>>> # grep /u2 /etc/mtab
>>>>>> /dev/mapper/closure-bigscratch /u2 xfs rw,relatime,attr2,inode64=
,noquota 0 0
>>>>>>
>>>>>> So the simplest solution is to just use /dev/mapper/mpatha inste=
ad of
>>>>>> insisting on using /dev/dm-0.  That's what I do....
>>>>>
>>>>> In xfstests/common.rc, it will use realpath to obtain /dev/dm-0, =
even if you
>>>>> specified /dev/mapper/mpatha.
>>>>> My problem is in SuSE, the devtmpfs is mounted on /dev by default=
, seems
>>>>> used by udev. And df reports devtmpfs on /dev/dm-0, instead of ex=
t4.
>>>>
>>>> What version of xfstests are you using? Do you have a
>>>> "README.device-mapper" file in the base directory? If not, upgrade
>>>> to the latest version and retry.
>>>>
>>>> $ gl -n 1 -p 0a81886
>>>> commit 0a818862bb74932e15971ec8bedb55765ec3a3f6
>>>> Author: Christoph Hellwig <hch@lst.de>
>>>> Date:   Wed May 4 16:28:32 2011 +0200
>>>>
>>>>      xfstests: support post-udev device mapper nodes
>>>>
>>>>      Because of udevs complaining device mapper now creates /dev/d=
m-N as the real
>>>>      device nodes, and just symlinks the /dev/mapper/ names to it.=
  This would be
>>>>      easy if everything used the /dev/mapper clear names, but most=
 system utilities
>>>>      translate them back to the /dev/mapper/ names and thus confus=
e various test
>>>>      cases.  Add support to _is_block_dev to read symlinks, and ad=
d documentation
>>>>      on how to run xfstests on device mapper volumes.
>>>>
>>>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>>      Reviewed-by: Alex Elder <aelder@sgi.com>
>>>>
>>>> Cheers,
>>>>
>>>> Dave.
>>>>
>>>
>>> Recent "realpath" changes also went in:
>>>
>>> b03c662399956609934ff063e9064e15dc7459ac xfstests: fix to build src=
/realpath and the correct the existence of target devices
>>> d5ea873fcbf00b841f0511a26fb341364a5c6425 xfstests: resolve symlinke=
d devices to real paths
>>>
>>> so either of those could have broken and/or fixed it for you :)
>>
>> Yup, those are almost certainly the patches that broke device mapper
>> support. There' aren't changes to common.rc, so I didn't notice them=
=2E
>> They basically override the fix that Christoph made to support
>> /dev/mapper links properly.
>>
>> I'd suggest a revert is in order, the two patches above were part
>> of Rich's hovering of old, unreviewed patches. This problem was
>> already fixed in a different way by Christoph, so adding these
>> patches was wrong.
>
> Fine with me ...
>
> Ryan, can you test w/o those, and if it works -
>
> Rich, can you revert those please?

Sure, I will wait to hear from Ryan first.

>
> -Eric
>
>> Cheers,
>>
>> Dave.
>>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
