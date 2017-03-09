From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Thu, 9 Mar 2017 12:21:11 -0700
Message-ID: <CC34622D-33DE-42BD-BE87-81244C1D65F6@dilger.ca>
References: <20170211031942.11783-1-tytso@mit.edu>
 <FD2DE284-B640-4369-9A7C-E2224011541F@dilger.ca>
 <20170212022738.vhr532yybcictgcz@thunk.org>
 <20170309134720.GJ15874@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FA4D5C72-4A19-447C-9781-CA3988173C5E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33800 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753251AbdCITVa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Mar 2017 14:21:30 -0500
Received: by mail-it0-f66.google.com with SMTP id r141so11057278ita.1
        for <linux-ext4@vger.kernel.org>; Thu, 09 Mar 2017 11:21:18 -0800 (PST)
In-Reply-To: <20170309134720.GJ15874@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FA4D5C72-4A19-447C-9781-CA3988173C5E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 9, 2017, at 6:47 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Sat 11-02-17 21:27:38, Ted Tso wrote:
>> On Sat, Feb 11, 2017 at 12:26:52AM -0700, Andreas Dilger wrote:
>>> The reason truncated orphans are on the orphan list is because the
>>> transaction that sets i_size may be restarted if the inode is larger
>>> than can be truncated in a single transaction.  If the system =
crashes
>>> before the truncate finishes then the truncate should be completed
>>> so that old data is not returned if the file is truncated larger =
again.
>>=20
>> Another way of fixing this is at the time when the file is truncated
>> to a larger size.  Of course the other case we need handle is what
>> happens if there is data after i_size and the file is mmaped.
>>=20
>> One advantage of doing when the file is truncated larger again is at
>> that point we will have the encryption key.  In the case of an
>> encrypted file, both the kernel and e2fsck *can't* zero fill past
>> i_size if the key is not available.  And during the orphan replay the
>> encryption key won't be available.
>>=20
>> The other way to solve the problem would be zero the portion of the
>> last remaining datablock *first* and journal the data block along =
with
>> the initial transaction which sets the i_size in the inode.  But that
>> gets tricky, since all data writes for that last block must not go to
>> the disk, and then once the journal has been committed we can't write
>> the block to via the normal page_io routines (since otherwise it =
might
>> get overwritten), until we write it back and then revoke the block in
>> the journal, and the revoke is committed.  Messy....
>=20
> Going through some old email... I don't think this would be really
> reasonably doable. What would fixup the missing zeroing on orphan =
cleanup
> though is to zero the tail of the last page on readpage, extending
> truncate and write beyond EOF. That may be acceptable cost for =
encrypted
> inodes.

Another option would be to revive the unlink/truncate thread, and dump
the blocks to be truncated over to another (temporary) inode that is put
on the orphan list and will be unlinked.  That means the visible =
truncate
operation can always complete in a single transaction (including the
partial block write), and everything on the orphan list is essentially =
an
unlink rather than a truncate.

The code wasn't too complex, but we dropped it when extents arrived =
since
it didn't give a huge performance advantage.  That said, there could be =
a
benefit in terms of code simplification, since there wouldn't be the =
need
to restart transactions in the middle if the truncate gets too large.

The most recent version I could find is for ext3 in 2.4.29 at:

=
https://git.hpdd.intel.com/?p=3Dfs/lustre-release.git;a=3Dblob_plain;f=3Dl=
ustre/kernel_patches/patches/ext3-delete_thread-2.4.29.patch;hb=3D11330397=
3ec9f8484eb2355a1a6ef3c4c7fd6a56

Cheers, Andreas






--Apple-Mail=_FA4D5C72-4A19-447C-9781-CA3988173C5E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYwasppIg59Q01vtYRAssvAJwIOgX3ef6tAgqKHD7csm59hripnwCeIkyf
AHcRr4VY7y4UDQujljAiSLA=
=N4mo
-----END PGP SIGNATURE-----

--Apple-Mail=_FA4D5C72-4A19-447C-9781-CA3988173C5E--
