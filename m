From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/4] LU-7368 e2fsck: skip quota update when interrupted
Date: Fri, 13 Nov 2015 19:07:17 -0700
Message-ID: <EA609DE0-CE36-4D41-B3CA-335DD777C468@dilger.ca>
References: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com> <1447463429-5966-2-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2B975651-DCCF-4E8D-B4D0-8B5C9DE51083"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34438 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbKNCHf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2015 21:07:35 -0500
Received: by padhx2 with SMTP id hx2so116772672pad.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2015 18:07:34 -0800 (PST)
In-Reply-To: <1447463429-5966-2-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2B975651-DCCF-4E8D-B4D0-8B5C9DE51083
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 13, 2015, at 6:10 PM, Andreas Dilger <andreas.dilger@intel.com> =
wrote:
> There is a bug in how e2fsck handles being interrupted by CTRL-C.
> If CTRL-C is pressed to kill e2fsck rather than e.g. kill -9, then
> the interrupt handler sets E2F_FLAG_CANCEL in the context but doesn't
> actually kill the process.  Instead, e2fsck_pass1() checks this flag
> before processing the next inode.

Sigh, please remove the "LU-7368" label from the summary line, as that
is for internal tracking and I thought I'd done that for the patches
before sending them out.

If desired, this patch can be linked back to our bug tracker to get a
full discussion of the bug as below:

Lustre-change: http://review.whamcloud.com/17150
Lustre-bug-id: https://jira.hpdd.intel.com/browse/LU-7368


For "libext2fs: fix block-mapped file punch" it would be:
Lustre-change: http://review.whamcloud.com/17152
Lustre-bug-id: https://jira.hpdd.intel.com/browse/LU-7381

and for "e2fsck: fix e2fsck -fD directory truncation" it is:
Lustre-change: http://review.whamcloud.com/17153
Lustre-bug-id: https://jira.hpdd.intel.com/browse/LU-7381

Cheers, Andreas

