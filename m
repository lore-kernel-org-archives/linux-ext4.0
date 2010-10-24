From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 16:30:28 +0200
Message-ID: <4CC44304.1050409@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigAB93E56816610BDEC7301637"
Cc: Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:4678 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab0JXOf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 10:35:59 -0400
In-Reply-To: <4CC43AC9.8000409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enigAB93E56816610BDEC7301637
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/24/2010 03:55 PM, Ric Wheeler wrote:
>   On 10/23/2010 06:17 PM, Ted Ts'o wrote:
>> On Sat, Oct 23, 2010 at 06:00:05PM +0200, Amir Goldstein wrote:
>>> IMHO, and I've said it before, the mount flag which Bernd requests
>>> already exists, namely 'errors=3D', both as mount option and as
>>> persistent default, but it is not enforced correctly on mount time.
>>> If an administrator decides that the correct behavior when error is
>>> detected is abort or remount-ro, what's the sense it letting the
>>> filesystem mount read-write without fixing the problem?
>> Again, consider the case of the root filesystem containing an error.
>> When the error is first discovered during the source of the system's
>> operation, and it's set to errors=3Dpanic, you want to immediately
>> reboot the system.  But then, when root file system is mounted, it
>> would be bad to have the system immediately panic again.  Instead,
>> what you want to have happen is to allow e2fsck to run, correct the
>> file system errors, and then system can go back to normal operation.
>>
>> So the current behavior was deliberately designed to be the way that
>> it is, and the difference is between "what do you do when you come
>> across a file system error", which is what the errors=3D mount option =
is
>> all about, and "this file system has some kind of error associated
>> with it".  Just because it has an error associated with it does not
>> mean that immediately rebooting is the right thing to do, even if the
>> file system is set to "errors=3Dpanic".  In fact, in the case of a roo=
t
>> file system, it is manifestly the wrong thing to do.  If we did what
>> you suggested, then the system would be trapped in a reboot loop
>> forever.
>>
>> 							- Ted
>=20
> I am still fuzzy on the use case here.
>=20
> In any shared ext* file system (pacemaker or other), you have some basi=
c rules:
>=20
> * you cannot have the file system mounted on more than one node
> * failover must fence out any other nodes before starting recovery
> * failover (once the node is assured that it is uniquely mounting the f=
ile=20
> system) must do any recovery required to clean up the state
>=20
> Using ext* (or xfs) in an active/passive cluster with fail over rules t=
hat=20
> follow the above is really common today.
>=20
> I don't see what the use case here is - are we trying to pretend that p=
acemaker=20
> + ext* allows us to have a single, shared file system in a cluster moun=
ted on=20
> multiple nodes?

The use case here is Lustre. I think ClusterFS and then later the  Sun
Lustre group (Andreas Dilger, Alex Zhurlaev/Tomas, Girish Shilamkar)
contributed lots of ext3 and ext4 code, as  Lustres underlying disk
format ldiskfs is based on ext3/ext4 (remaining patches, such as MMP are
supposed to be added to ext4 and others such as open-by-inode are
supposed to be given up, ones the vfs supports open-by-filehandle (or so)=
).

So Lustre mounts a device to a directory (but hides the content to user
space) and then makes the objects in filesystem available globally to
many clients. On first simple glance that is similar to NFS, but Lustre
combines the objects of many ldiskfs filesystems into a single global
filesystem. In order to provide to high-availability, you need to use
any kind of shared storage device. Internal raid1 is planned, but still
not available, so far only raid0 (striping) is supported.

>=20
> Why not use ocfs2 or gfs2 for that?

You are welcome to write a Lustre plugin for that :) Although, extending
btrfs and use that might be the better choice. Lustre is already going
to supprt ZFS and will make use of ZFS checksums also for its network
checksums, as far as I know. The same should be feasible with btrfs
checksums.


Cheers,
Bernd


--------------enigAB93E56816610BDEC7301637
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzEQwsACgkQqh74FqyuOzSEBQCgtnESOWF6InMCLU3aCr1HE1bW
4ggAnjne07WBn9FwnywQx4PptRRu1btk
=NIxr
-----END PGP SIGNATURE-----

--------------enigAB93E56816610BDEC7301637--
