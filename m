From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#679830: linux-image-2.6.32-5-686: Kernel bug observed in
 syslog when performing an rsync operation.
Date: Sun, 22 Jul 2012 05:49:26 +0100
Message-ID: <1342932566.11373.229.camel@deadeye.wl.decadent.org.uk>
References: <20120701221420.1784.81013.reportbug@altair.ejectdisc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JL8dE6nHzj5VirOr6Laf"
Cc: 679830@bugs.debian.org, linux-ext4@vger.kernel.org
To: Imran Chaudhry <ichaudhry@gmail.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45731 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab2GVEtk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2012 00:49:40 -0400
In-Reply-To: <20120701221420.1784.81013.reportbug@altair.ejectdisc.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-JL8dE6nHzj5VirOr6Laf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-07-01 at 23:14 +0100, Imran Chaudhry wrote:
> Package: linux-2.6
> Version: 2.6.32-45
> Severity: normal
>=20
> Kernel bug observed in syslog when performing an rsync operation. I
> use rsnapshot and I believe an rsnapshot operation "conflicted" or
> "interfered" somehow with my manual rsync command. The source and
> destination are USB HDDs with ext4 filesystems. After the kernel bug
> was observed I discovered the source filesystem had a corrupt
> filesystem. If it is relevant I was using the rsync command with
> --hard-links and I also observed messages of this sort:
> "[1075483.039915] EXT4-fs error (device sdb1): htree_dirblock_to_tree:
> bad entry in directory #7143723: directory entry across blocks -
> block=3D34323866offset=3D0(0), inode=3D135151872, rec_len=3D66180,
> name_len=3D66" and "Jul  1 06:33:06 altair kernel: [1075335.376996]
> EXT4-fs error (device sdb1): ext4_lookup: deleted inode referenced:
> 8954048".

Sorry to hear this.  I cannot recommend using ext4 in Linux 2.6.32.

> Relevant kernel log trace with bug:
> Jul  1 05:37:53 altair kernel: [1072022.349172] ------------[ cut here ]-=
-----------
> Jul  1 05:37:53 altair kernel: [1072022.352027] kernel BUG at /build/buil=
dd-linux-2.6_2.6.32-45-i386-yQfQSv/linux-2.6-2.6.32/debian/build/source_i38=
6_none/fs/ext4/extents.c:1873!
> Jul  1 05:37:53 altair kernel: [1072022.352027] invalid opcode: 0000 [#1]=
 SMP=20
> Jul  1 05:37:53 altair kernel: [1072022.352027] last sysfs file: /sys/dev=
ices/pci0000:00/0000:00:1e.0/0000:02:09.1/usb4/4-0:1.0/bInterfaceProtocol
> Jul  1 05:37:53 altair kernel: [1072022.352027] Modules linked in: xt_mul=
tiport iptable_filter ip_tables x_tables fuse nfsd exportfs nfs lockd fscac=
he nfs_acl auth_rpcgss sunrpc ext4 jbd2 crc16 loop raid1 md_mod snd_intel8x=
0 snd_ac97_codec ac97_bus snd_pcm i2c_i801 snd_timer shpchp snd psmouse evd=
ev soundcore parport_pc parport serio_raw i2c_core snd_page_alloc pcspkr pc=
i_hotplug rng_core processor button ext3 jbd mbcache usb_storage sd_mod crc=
_t10dif ata_generic ata_piix uhci_hcd e100 libata ehci_hcd thermal floppy r=
8169 mii usbcore nls_base scsi_mod thermal_sys [last unloaded: scsi_wait_sc=
an]
> Jul  1 05:37:53 altair kernel: [1072022.352027]=20
> Jul  1 05:37:53 altair kernel: [1072022.352027] Pid: 31553, comm: rsync N=
ot tainted (2.6.32-5-686 #1) Deskpro
> Jul  1 05:37:53 altair kernel: [1072022.352027] EIP: 0060:[<e0ea5b00>] EF=
LAGS: 00010246 CPU: 0
> Jul  1 05:37:53 altair kernel: [1072022.352027] EIP is at ext4_ext_get_bl=
ocks+0x286/0x1916 [ext4]
> Jul  1 05:37:53 altair kernel: [1072022.352027] EAX: 00000000 EBX: 000000=
00 ECX: 00000000 EDX: 00000000
> Jul  1 05:37:53 altair kernel: [1072022.352027] ESI: 00000000 EDI: db1216=
f4 EBP: 00000000 ESP: dfad7ad0
[...]

This specific failure mode seems to have been made possible by:

commit 731eb1a03a8445cde2cb23ecfb3580c6fa7bb690
Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Wed Mar 3 23:55:01 2010 -0500

    ext4: consolidate in_range() definitions

which was backported into a stable update.  If the 'first' and 'len'
arguments to in_range() are both 0 and either of them is unsigned, it
wrongly returns true.  This means that:

		if (in_range(iblock, ee_block, ee_len)) {
			...
				ext4_ext_put_in_cache(inode, ee_block,
							ee_len, ee_start,
							EXT4_EXT_CACHE_EXTENT);

may pass ee_len =3D=3D 0 to ext4_ext_put_in_cache(), triggering the BUG_ON
there.  Maybe that's just not a valid case so this doesn't matter, but
it seems like it might be possible with a corrupt filesystem?

Anyway, I think the proper definition of in_range() is:

#define in_range(b, first, len) ((b) >=3D (first) && ((b) - (first)) < (len=
))

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-JL8dE6nHzj5VirOr6Laf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUAuGVue/yOyVhhEJAQqTsxAAteGjM6gFECoZU14Q0eEoa7rN08werle+
4gG3NjDdjsVwrPz5Z4WVHvgZ1JdW2OEz1J5kOdz8aqc8tz4C7PzAj5Fd30IGL72x
uR5tj98WduF8QI/vJEBdmPLgj2if3BtXGHwm+E/RpCdYCCXgvCuZglypvzeC1MUG
9Rjq/L9dgVQKjqXs5dTxjA/oEhZaL7JbadigEUG8oCt+NLG8kQ6Vi3wmmH1Xc9Ah
WnxVNzxwt9n95f0EAr7Qosg/bZZU0d2w2MkCXxirhEgK8fOkbnFP1tos8zTk1XhM
8ax5XX1TIi7ywu4ZSX1zCq0vIEAcBmziH33Fs3fibvNiPJyAgWWbfHpC48rlrC66
eYGzJdluuv1n+QaKobTKGn1Bge0n8/EOTCr5YpVqXaHsEdgBVsC8iZifNVnFMr2s
dvaMHg27OYD8xC+9cWrI/9JbixNwkNmbytKbvbsfP/GcQUV233CdQVp7HG4CspXb
qAywdCO453JZWJPF0eQ4fk56t16nTZ/YV1abiAWMaNTzIZkqnXZeEV3N12RGQ3dk
aXGuGZ4AO7vyfI0f24qZ4baFGMnhQo6Wa+J99OZgo+Bsfa8mYMAUeTrL/Qru77nJ
GJFkGUI20pnJJKFizlc7myaKsjGQw1L5VGpdQcy+PrjwPrlrqs9Ls5o7EgandTLf
jfiCQMD62DQ=
=wCfL
-----END PGP SIGNATURE-----

--=-JL8dE6nHzj5VirOr6Laf--
