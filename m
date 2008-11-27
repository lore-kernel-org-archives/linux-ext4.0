From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Thu, 27 Nov 2008 15:57:46 +0800
Message-ID: <492E52FA.7070705@gmail.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com> <1226431111.4444.41.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8BC2B8C2719039BE6EAD68DC"
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:45125 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYK0H5z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 02:57:55 -0500
Received: by ti-out-0910.google.com with SMTP id b6so589587tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 23:57:53 -0800 (PST)
In-Reply-To: <1226431111.4444.41.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8BC2B8C2719039BE6EAD68DC
Content-Type: multipart/mixed;
 boundary="------------090104070507090802030906"

This is a multi-part message in MIME format.
--------------090104070507090802030906
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi, Frank

I somehow managed to apply your patch against v2.6.28-rc3 kernel. With
some small modifications, it worked just as supposed.

now, I have tested the modified patch in three ways, so far so good:
1. mount an ext2 fs image as ext4 and muck about with it. Then mount it
as ext2
2. unmark an ext4 image's has_journal flag and mount it as ext4, and
compile a kernel and delete all files on it.
3. mount a normal ext4 image, and compile a kernel and delete all files
on it.

Frank Mayhar wrote:
> =20
> +static inline int ext4_journal_max_transaction_buffers(struct inode *i=
node)
> +{
> +	/*
> +	 * max transaction buffers
> +	 * calculation based on
> +	 * journal->j_max_transaction_buffers =3D journal->j_maxlen / 4;
> +	 */
> +	if (EXT4_JOURNAL(inode) !=3D NULL)
> +		return (EXT4_JOURNAL(inode))->j_maxlen / 4;
> +	return 0;
> +}
I didn't see where/how this is used. So I dropped it.
> @@ -195,7 +203,8 @@
>  	handle_t *handle;
>  	int err;
> =20
> -	if (ext4_should_order_data(inode))
> +	if (EXT4_JOURNAL(inode) !=3D NULL &&
this is already checked in ext4_should_order_data(inode). So no need to
test it twice.
 > @@ -3493,7 +3503,7 @@
>  		 * the block was cleared. Check for this instead of OOPSing.
>  		 */
>  		if (bh2jh(this_bh))
> -			ext4_journal_dirty_metadata(handle, this_bh);
> +			ext4_handle_dirty_metadata(handle, inode, this_bh);
>  		else
>  			ext4_error(inode->i_sb, __func__,
>  				   "circular indirect block detected, "
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
one more check is needed here so that ext4_free_data doesn't print false
error messages in no-journal mode.
@@ -3515,7 +3515,7 @@ static void ext4_free_data(handle_t *handle,
struct inode *inode,
                 * block pointed to itself, it would have been detached w=
hen
                 * the block was cleared. Check for this instead of OOPSi=
ng.
                 */
-               if (bh2jh(this_bh))
+               if (!ext4_handle_valid(handle) || bh2jh(this_bh))
                        ext4_handle_dirty_metadata(handle, inode, this_bh=
);
                else
                        ext4_error(inode->i_sb, __func__,
> --- fs/ext4/mballoc.c#3
> +++ fs/ext4/mballoc.c
I noticed that one more change is needed here also.
@@ -2551,7 +2551,8 @@ int ext4_mb_init(struct super_block *sb, int
needs_recovery)
 	ext4_mb_init_per_dev_proc(sb);
 	ext4_mb_history_init(sb);

-	sbi->s_journal->j_commit_callback =3D release_blocks_on_commit;
+	if (sbi->s_journal)
+		sbi->s_journal->j_commit_callback =3D release_blocks_on_commit;

 	printk(KERN_INFO "EXT4-fs: mballoc enabled\n");
 	return 0;
> @@ -2484,6 +2513,8 @@
> {
>        struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>
> +       BUG_ON(sbi->s_journal =3D=3D NULL);
This will always trigger because at mount time sbi->s_journal is set
*after* ext4_get_journal when mounting ext4 image with journal.
> +
>       if (sbi->s_commit_interval)
>                journal->j_commit_interval =3D sbi->s_commit_interval;
>        /* We could also set up an ext4-specific default for the commit

--=20
Cheers,

Bergwolf

Here lieth one whose name was writ on water.




























--------------090104070507090802030906
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC45IChH
TlUvTGludXgpCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6Ly9l
bmlnbWFpbC5tb3pkZXYub3JnCgppRVlFQVJFQ0FBWUZBa2t1VW5FQUNna1FFeW55M1A0N2hG
RWU2QUNlT3hwdVQ3SHRkWkVkYzg0a3ZGZGg4WGxrCk1wOEFuamxyVVlXalNNOEx5ZU12cXNQ
RzU0N0tQMjFsCj0xOXFnCi0tLS0tRU5EIFBHUCBTSUdOQVRVUkUtLS0tLQoK
--------------090104070507090802030906--

--------------enig8BC2B8C2719039BE6EAD68DC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkuUvoACgkQEyny3P47hFGfVgCbBTBOgaTBZ7fp6KVzvArFGRwv
dO4An22zPXDemOwmMBesOHozZB2E1ikG
=PPCY
-----END PGP SIGNATURE-----

--------------enig8BC2B8C2719039BE6EAD68DC--
