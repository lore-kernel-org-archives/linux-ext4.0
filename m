From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 23:01:04 -0600
Message-ID: <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
References: <20110414102608.GA1678@x4.trippels.de> <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
Mime-Version: 1.0 (iPhone Mail 8G4)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:39682 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1DOFBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2011 01:01:09 -0400
In-Reply-To: <20110415000940.GL21395@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-14, at 6:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Apr 15, 2011 at 12:29:46AM +0100, P=C3=A1draig Brady wrote:
>> On 14/04/11 23:59, Dave Chinner wrote:
>>> On Thu, Apr 14, 2011 at 10:50:10AM -0500, Eric Sandeen wrote:
>>>> On 4/14/11 9:59 AM, P=C3=A1draig Brady wrote:
>>>>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>>>>>> Hi P=C3=A1draig,
>>>>>>>>=20
>>>>>>>> here you go:
>>>>>>>> + filefrag -v unwritten.withdata                              =
                                                                       =
               =20
>>>>>>>> Filesystem type is: ef53                                      =
                                                                       =
               =20
>>>>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4=
096)                                                                   =
               =20
>>>>>>>> ext logical physical expected length flags                    =
                                                                       =
              =20
>>>>>>>>   0       0   274432            2560 unwritten,eof            =
                                                                       =
              =20
>>>>>>>> unwritten.withdata: 1 extent found
>>>>>>>>=20
>>>>>>>> Please notice that this also happens with ext4 on the same ker=
nel.=20
>>>>>>>> Btrfs is fine.
>>>>>>>=20
>>>>>> `filefrag -vs` fixes the issue on both xfs and ext4.
>>>>>=20
>>>>> So in summary, currently on (2.6.39-rc3), the following
>>>>> will (usually?) report a single unwritten extent,
>>>>> on both ext4 and xfs
>>>>>=20
>>>>>  fallocate -l 10MiB -n k
>>>>>  dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock=
 of=3Dk
>>>>>  filefrag -v k # grep for an extent without unwritten || fail
>>>>=20
>>>> right, that's what I see too in testing.
>>>>=20
>>>> But would the coreutils install have done a preallocation of the d=
estination file?
>>>>=20
>>>> Otherwise this looks like a different bug...
>>>>=20
>>>>> This particular issue has been discussed so far at:
>>>>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
>>>>> Note there it was stated there that ext4 had this
>>>>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
>>>>=20
>>>> ext4 got a fix, but not xfs, I guess.  My poor brain can't remembe=
r, I think I started looking into it, but it's clearly still broken.
>>>>=20
>>>> Still, I don't know for sure what happened to Markus - did somethi=
ng preallocate, in his case?
>>>=20
>>> Unwritten extent mapping behaves in an unexpected way due to
>>> buffered writeback not occurring immediately. Extent conversion
>>> doesn't occur until the data is on disk, and for buffered IO you
>>> need an fdatasync to ensure that has occurred.
>>>=20
>>> That is:=20
>>>=20
>>> $ xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c "bmap -vp" /mnt=
/test/foo
>>> wrote 5120/5120 bytes at offset 0
>>> 5 KiB, 2 ops; 0.0000 sec (62.600 MiB/sec and 25641.0256 ops/sec)
>>> /mnt/test/foo:
>>> EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FL=
AGS
>>>   0: [0..20479]:      268984..289463    0 (268984..289463) 20480 10=
000
>>>=20
>>> Data has not been written yet, so it is still unwritten. The same
>>> test with a fsync shows:
>>>=20
>>> $ sudo xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c fsync -c "=
bmap -vp" /mnt/test/foo
>>> wrote 5120/5120 bytes at offset 0
>>> 5 KiB, 2 ops; 0.0000 sec (87.193 MiB/sec and 35714.2857 ops/sec)
>>> /mnt/test/foo:
>>> EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FL=
AGS
>>>   0: [0..15]:         268984..268999    0 (268984..268999)    16 00=
000
>>>   1: [16..20479]:     269000..289463    0 (269000..289463) 20464 10=
000
>>>=20
>>> Everything is fine.
>>>=20
>>> So this seems like an application error to me. If you are going to
>>> use fiemap to determine what ranges to copy, then you have to
>>> fdatasync the source file first to guarantee that preallocated
>>> extents have been converted to written state before mapping the
>>> file....
>>=20
>> Well IMHO there should be a difference between
>> knowing where you are going to write, and actually writing to disk.
>> I.E. one shouldn't need to write the whole way to the device
>> before returning a valid fiemap.  If a particular file system
>> implementation needs to sync to return a valid fiemap,
>> then it should be implicit.
>=20
> No, this was explicitly laid out in the fiemap interface discussions
> - it's up to the applicaiton to decide if it needs to do a sync
> first. That's what the FIEMAP_FLAG_SYNC control flag is for.
> This forces the fiemap call to do a fsync _before_ getting the
> mapping. If you want to know the exact layout of the file is, then
> you must use this flag.
>=20
> Even so, it is recognised that this is racy - any use of the block
> map has a time-of-read-to-time-of-use race condition that means you
> have to _verify_ the copy after it completes. FYI, that's what
> xfs_fsr does when copying based on extent maps - if the inode has
> changed in _any way_ during the copy, it aborts the copy of that
> file.
>=20
> i.e. using fiemap for copying is at best a *hint* about the regions
> that need copying, and it is in no way a guarantee that you'll get
> all the information you need to make accurate copy even if you do
> use the synchronous variant.

I would tend to agree with P=C3=A1draig. If there is data in the mappin=
g (regardless of whether it is on disk or not), the FIEMAP should retur=
n this to the caller. The SYNC flag is only intended to flush the data =
to disk for tools that are doing direct-to-disk operations on the data.=
=20

Otherwise the UNMAPPED flag is useless, since even with "check, copy, c=
heck" there is no guarantee that the inode is changed _during_ the copy=
 operation. It could have been written into the cache _before_ the FIEM=
AP and remain unchanged and in your case there would be no way to know =
any data was ever written to the file without SYNC on ever single file =
before FIEMAP.

Cheers, Andreas--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
