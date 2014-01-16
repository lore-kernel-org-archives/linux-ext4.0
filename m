From: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: maintain badblocks list on the fly
Date: Thu, 16 Jan 2014 10:50:01 +0100
Message-ID: <52D7AB49.2090907@rempel-privat.de>
References: <52C92DC9.7030806@rempel-privat.de> <20140106012732.GA21107@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="doWlSEJi7F7qnwTA7rB85Aqk7ssBmG1Qw"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50834 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaAPJuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 04:50:13 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0M7YF5-1V6YxI3aMB-00xINX for
 <linux-ext4@vger.kernel.org>; Thu, 16 Jan 2014 10:50:11 +0100
In-Reply-To: <20140106012732.GA21107@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--doWlSEJi7F7qnwTA7rB85Aqk7ssBmG1Qw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 06.01.2014 02:27, schrieb Theodore Ts'o:
> On Sun, Jan 05, 2014 at 11:02:49AM +0100, Oleksij Rempel wrote:
>>
>> after some googling i didn't found answer to my question, so i set it
>> directly here: do it makes sense and is it possible to maintain bad
>> block list of ext4 on fly? I mean, if ext4 get error from, for example=

>> from ata subsystem, and it will mark block as bad or may be better as
>> "probably bad"?
>=20
> Figuring out what to do in case of an error is tricky.  Sometimes
> errors are transient.  For example, losing a connection (perhaps
> briefly) to a disk connected via fiber channel).
>=20
> Also, with most hard drives, if you rewrite a block which has reported
> a read error, the hard drive will usually remap the block to one of
> the blocks in the spare pool.  So one strategy is when you get a read
> error is not to avoid using the block forever, but to simply write all
> zero's to the block, and then see if the block is now valid.  But now
> combine this with the "some errors are transient" problem --- if you
> do a forced rewrite, you might lose data that you could get back i you
> try rereading the block later.  So it's rare file system author that
> is willing to do an automated forced rewrite when getting a read
> error.
>=20
> For a write error, it's safer to try rewriting the block, but most of
> the time the hard drive will have tried rewriting the block already,
> unless it's due to a connection problem between the file system and
> the storage device.  For example, suppose the file system is accessing
> an iSCSI block device which where the transport layer between computer
> and the storage device is a TCP connection...
>=20
> So the problem with automated error recovery is that it's highly
> dependent on the storage device (is it a RAID; a hard drive; an iSCSI
> device, etc.) and the application / what are you storing.
>=20
> For example, if the file system is on a direct connected HDD as the
> back end for a cluster file system such as hadoopfs or the Google File
> System, where the cluster file system is storing every chunk of its
> file replicated on multiple file servers, and/or using some kind of
> Reed Solomon encoding, when you detect a read error on data block, the
> best thing to do might be to delete file (relying on the fact that the
> next time you write to the bad block, the HDD will remap the block to
> one of the blocks in the spare pool), and then informing the cluster
> file system that it should do a Reed Solomon reconstruction or to
> otherwise reshard that portion of the file.
>=20
> At one point I toyed with trying to get something upstream where the
> bad block notification would get sent via a netlink channel.  That way
> userspace can do something appropriate, instead of trying to encode
> what can potentially extremely complicated policy decisions into the
> kernel.  I never had the time to get the design and interface clean
> enough for upstream, though.

Good point,
back to this drive. It appears to be one of drive which report error but
do not remember it in SMART. One day of testing caused SMART to report 2
pending corrupt blocks. After reboot, there was 0 pending and relocated
blocks. It means there is no way to detect hardware degradation with SMAR=
T.
It reports no error on write, only some times on read and there is no
guaranty that readed data is not corrupt.
If i see correctly, mostly affected are consumer devices like laptops
and PCs. They do not have RAID, mostly no backups and if they would have
some primitive backup option, it wont really help find and restore
corrupt files.

--=20
Regards,
Oleksij


--doWlSEJi7F7qnwTA7rB85Aqk7ssBmG1Qw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLXq1IACgkQHwImuRkmbWmumwD/d2tdcZ2UhXz4PymdWNajNUOA
6IEALo+DXMyfTBIv7F0A/RNryNoDZnfAOKYHaQMdaVsGWIIaEBw11QMuCN5BC2XQ
=6Izk
-----END PGP SIGNATURE-----

--doWlSEJi7F7qnwTA7rB85Aqk7ssBmG1Qw--
