From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Tue, 30 Sep 2014 15:36:17 -0600
Message-ID: <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
References: <542B1C38.9010409@redhat.com> <542B1EFC.4050500@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_66FC4C23-0F49-4405-B4C5-F249272E8FD9"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52919 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaI3VgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2014 17:36:20 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so4356499pab.22
        for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 14:36:19 -0700 (PDT)
In-Reply-To: <542B1EFC.4050500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_66FC4C23-0F49-4405-B4C5-F249272E8FD9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 30, 2014, at 3:22 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/30/14 4:10 PM, Eric Sandeen wrote:
>> Hey all -
>>=20
>> So the following testcase will overrun the 1-credit journal =
reservation
>> made during a delalloc write in ext4_da_write_begin(), because we
>> may cross the 2G threshold, and need to modify both the inode and the
>> superblock in the same transaction.
>>=20
>> I see a few was to fix this:
>>=20
>> 1) Always set LARGE_FILE on mount if not set.  This will break
>>   RW compatiblity with very old kernels.  Do we care?
>=20
>  1.5) Don't update the feature on the fly - we don't for
>       HUGE_FILE, either.
>=20
>  1.5a) Always set the large_file feature with a fresh mkfs, insteadl
>        of relying on the accident of the resize inode being > 2G!

I think that 1.5a is definitely the way to go for new mke2fs, I'm a
bit surprised that we didn't do this for "-t ext4" a long time ago
given that we've enabled lots of other features automatically.

There shouldn't be any problem to do this retroactively in e2fsck
and potentially at mount time for filesystems that already have some
features enabled that are post-large_file (e.g. extents, flex_bg, etc.)
This definitely would not impose any compatibility issues, because any
kernel that supports those features already understands large_file.

I'm pretty sure that e2fsck doesn't turn off large_file automatically
anymore if it can't find any files over 2GB, but it is worthwhile to
verify this.

>> 2) Bump the reservation to 2 under the fiddly condition of
>>   large file not yet set but this write might do it
>> 3) bump the delalloc reservation to 2 just in case, always

Given how many other reservations we have for normal operations,
I don't think it is so bad to reserve an extra block if the
large_file feature isn't enabled yet.  This could be fine tuned
based on the size and offset of the write, but I'm not sure if
the extra complexity warrants it.

It doesn't make sense to reserve this block if the feature
is already set, and I don't think that there are (m)any features
that are turned on automatically by the kernel anymore so it is
overhead to reserve the block if you know it won't be needed.

I don't know if this is belt and suspenders, but it might be
something to consider for supporting older kernels and we may not
need it in newer kernels.

Cheers, Andreas

>> I'll be happy to write the patch to fix it, just wondering what
>> people think the best approach is
>>=20
>> Thoughts?
>> -Eric
>>=20
>>=20
>> #!/bin/bash
>>=20
>> # A 400m fs won't get the large_file feature, oddly
>> # enough, because the resize inode will be < 2G.
>>=20
>> truncate --size=3D400m test.img
>> mkfs.ext4 -F test.img
>> # This shouldn't have large_file set, exit if it does for some reason
>> dumpe2fs -h test.img | grep large_file && exit
>>=20
>> mkdir -p mnt
>> mount -o loop test.img mnt
>>=20
>> echo "writing 1 byte at 2147483646"=20
>> dd if=3D/dev/zero of=3Dmnt/testfile bs=3D1 seek=3D2147483646 count=3D1 =
conv=3Dnotrunc of=3Dmnt/testfile
>> sync
>>=20
>> # This will make sure i_disksize is on disk, and
>> # that the buffer will be mapped on the next write.
>> #
>> # This is critical because ext4_da_should_update_i_disksize()
>> # checks buffer_mapped():
>> #
>> #        if (!buffer_mapped(bh) || (buffer_delay(bh)) || =
buffer_unwritten(bh))
>> #                return 0;
>> #        return 1;
>>=20
>> # This tries to update i_disksize, and also requires a superblock
>> # update for the large_file feature flag, but only has 1 credit
>> # available on the delalloc write path
>>=20
>> echo "writing 1 byte at 2147483647"
>> dd if=3D/dev/zero of=3Dmnt/testfile bs=3D1 seek=3D2147483647 count=3D1 =
conv=3Dnotrunc of=3Dmnt/testfile
>>=20
>> # Should go boom, but if not, unmount
>> umount mnt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_66FC4C23-0F49-4405-B4C5-F249272E8FD9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCsiUnKl2rkXzB/gAQID2A/+KPV4BsCCoKr48koufJC9lcHq3GhNyCUL
X40Eb1MaAlq3Na5jDQlPIr6E7vlXeOguo+Q4vpi7uq6yYr/i7Ybgj/nRqY5h15JO
DST24R+FK0n4WkiCm2CXYlQ0lGGNHjecZRqbSwDeAI6ONTcGAVN4fFfSc6196S/S
x49xYjWe6zseiiRL6G2bKrerZDa6XF3tBNyociKleG8cTUE8PhGxtOKZgPyeAdH+
g4gkqVMywaVTuFa7vzP5j1iHjXc++fuGi74j+g2B6ALV6A3hOk46SEXwDtKaOpiT
w71AMuTcr9kiN/PvAXb6b9TcuMokqIS4EGa1Ra2IFzl4NsK3Ymb1jbsq8eMpgQdl
mgvBtGRR/rH4iZmzewMMUG2NoIR+Fe2f/azNQ2HE47sz21HAIg0OPr1MLoIaUaXL
5Sphb39XG9uEQ3uvHT6e3hBmvw1rlklotxrmcyHMvapT/ZauW/sT2IWtQsqwQoBd
g+7yGeZbE497J0+vJZByCigPuCIUvvJyFP8RTXbsAw7tSY5uipYHtuzpY+QMdDsS
MOtm0R/6QvF9Ve6lGuVVHS+53pHcGNo10ALTvsAJsA1lNn6uqIrKHTgXPCU9m5C0
QuMWQqpZ5jZ8uyzC+A9ejoXHGpijpwOVuPJKwrBWiGQRNNmdYQWb0bmq/QYHH1c1
OS7sbsJCoa0=
=3nj9
-----END PGP SIGNATURE-----

--Apple-Mail=_66FC4C23-0F49-4405-B4C5-F249272E8FD9--