> If a filesystem is running in fix mode (e2fsck -fy) is interrupted,
> and the quota feature is enabled, then the quota file will still be
> written to disk even though the inode scan was not complete and the
> quota information is totally inaccurate.  Even worse, if the Pass 1
> inode and block scan was not finished, then the in-memory block
> bitmaps (which are used for block allocation during e2fsck) are also
> invalid, so any blocks allocated to the quota files may corrupt other
> files if those blocks were actually used.
>=20
>  e2fsck 1.42.13.wc3 (28-Aug-2015)
>  Pass 1: Checking inodes, blocks, and sizes
>  ^C[QUOTA WARNING] Usage inconsistent for ID 0:
>      actual (6455296, 168) !=3D expected (8568832, 231)
>  [QUOTA WARNING] Usage inconsistent for ID 695:
>      actual (614932320256, 63981) !=3D expected (2102405386240, =
176432)
>  Update quota info for quota type 0? yes
>=20
>  [QUOTA WARNING] Usage inconsistent for ID 0:
>      actual (6455296, 168) !=3D expected (8568832, 231)
>  [QUOTA WARNING] Usage inconsistent for ID 538:
>      actual (614932320256, 63981) !=3D expected (2102405386240, =
176432)
>  Update quota info for quota type 1? yes
>=20
>  myth-OST0001: e2fsck canceled.
>  myth-OST0001: ***** FILE SYSTEM WAS MODIFIED *****
>=20
> There may be a desire to flush out modified inodes and such that have
> been repaired, so that restarting an interrupted e2fsck will make
> progress, but the quota file update is plain wrong unless at least
> pass1 has finished, and the journal recreation is also dangerous if
> the block bitmaps have not been fully updated.
>=20
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
> e2fsck/e2fsck.c |    2 --
> e2fsck/e2fsck.h |    4 ++--
> e2fsck/pass1.c  |    4 +++-
> e2fsck/pass2.c  |   10 +++++-----
> e2fsck/unix.c   |   18 ++++++++++--------
> 5 files changed, 20 insertions(+), 18 deletions(-)
>=20
> diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
> index 0ec1540..2002dc0 100644
> --- a/e2fsck/e2fsck.c
> +++ b/e2fsck/e2fsck.c
> @@ -203,8 +203,6 @@ static pass_t e2fsck_passes[] =3D {
> 	e2fsck_pass1, e2fsck_pass2, e2fsck_pass3, e2fsck_pass4,
> 	e2fsck_pass5, 0 };
>=20
> -#define E2F_FLAG_RUN_RETURN	(E2F_FLAG_SIGNAL_MASK|E2F_FLAG_RESTART)
> -
> int e2fsck_run(e2fsck_t ctx)
> {
> 	int	i;
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index f904026..810030e 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -173,10 +173,10 @@ struct resource_track {
>  */
> #define E2F_FLAG_ABORT		0x0001 /* Abort signaled */
> #define E2F_FLAG_CANCEL		0x0002 /* Cancel signaled */
> -#define E2F_FLAG_SIGNAL_MASK	0x0003
> +#define E2F_FLAG_SIGNAL_MASK	(E2F_FLAG_ABORT | E2F_FLAG_CANCEL)
> #define E2F_FLAG_RESTART	0x0004 /* Restart signaled */
> +#define E2F_FLAG_RUN_RETURN	(E2F_FLAG_SIGNAL_MASK | =
E2F_FLAG_RESTART)
> #define E2F_FLAG_RESTART_LATER	0x0008 /* Restart after all =
iterations done */
> -
> #define E2F_FLAG_SETJMP_OK	0x0010 /* Setjmp valid for abort */
>=20
> #define E2F_FLAG_PROG_BAR	0x0020 /* Progress bar on screen */
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 50a8b99..1c2b8fd 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -766,7 +766,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 							  inode, =
inode_size);
> 		ehandler_operation(old_op);
> 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
> -			return;
> +			goto endit;
> 		if (pctx.errcode =3D=3D =
EXT2_ET_BAD_BLOCK_IN_INODE_TABLE) {
> 			if (!ctx->inode_bb_map)
> 				alloc_bb_map(ctx);
> @@ -1276,6 +1276,8 @@ endit:
>=20
> 	if ((ctx->flags & E2F_FLAG_SIGNAL_MASK) =3D=3D 0)
> 		print_resource_track(ctx, _("Pass 1"), &rtrack, =
ctx->fs->io);
> +	else
> +		ctx->invalid_bitmaps++;
> }
>=20
> /*
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 2b7bff4..822eee4 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -148,14 +148,14 @@ void e2fsck_pass2(e2fsck_t ctx)
>=20
> 	cd.pctx.errcode =3D ext2fs_dblist_iterate2(fs->dblist, =
check_dir_block,
> 						 &cd);
> -	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & =
E2F_FLAG_RESTART)
> -		return;
> -
> 	if (ctx->flags & E2F_FLAG_RESTART_LATER) {
> 		ctx->flags |=3D E2F_FLAG_RESTART;
> -		return;
> +		ctx->flags &=3D ~E2F_FLAG_RESTART_LATER;
> 	}
>=20
> +	if (ctx->flags & E2F_FLAG_RUN_RETURN)
> +		return;
> +
> 	if (cd.pctx.errcode) {
> 		fix_problem(ctx, PR_2_DBLIST_ITERATE, &cd.pctx);
> 		ctx->flags |=3D E2F_FLAG_ABORT;
> @@ -739,7 +739,7 @@ static int check_dir_block(ext2_filsys fs,
> 	buf =3D cd->buf;
> 	ctx =3D cd->ctx;
>=20
> -	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & =
E2F_FLAG_RESTART)
> +	if (ctx->flags & E2F_FLAG_RUN_RETURN)
> 		return DIRENT_ABORT;
>=20
> 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, =
cd->max))
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 66debcd..6d87f50 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1667,8 +1667,15 @@ print_unsupp_features:
> 	}
> no_journal:
>=20
> -	if (ctx->qctx) {
> +	if (run_result & E2F_FLAG_ABORT) {
> +		fatal_error(ctx, _("aborted"));
> +	} else if (run_result & E2F_FLAG_CANCEL) {
> +		log_out(ctx, _("%s: e2fsck canceled.\n"), =
ctx->device_name ?
> +			ctx->device_name : ctx->filesystem_name);
> +		exit_value |=3D FSCK_CANCELED;
> +	} else if (ctx->qctx && !ctx->invalid_bitmaps) {
> 		int i, needs_writeout;
> +
> 		for (i =3D 0; i < MAXQUOTAS; i++) {
> 			if (qtype !=3D -1 && qtype !=3D i)
> 				continue;
> @@ -1695,18 +1702,13 @@ no_journal:
> 		ext2fs_close_free(&fs);
> 		goto restart;
> 	}
> -	if (run_result & E2F_FLAG_ABORT)
> -		fatal_error(ctx, _("aborted"));
>=20
> #ifdef MTRACE
> 	mtrace_print("Cleanup");
> #endif
> 	was_changed =3D ext2fs_test_changed(fs);
> -	if (run_result & E2F_FLAG_CANCEL) {
> -		log_out(ctx, _("%s: e2fsck canceled.\n"), =
ctx->device_name ?
> -			ctx->device_name : ctx->filesystem_name);
> -		exit_value |=3D FSCK_CANCELED;
> -	} else if (!(ctx->options & E2F_OPT_READONLY)) {
> +	if (!(ctx->flags & E2F_FLAG_RUN_RETURN) &&
> +	    !(ctx->options & E2F_OPT_READONLY)) {
> 		if (ext2fs_test_valid(fs)) {
> 			if (!(sb->s_state & EXT2_VALID_FS))
> 				exit_value |=3D FSCK_NONDESTRUCT;
> --
> 1.7.3.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2B975651-DCCF-4E8D-B4D0-8B5C9DE51083
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVkaXVnKl2rkXzB/gAQhoeRAAqOdU4UPHD0cUV0ymmsbO3BQj9mPyYYbi
FRyVvCbsDpiyhPFTNWX7lKJYesW4V17kgxkiDNVGPmA7kJ/Yprqk6WAvzDs/Z/y1
VWXG1bcQ7uWbJk6nNKdgSp1fMh4YqLt7/6P4Nru0KXJylG/17s42GHeMplFZukan
qBoV/Ny6Z5yF7FvHsgt8lNLd1cULkBmqYdM2GvYwMuEdloafyQJrzUUYn4JmBSBs
Uv0JfD2YBmRkK6ySz+umjA4ADx3FLqGUoUaPFnDEQI+wD3g4Mq4OolwzIvB8T8GF
HSgq5ZUi+ttK5OZGnbrCuo+8nZQDD5/YdZiDBBmLlvLOfROn9eGCnYno/nS4i3Xo
3rzcP3/2IIVHdhmEAXW32lmHiIpzDsqKFoOPtOjrbSyKQxbaYOole5g1OraPF4aS
g0UX9WIiiCPiN+nZ5bckQ3GlHLNA6gb6HsaaUZEq+FDcSI+tLsRgSNiuWonoeOy4
eDIgvUdj/0euiWurcwM6Rpw0vlHfcCSsXWTkIybMBexcANk1J1vwhElhXyaX76HD
KTNEFD9IxtfdThjDqWYu6IOXZIKMj8lwVferLTwIBaylppLHfj3ZqCZZ/+s36T6p
HdvLDeZklpYYZglrW/LhMvocp2Ab7XKRkaOExYxhevcWFKo7fgEnLFzhBqWhdwhe
EFTc7temFXE=
=Fxl7
-----END PGP SIGNATURE-----

--Apple-Mail=_2B975651-DCCF-4E8D-B4D0-8B5C9DE51083--
