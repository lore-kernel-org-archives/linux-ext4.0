From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 00:29:46 +0100
Message-ID: <4DA7836A.5040604@draigBrady.com>
References: <20110414102608.GA1678@x4.trippels.de> <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <20110414225904.GK21395@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
	coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:2445 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752090Ab1DNXb3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 19:31:29 -0400
In-Reply-To: <20110414225904.GK21395@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 14/04/11 23:59, Dave Chinner wrote:
> On Thu, Apr 14, 2011 at 10:50:10AM -0500, Eric Sandeen wrote:
>> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
>>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>>>> Hi P=E1draig,
>>>>>>
>>>>>> here you go:
>>>>>> + filefrag -v unwritten.withdata                                =
                                                                       =
             =20
>>>>>> Filesystem type is: ef53                                        =
                                                                       =
             =20
>>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 409=
6)                                                                     =
             =20
>>>>>>  ext logical physical expected length flags                     =
                                                                       =
             =20
>>>>>>    0       0   274432            2560 unwritten,eof             =
                                                                       =
             =20
>>>>>> unwritten.withdata: 1 extent found
>>>>>>
>>>>>> Please notice that this also happens with ext4 on the same kerne=
l.=20
>>>>>> Btrfs is fine.
>>>>>
>>>> `filefrag -vs` fixes the issue on both xfs and ext4.
>>>
>>> So in summary, currently on (2.6.39-rc3), the following
>>> will (usually?) report a single unwritten extent,
>>> on both ext4 and xfs
>>>
>>>   fallocate -l 10MiB -n k
>>>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock =
of=3Dk
>>>   filefrag -v k # grep for an extent without unwritten || fail
>>
>> right, that's what I see too in testing.
>>
>> But would the coreutils install have done a preallocation of the des=
tination file?
>>
>> Otherwise this looks like a different bug...
>>
>>> This particular issue has been discussed so far at:
>>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
>>> Note there it was stated there that ext4 had this
>>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
>>
>> ext4 got a fix, but not xfs, I guess.  My poor brain can't remember,=
 I think I started looking into it, but it's clearly still broken.
>>
>> Still, I don't know for sure what happened to Markus - did something=
 preallocate, in his case?
>=20
> Unwritten extent mapping behaves in an unexpected way due to
> buffered writeback not occurring immediately. Extent conversion
> doesn't occur until the data is on disk, and for buffered IO you
> need an fdatasync to ensure that has occurred.
>=20
> That is:=20
>=20
> $ xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c "bmap -vp" /mnt/t=
est/foo
> wrote 5120/5120 bytes at offset 0
> 5 KiB, 2 ops; 0.0000 sec (62.600 MiB/sec and 25641.0256 ops/sec)
> /mnt/test/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLA=
GS
>    0: [0..20479]:      268984..289463    0 (268984..289463) 20480 100=
00
>=20
> Data has not been written yet, so it is still unwritten. The same
> test with a fsync shows:
>=20
> $ sudo xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c fsync -c "bm=
ap -vp" /mnt/test/foo
> wrote 5120/5120 bytes at offset 0
> 5 KiB, 2 ops; 0.0000 sec (87.193 MiB/sec and 35714.2857 ops/sec)
> /mnt/test/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLA=
GS
>    0: [0..15]:         268984..268999    0 (268984..268999)    16 000=
00
>    1: [16..20479]:     269000..289463    0 (269000..289463) 20464 100=
00
>=20
> Everything is fine.
>=20
> So this seems like an application error to me. If you are going to
> use fiemap to determine what ranges to copy, then you have to
> fdatasync the source file first to guarantee that preallocated
> extents have been converted to written state before mapping the
> file....

Well IMHO there should be a difference between
knowing where you are going to write, and actually writing to disk.
I.E. one shouldn't need to write the whole way to the device
before returning a valid fiemap.  If a particular file system
implementation needs to sync to return a valid fiemap,
then it should be implicit.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
