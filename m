From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 10:56:16 -0500
Message-ID: <4DA71920.9@sandeen.net>
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <4DA7182B.8050409@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43317 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734Ab1DNP4S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 11:56:18 -0400
In-Reply-To: <4DA7182B.8050409@draigBrady.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/14/11 10:52 AM, P=E1draig Brady wrote:
> On 14/04/11 16:50, Eric Sandeen wrote:
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
> Well that preallocate test is failing for him
> when the source file is either on ext4 or xfs.
> He noticed the issue initially on XFS when copying
> none preallocated files, so XFS probably just has
> the general issue of needing a sync before fiemap,
> where as EXT4 just has this preallocate one
> (though I've not seen it myself).
>=20
> cheers,
> P=E1draig.
>=20

well, if I simply take the preallocation step out of the testcase, it w=
orks fine on xfs without a sync.

So I still don't know what Markus hit...

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
