From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Filesystem size problem.
Date: Mon, 12 Dec 2016 15:36:27 -0700
Message-ID: <7393F8E6-AD83-430E-AE3E-A800DAB91FD3@dilger.ca>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com> <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com> <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca> <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B3014DF0-E818-4BF0-8523-BCCF85269B15"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Simon Matthews <simon.d.matthews@gmail.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:32895 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcLLWgc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2016 17:36:32 -0500
Received: by mail-io0-f176.google.com with SMTP id d9so193975071ioe.0
        for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2016 14:36:32 -0800 (PST)
In-Reply-To: <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B3014DF0-E818-4BF0-8523-BCCF85269B15
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Dec 9, 2016, at 9:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>=20
> On 12/9/16 2:29 PM, Andreas Dilger wrote:
>> On Dec 8, 2016, at 10:40 PM, Simon Matthews =
<simon.d.matthews@gmail.com> wrote:
>>>=20
>>> I have an ext3 filesystem that will not mount under newer versions =
of
>>> the kernel and I hope someone here can help.
>>>=20
>>> Obviously, one solution is "backup and re-create from scratch". I =
have
>>> the backups, but I hope that there may be a quicker method to fix =
the
>>> issues.
>>>=20
>>> The root issue is that the filesystem is very slightly smaller than
>>> the allocated space.
>=20
> So the device is now smaller than the filesystem thinks, right?
>=20
>> The filesystem exists on a MDRAID device and I
>>> think that when I converted the MDRAID to a newer metadata version, =
it
>>> truncated the available size, slightly. However, how I got here =
isn't
>>> really important, fixing it now is.
>>=20
>> Running "e2fsck -fy" should fix this.  I'd recommend to use the =
latest
>> version of e2fsck.
>=20
> Reaslly?  e2fsck can change total blocks in the superblock to =
accomodate a
> shrunken device?  That's a new one for me...

Strange, I thought this case was handled properly by e2fsck.

You could probably fix this with:

# debugfs -R "ssv blocks_count 693359326" /dev/md5
# e2fsck -f /dev/md5

to set the blocks count.  It is unlikely anything is in the last 18 =
blocks
of the filesystem, and if it is then it is probably already corrupted by
the RAID superblock stored there.

>=20
> I don't think so:
>=20
> $ truncate --size=3D101m testfile
> $ mkfs.ext3 testfile
> $ truncate --size=3D100m testfile
> $ e2fsck -f testfile
> ...
> The physical size of the device is 102400 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort<y>? n
> ...
> $ e2fsck -f testfile
> ...
> The physical size of the device is 102400 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort<y>? n
> $ e2fsck -f testfile
> ...
> The physical size of the device is 102400 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort<y>? n
>=20
> etc.
>=20
>=20
> The proper solution is to fix your block device, not the filesystem;
> it was the block device which was inappropriately shortened.

This may be more easily said than done...

> I don't know if just poking a smaller total blocks number into the
> superblock via debugfs would be safe or not.

It would probably be better to have e2fsck fix this problem itself,
but it is uncommon enough that there is a danger someone will also
shoot themselves in the foot for cases where this isn't working right.

Cheers, Andreas






--Apple-Mail=_B3014DF0-E818-4BF0-8523-BCCF85269B15
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWE8mbHKl2rkXzB/gAQiPQQ/+PS7pX2kJ6nTzdMNtVZo7B5WiJf0ShHRw
fZUPoIv2ZmF7JZ/31LNhgVED5W0BPtKpZ1KmZWJ77N2Glt1PDZtUfKBB50TZW3dB
ShkTHwelArXGvh6S70MuvC/JxnTtXmjTBYixZtdA/C98vUycIo/d1dcx6xxPmF7R
whOqnyiCPe3FLCyNfn9M7IvTknWgO9ZNQDAREgE3SuHxAD5JloU4KC7axMjo9bu9
Hk8z1j7KjhFGzYA/QqlWCJ96rT5Y/ZG6T30X4zdfNtVbdb6GOZi3w+QxcBtRsRaz
BRa9N4KAFrewvq3YWCkmxEfgF3+CqUryTDpL8VzeaPFznjNOwxmOWXKbX39zsi5v
17AHBxbGDXmR7w9gJGRhSf1pnSXHKX0f8AunXGTb9KWymJKj/LhszNWkqL2jYk0E
AAmwdGEhSVBJubDaIuWRBcXX2eCKTn1uffynvhMiGUFAYNbIIR+tgdZAQcRfYVW9
kqcYQWpx3+yRjyu1biwuo5H0qVzMyJ8k0F0BsEBmOi7naJzvaWwM/SvaI16hv+62
Vc0jqCfTCp7oX6x18MaI5bCCOsrYpRImk8+rcLcZ8eOII2Et6uRX+1B6Dq6N8H3t
DGkNzXxUP461YRbTooto2lU4PkgAaKPwc4UF7iWwZ+eGTyNWhcTBKh2hQSUNBeLB
OxRZzfVWUvM=
=zLQN
-----END PGP SIGNATURE-----

--Apple-Mail=_B3014DF0-E818-4BF0-8523-BCCF85269B15--
