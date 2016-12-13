From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Filesystem size problem.
Date: Tue, 13 Dec 2016 13:48:21 -0700
Message-ID: <33CFACFE-D772-4961-A94A-42479ECCB173@dilger.ca>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com> <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com> <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca> <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com> <7393F8E6-AD83-430E-AE3E-A800DAB91FD3@dilger.ca> <CAEUYfyN373=Eacbu=jL-YPfcmLC0VjvMc++__eVUAJb++gq6Ug@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6E0C7AB8-4F01-4DE4-87FF-E6EF4A8530AB"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34143 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933108AbcLMUzy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2016 15:55:54 -0500
Received: by mail-io0-f176.google.com with SMTP id p42so5338367ioo.1
        for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2016 12:55:46 -0800 (PST)
In-Reply-To: <CAEUYfyN373=Eacbu=jL-YPfcmLC0VjvMc++__eVUAJb++gq6Ug@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6E0C7AB8-4F01-4DE4-87FF-E6EF4A8530AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 12, 2016, at 7:48 PM, Simon Matthews <simon.d.matthews@gmail.com> =
wrote:
>=20
> On Mon, Dec 12, 2016 at 2:36 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>> On Dec 9, 2016, at 9:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>=20
>>> On 12/9/16 2:29 PM, Andreas Dilger wrote:
>>>> On Dec 8, 2016, at 10:40 PM, Simon Matthews =
<simon.d.matthews@gmail.com> wrote:
>>>>>=20
>>>>> I have an ext3 filesystem that will not mount under newer versions =
of
>>>>> the kernel and I hope someone here can help.
>>>>>=20
>>>>> Obviously, one solution is "backup and re-create from scratch". I =
have
>>>>> the backups, but I hope that there may be a quicker method to fix =
the
>>>>> issues.
>>>>>=20
>>>>> The root issue is that the filesystem is very slightly smaller =
than
>>>>> the allocated space.
>>>=20
>>> So the device is now smaller than the filesystem thinks, right?
>>>=20
>>>>> The filesystem exists on a MDRAID device and I think that when I
>>>>> converted the MDRAID to a newer metadata version, it truncated the
>>>>> available size, slightly. However, how I got here isn't really
>>>>> important, fixing it now is.
>>>>=20
>>>> Running "e2fsck -fy" should fix this.  I'd recommend to use the =
latest
>>>> version of e2fsck.
>>>=20
>>> Reaslly?  e2fsck can change total blocks in the superblock to =
accomodate
>>> a shrunken device?  That's a new one for me...
>>=20
>> Strange, I thought this case was handled properly by e2fsck.
>>=20
>> You could probably fix this with:
>>=20
>> # debugfs -w -R "ssv blocks_count 693359326" /dev/md5
>=20
>=20
> "probably"?
>=20
> How safe or dangerous is this? Does the filesystem have to be =
unmounted first?

The filesystem *definitely* needs to be unmounted first.

I wouldn't classify this change as being super dangerous, because it is
only removing a few blocks from the end of the filesystem, and e2fsck
should handle the case where inodes reference blocks beyond EOFS as any
other corrupt blocks.  I don't think that is likely to happen in this
case, unless your filesystem is extremely full, since extN filesystems
front-end bias allocations to the faster part of the storage device.

That said, I haven't tested this process[*], and if you are concerned =
that
it may eat your data (that is always possible) you should make a backup.
You should probably make a backup even if you aren't going to do this, =
as
that is always a good idea.  As with any free advice you on the internet
YMMV, and the final decision is up to you.

The other option is to make a new filesystem on a second set of storage
and then copy the old files over.  That also has benefits that the old
filesystem acts as your backup, you get any new features enabled in ext4
when the filesystem is newly formatted, and the files will likely be =
laid
laid out on disk contiguously during the copy, so it will defragment the
filesystem (not that ext4 needs this very much).

PS: I added "-w" to the debugfs command above, or it would have failed

Cheers, Andreas

[*] I did just try this on a test filesystem and it worked OK for me:

[root@mookie ~]# dumpe2fs -h /dev/dm-53 | grep "Block count"
dumpe2fs 1.42.13.wc5 (15-Apr-2016)
Block count:              2621440
[root@mookie ~]# debugfs -w -R "ssv blocks_count 2621400" /dev/dm-53
debugfs 1.42.13.wc5 (15-Apr-2016)
[root@mookie ~]# e2fsck -fn /dev/dm-53
e2fsck 1.42.13.wc5 (15-Apr-2016)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #79 (26047, counted=3D26007).
Fix? no

Free blocks count wrong (2226761, counted=3D2226721).
Fix? no

Padding at end of block bitmap is not set. Fix? no


myth_2-MDT0000: ********** WARNING: Filesystem still has errors =
**********

myth_2-MDT0000: 1010990/2621440 files (0.1% non-contiguous), =
394639/2621400 blocks
[root@mookie ~]# e2fsck -fp /dev/dm-53
myth_2-MDT0000: Padding at end of block bitmap is not set. FIXED.
myth_2-MDT0000: 1010990/2621440 files (0.1% non-contiguous), =
394679/2621400 blocks






--Apple-Mail=_6E0C7AB8-4F01-4DE4-87FF-E6EF4A8530AB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWFBel3Kl2rkXzB/gAQiZDhAAszIbWGOP0AMxXqQMXif01WaDe1o/NaOK
FC9NDFFqstzvaYW6nz88Eqv6qduk8gn9PfcCKRCU6hv071t8VH1J0MfIimVLtV5h
JOOu1Q8kY1izLF+wvAdKx/H7hHl2CL8zKhixXe1WYbT3ldWxmF7PEaN3g+jwiko3
BE6W2G182l/L8uAceDeniyLcJlIZftNJtgkKcxCE/Tj/t8m2B569bIeAVOFgoIRv
L9lYswymWUluc1rLLYX3BMdVE5Fyg1Y4ftk+MwGKbl+m1mkrrYcZJbsh1quum6Vi
06cR4KtN8SS58rsXHWuQ+al1SGfqOFXN7ghQB/Y+kFzmP2pM7d3RZ3euiLkimYRB
xER9HppafaU+UiAI47LeJz6cT/bK41o/d5HUAO5jhdBXFAKc0HkPXwpEpGqYrktM
Qogaqs2iylzUXycKjuCb2ATk/JWo2/xJFV3agOL5LSCwICtq687W27wPvON4vHy/
XylfAm0Zg2NL37BfqVBhzN4hzhvwYox9EJj8XxbEAucAEDr+7v5DrZesdcmsPZq7
XwSycaLAYQzeVQmgvHb+0gzvUE+EUpoXn9suOGMA8D0kwv/QulDSh6NYgq4KjeuI
DZZ1Qp0LR1RoXcCsXkSYNXxFKulwW8g1EVkd27AesFrg9V4mcCZ9snNoyJmdpp0V
KCs0Krec0NY=
=xV1E
-----END PGP SIGNATURE-----

--Apple-Mail=_6E0C7AB8-4F01-4DE4-87FF-E6EF4A8530AB--
