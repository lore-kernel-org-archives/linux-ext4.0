From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 37/49] e2fsck: read-ahead metadata during passes 1, 2, and 4
Date: Mon, 17 Mar 2014 17:10:22 -0600
Message-ID: <8715537A-D22B-4CDC-B76B-75B62FDBC1D7@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065757.30585.46729.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_08858F9B-8685-4595-8CCB-B431DB48178C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62595 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaCQXLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2014 19:11:25 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so6169138pdj.41
        for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2014 16:11:24 -0700 (PDT)
In-Reply-To: <20140311065757.30585.46729.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_08858F9B-8685-4595-8CCB-B431DB48178C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Mar 11, 2014, at 12:57 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:

> e2fsck pass1 is modified to use the block group data prefetch function
> to try to fetch the inode tables into the pagecache before it is
> needed.  In order to avoid cache thrashing, we limit ourselves to
> prefetching at most half the available memory.

It looks like the prefetching is done in huge chunks, and not =
incrementally?
It makes more sense to have a steady amount of prefetch happening =
instead
of waiting for it to all be consumed before starting a new batch.  See =
in
e2fsck_pass1() below.

> pass2 is modified to use the dirblock prefetching function to prefetch
> the list of directory blocks that are assembled in pass1.  So long as
> we don't anticipate rehashing the dirs (pass 3a), we can release the
> dirblocks as soon as we're done checking them.
>=20
> pass4 is modified to prefetch the block and inode bitmaps in
> anticipation of pass 5, because pass4 is entirely CPU bound.
>=20
> In general, these mechanisms can halve fsck time, if the host system
> has sufficient memory and the storage system can provide a lot of
> IOPs.  SSDs and multi-spindle RAIDs see the most speedup; single disks
> experience a modest speedup, and single-spindle USB mass storage
> devices see hardly any benefit.
>=20
> By default, readahead will try to fill half the physical memory in the
> system.  The -R option can be given to specify the amount of memory to
> use for readahead, or zero to disable it entirely; or an option can be
> given in e2fsck.conf.
>=20
>=20
> +static void *pass1_readahead(void *p)
> +{
> +	struct pass1ra_ctx *c =3D p;
> +	errcode_t err;
> +
> +	ext2fs_readahead(c->fs, EXT2_READA_ITABLE, c->group, =
c->ngroups);
> +	return NULL;
> +}
> +
> +static errcode_t initiate_readahead(e2fsck_t ctx, dgrp_t group, =
dgrp_t ngroups)
> +{
> +	struct pass1ra_ctx *ractx;
> +	errcode_t err;
> +
> +	err =3D ext2fs_get_mem(sizeof(*ractx), &ractx);
> +	if (err)
> +		return err;
> +
> +	ractx->fs =3D ctx->fs;
> +	ractx->group =3D group;
> +	ractx->ngroups =3D ngroups;
> +
> +	err =3D e2fsck_run_thread(&ctx->ra_thread, pass1_readahead,
> +				pass1_readahead_cleanup, ractx);
> +	if (err)
> +		ext2fs_free_mem(&ractx);
> +
> +	return err;
> +}
> +
>  void e2fsck_pass1(e2fsck_t ctx)
>  {
> 	int	i;
> @@ -611,10 +654,37 @@ void e2fsck_pass1(e2fsck_t ctx)
> 	int		busted_fs_time =3D 0;
> 	int		inode_size;
> 	int		failed_csum =3D 0;
> +	dgrp_t		grp;
> +	ext2_ino_t	ra_threshold =3D 0;
> +	dgrp_t		ra_groups =3D 0;
> +	errcode_t	err;
>=20
> 	init_resource_track(&rtrack, ctx->fs->io);
> 	clear_problem_context(&pctx);
>=20
> +	/* If we can do readahead, figure out how many groups to pull =
in. */
> +	if (!ext2fs_can_readahead(ctx->fs))
> +		ctx->readahead_mem_kb =3D 0;
> +	if (ctx->readahead_mem_kb) {
> +		ra_groups =3D ctx->readahead_mem_kb /
> +			    (fs->inode_blocks_per_group * fs->blocksize =
/
> +			     1024);
> +		if (ra_groups < 16)
> +			ra_groups =3D 0;

It probably always makes sense to prefetch one group if possible?

> +		else if (ra_groups > fs->group_desc_count)
> +			ra_groups =3D fs->group_desc_count;
> +		if (ra_groups) {
> +			err =3D initiate_readahead(ctx, grp, ra_groups);

Looks like "grp" is used uninitialized here.  Should be "grp =3D 0" to =
start.

> +			if (err) {
> +				com_err(ctx->program_name, err, "%s",
> +					_("while starting pass1 =
readahead"));
> +				ra_groups =3D 0;
> +			}
> +			ra_threshold =3D ra_groups *
> +				       fs->super->s_inodes_per_group;

This is the threshold of the last inode to be prefetched.

> +		}
> +	}
> +
> 	if (!(ctx->options & E2F_OPT_PREEN))
> 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
>=20
> @@ -778,6 +848,19 @@ void e2fsck_pass1(e2fsck_t ctx)
> 			if (e2fsck_mmp_update(fs))
> 				fatal_error(ctx, 0);
> 		}
> +		if (ra_groups && ino > ra_threshold) {

This doesn't start prefetching again until the last inode is checked.
It probably makes sense to have a sliding window to start readahead
again once half of the memory has been consumed or so.  Otherwise,
the scanning will block here until the next inode table is read from
disk, instead of the readahead being started earlier and it is in RAM.

> +			grp =3D (ino - 1) / =
fs->super->s_inodes_per_group;
> +			ra_threshold =3D (grp + ra_groups) *
> +				       fs->super->s_inodes_per_group;

> +			err =3D initiate_readahead(ctx, grp, ra_groups);
> +			if (err =3D=3D EAGAIN) {
> +				printf("Disabling slow readahead.\n");
> +				ra_groups =3D 0;

I see that EAGAIN comes from e2fsck_run_thread(), if there is still a
readahead thread running.  Does it make sense to stop readahead in
that case?  It would seem to me that if readahead is taking a long
time and the inode processing is catching up to it (i.e. IO bound)
then it is even more important to do readahead in that case.

Something like the following to readahead half of the inode tables once
half of them have been processed, and shrink the readahead window if the
readahead is being called too often:

	if (ra_groups !=3D 0 && ino > ra_threshold - (ra_groups + 1) / 2 =
*
					fs->super->s_inodes_per_group) {	=
		if (ra_threshold < ino)
			ra_threshold =3D ino;
		grp =3D (ra_threshold -1) / =
fs->super->s_inodes_per_group;
		err =3D initiate_readahead(ctx, grp, (ra_groups + 1) / =
2);
		if (err =3D=3D EAGAIN)
			ra_groups =3D (ra_groups + 1) / 2;
		else if (err)
			com_err(ctx->program_name, err, "%s",
				_("while starting pass1 readahead"));
		else
			ra_threshold +=3D (ra_groups + 1) / 2 *
				fs->super->s_inodes_per_group;
	}

> +			} else if (err) {
> +				com_err(ctx->program_name, err, "%s",
> +					_("while starting pass1 =
readahead"));
> +			}
> +		}
> 		old_op =3D ehandler_operation(_("getting next inode from =
scan"));
> 		pctx.errcode =3D ext2fs_get_next_inode_full(scan, &ino,
> 							  inode, =
inode_size);
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 80ebdb1..d6ef8c5 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -74,7 +74,7 @@ static void usage(e2fsck_t ctx)
> 		_("Usage: %s [-panyrcdfvtDFV] [-b superblock] [-B =
blocksize]\n"
> 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
> 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j =
external_journal]\n"
> -		"\t\t[-E extended-options] device\n"),
> +		"\t\t[-E extended-options] [-R readahead_kb] device\n"),

Note that "-R" is only recently deprecated for raid options, why not =
make
this an option under "-E"?

> 		ctx->program_name);
>=20
> 	fprintf(stderr, "%s", _("\nEmergency help:\n"
> @@ -90,6 +90,7 @@ static void usage(e2fsck_t ctx)
> 		" -j external_journal  Set location of the external =
journal\n"
> 		" -l bad_blocks_file   Add to badblocks list\n"
> 		" -L bad_blocks_file   Set badblocks list\n"
> +		" -R readahead_kb      Allow this much readahead.\n"


Cheers, Andreas






--Apple-Mail=_08858F9B-8685-4595-8CCB-B431DB48178C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUyeA3nKl2rkXzB/gAQLkHw//c14VYdNjO5A5bk32GKenwjOUAvU8nOkm
u1vPAv1lfVczK9RRH5OWcD5YFP0R/4c5ITO050DGJAChskZAY+lFRKX4UtKI8+pn
cpXfiPPi3uVqEACuBvpAeIFajCZPZDB92we3SAWYVXdnANsXA6bm+SyvFIX2Sygj
IspwPPxl4zlVVkILiVls5U31DPDgCdWaJYhR8aY2Siz+1xhD2aJrfLD1nW4pwNvW
KW166M3b5hjct/CucR4KA/dJkU1/rdy4QPtT3CeIV57is4TXsGxf68sKMqIJmMmt
WJ7eXCmkZfeUMY0kemj3vKr5dFYd74WAISXN3nsxh2OqW20ksj9Q+1mY0LeGb8jY
5ia7dp9Wlz66877PPoZAdvmeLCjnTkWOWJ3bgFOaz4UZg82Y5OSAvnXXKSE6kOjK
lnbcrHHdtHEesDOmJwLurXwD1i43zFpuOhQq4Ibz2ebxJr7nH48PPka7fmiqG+kA
SVszIb/RbIvPs+KhmGn9qGttKb8udNZP1mhy20aIlp92DM5C+4swQYzi2NfQsTEa
yAinEXZ4yOWgLChmSMdLGWGKjpsk5g3Aj0QeASkp8XBQ0ZVMgfMFLxt21hjW0kLt
fiiR6ZgJDj5Qb7+qyT8uSYlxdPz//F0AeQ3SfoJKesn9Y3tseelkgUwLeayakeTq
MqqZF+5M7vo=
=24/2
-----END PGP SIGNATURE-----

--Apple-Mail=_08858F9B-8685-4595-8CCB-B431DB48178C--
