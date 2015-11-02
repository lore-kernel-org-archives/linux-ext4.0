From: Andreas Dilger <adilger@dilger.ca>
Subject: e2fsck performance for large lost+found dirs
Date: Mon, 2 Nov 2015 15:49:38 -0700
Message-ID: <62BDBCF1-B82A-449C-BFDD-84AF76CC829E@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D161EF78-9597-415B-B70D-18F149D1D630"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34761 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbbKBWto (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2015 17:49:44 -0500
Received: by padec8 with SMTP id ec8so52229792pad.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2015 14:49:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D161EF78-9597-415B-B70D-18F149D1D630
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Running e2fsck on a filesystem with a large number of disconnected =
inodes
can take a long time to complete.   This can happen with Lustre, since =
there
may be hundreds of thousands of inodes in one directory, and extent =
corruption
can wipe out the whole directory (more on that in a separate email).

It is a very lengthy O(n^2) operation to reattach all disconnected =
inodes
to lost+found, which can take a long time if there are millions of them.


It would be much more efficient to keep a cursor pointing to the last =
leaf
block in the directory in which an entry was inserted. Since e2fsck is =
not
deleting entries from lost+found, and because the entry names are always
getting longer (due to scanning in increasing inode number order) there =
is
no value to search earlier blocks again. This would make lost+found =
insertion
O(1) and significantly improve e2fsck performance in this case. This =
could be
very fast since there is only the inode bitmap to traverse, and =
filenames are
"#ino" so only leaf block allocation and writes needed.

For generic libext2fs usage (e.g. Darrick's FUSE interface) where =
entries
may be deleted from a directory, the cursor could be reset to the block =
of
any deleted entry, if it was at a lower offset.

Darrick, at one time I thought you had a patch to fix this behaviour, =
but
I couldn't find it.  Maybe your patch was related to a similar O(n^2) =
search
problem with block allocation?


Any thoughts about how to fix this?  I was originally thinking that I =
could
just cache this into the "file pointer", but no such thing exists in the
ext2fs_link() interface, only the directory inode number is passed, and =
it
has an additional level of indirection in that it calls the block =
iterator
with a callback to process each leaf block separately.  It also has the
problem that any cache would be local to ext2fs_link() and not visible =
to
ext2fs_unlink().

I was thinking to start with ext2fs_link() calling ext2fs_dir_iterate2()
directly, just to avoid the first level of confusion in this code.  That
still doesn't allow passing a starting offset for the iteration, =
however.

Next, cache the block number into the link_struct state and skip the =
leaf
block searches if block number < cursor, but that still needs iterating
over all the blocks to skip to the last one.

Should I just call ext2fs_block_iterate2() in e2fsck_reconnect_file()
and keep the mechanics local to e2fsck?  I thought it might be a good
generic optimization, but the interfaces make this difficult.

Cheers, Andreas






--Apple-Mail=_D161EF78-9597-415B-B70D-18F149D1D630
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjfog3Kl2rkXzB/gAQhp1Q/+M5iA3tTlPhBHg2ZJ1k0kVY1jp3nYtBaA
HUH6ROkiwyEiGGU3wmJsA/wX1F5BCeOxmVSsbAQ4Iz9hQNhYM9FzJABnxQZsBF89
jTBk05EoYtGhpawGGlXLNHZdw7kCCfzHqFoC1/C2JYpEaoKOsLmvf/KznPZ0AbcI
d86tM4OKsXzQrkkjyLoBMWyYHUVeCbHCJ9FQG1YiAZiIKtOw99fFP8Dn60kOdueV
vBB1YewSdiwxllzFNxFQR7272ra9cNPOd91wQPDuOWkZiMJM25Fbxc4UxCek1/zg
OEPcgqCdimk2jteYXLHS5SRajLx9v/SQz/dMPeSuVtlgzH1PwnBh/8xt9ZJvgZRu
KV7YrML7KMPwxiKVcnmG1zceAhem3B8XNZaEvP8QnIPJ+x0JQfbAfhigHKK0NO95
6J/K9XyVDXwR3JR3JU9kZMYPsyn1Iyw42CcVC8c+ifjt9/40R4VMr/0ClCqcbSke
WxdG2OMjZa17wJOWBgA7BOcDFDP+AYSeEDLdIdRQe0U53qrHmlF3UfYNQVlCZtKF
Oy1Geu/BHxgQNO82Ctfu2b6FwfGi/4Fw1qWfOOZ+ea7ObmADyCh13P6pWepB5Bvp
Cbe63zaFaa8TbL/Mer4ZOZRHrYSy2JExS8RMU7qh+qr+O1jzimLAvVBRMNnRXteb
dFRz2TuCtRw=
=9n5Y
-----END PGP SIGNATURE-----

--Apple-Mail=_D161EF78-9597-415B-B70D-18F149D1D630--
