From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH] ext4: don't trap kswapd and allocating tasks on ext4
 inode IO
Date: Tue, 16 May 2017 03:34:27 +0200
Message-ID: <92681C1D-9812-4868-9A26-40CF0644BAB4@dilger.ca>
References: <20170515154634.19733-1-hannes@cmpxchg.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_97FA4264-CED1-4775-8388-622BF5C9873C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
To: Johannes Weiner <hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170515154634.19733-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_97FA4264-CED1-4775-8388-622BF5C9873C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 15, 2017, at 5:46 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>=20
> We have observed across several workloads situations where kswapd and
> direct reclaimers get stuck in the inode shrinker of the ext4 / mount,
> causing allocation latencies across tasks in the system, while there
> are dozens of gigabytes of clean page cache covering multiple disks.
>=20
> The inode shrinker has provisions to skip any inodes that require
> writeback, to avoid tarpitting the entire system behind a single
> object when there are many other pools to recycle memory from. But
> that logic doesn't cover the situation where an ext4 inode is clean
> but journaled and tied to a commit that yet needs to hit the platter.
>=20
> Add a superblock operation that lets the generic inode shrinker query
> the filesystem whether evicting a given inode will require any IO; add
> an ext4 implementation that checks whether the journal is caught up to
> the commit id associated with the inode.
[snip]

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5834c4d76be8..4cb6cf932d9a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -182,6 +182,23 @@ int ext4_truncate_restart_trans(handle_t *handle, =
struct inode *inode,
> 	return ret;
> }
>=20
> +int ext4_evict_needs_io(struct inode *inode)
> +{
> +	if (inode->i_nlink &&
> +	    inode->i_ino !=3D EXT4_JOURNAL_INO &&
> +	    ext4_should_journal_data(inode) &&
> +	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
> +		journal_t *journal =3D EXT4_SB(inode->i_sb)->s_journal;
> +		tid_t commit_tid =3D EXT4_I(inode)->i_datasync_tid;
> +		int err;
> +
> +		err =3D __jbd2_complete_transaction(journal, commit_tid, =
false);

=46rom a code style point of view, having a function exported with a =
name like
"__jbd2..." is probably bad.  An argument of "false" is meaningless at =
the
caller here.  It would be better to have a function name something like
jbd2_complete_transaction_nowait() exported, so that it is more clear =
what
this function does.

It would be even better to add a comment block for this function that
explains that the caller should use "jbd2_log_wait_commit(journal, tid)"
if it wants to wait for this transaction to complete commit.

Cheers, Andreas






--Apple-Mail=_97FA4264-CED1-4775-8388-622BF5C9873C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZGlckpIg59Q01vtYRAp8ZAJ43LWH7Ok8afdShq1IzHSvZ76JWowCgpNbR
672W8lQaxpSNUw7Uif27E9g=
=qyoh
-----END PGP SIGNATURE-----

--Apple-Mail=_97FA4264-CED1-4775-8388-622BF5C9873C--
