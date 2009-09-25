From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 25 Sep 2009 15:08:01 -0700
Message-ID: <5df78e1d0909251508id9c8652tdf09afdd5376ace0@mail.gmail.com>
References: <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
	 <20090902084134.GO4197@webber.adilger.int>
	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
	 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
	 <20090925073546.GJ10562@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:55548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIYWID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 18:08:03 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n8PM84JM010415
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 23:08:05 +0100
Received: from pxi5 (pxi5.prod.google.com [10.243.27.5])
	by zps77.corp.google.com with ESMTP id n8PM7Q5M005138
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 15:08:02 -0700
Received: by pxi5 with SMTP id 5so3625986pxi.12
        for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 15:08:01 -0700 (PDT)
In-Reply-To: <20090925073546.GJ10562@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot for the notification! I will change it in my patch.

Jiaying

On Fri, Sep 25, 2009 at 12:35 AM, Andreas Dilger <adilger@sun.com> wrot=
e:
> On Sep 23, 2009 =A022:27 -0700, Jiaying Zhang wrote:
>> Sorry for taking so long to finish this. Here is the new patch based=
 on
>> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
>> flag when we allocate beyond the maximum allocated block. I also
>> made the EOFBLOCKS flag user visible and added the handling
>> in ext4_ioctl as Andrea suggested.
>>
>> Index: linux-2.6.30.5/include/linux/fs.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +#define FS_EOFBLOCKS_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00200000 /* =
Blocks allocated beyond EOF */
>
> Can you please use 0x00400000 here. =A0I've already asked Ted to rese=
rve
> the 0x0020000 inode flag for use by large extended attributes.
>
>> =A0#define FS_RESERVED_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x80000000 /*=
 reserved for ext2 lib */
>>
>> -#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0003DFFF /* User vi=
sible flags */
>> +#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0023DFFF /* User vi=
sible flags */
>
> This would need to be changed to 0x0043DFFF to match.
>
> Sorry, I haven't looked at the rest of the patch yet, just thought I'=
d
> mention this early on.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
