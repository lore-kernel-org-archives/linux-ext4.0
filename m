From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH -v2] ext4: optimize ext4_should_retry_alloc() to improve ENOSPC performance
Date: Tue, 7 Jun 2016 21:16:18 -0600
Message-ID: <6DCA443D-A279-4D7C-B76D-081DA0CF260A@dilger.ca>
References: <1465353418-12897-1-git-send-email-tytso@mit.edu> <1465354006-15091-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FD60875A-2540-4852-AEA3-4DF60F52D652"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36277 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbcFHDQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2016 23:16:25 -0400
Received: by mail-io0-f195.google.com with SMTP id f128so9646005iof.3
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2016 20:16:24 -0700 (PDT)
In-Reply-To: <1465354006-15091-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FD60875A-2540-4852-AEA3-4DF60F52D652
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 7, 2016, at 8:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> If there are pending blocks to be released after a commit, retrying
> the allocation after a journal commit has no hope of helping.  So
> track how many pending deleted blocks there might be, and don't retry
> if there are no pending blocks.
>=20
> Reported-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>=20
> Oops, ignore the earlier version of this patch.  I bobbled the commit
> and merged in part of another change.
>=20
> fs/ext4/balloc.c    |  9 ++++++++-
> fs/ext4/ext4.h      |  1 +
> fs/ext4/ext4_jbd2.h | 10 +++++++++-
> fs/ext4/mballoc.c   | 12 ++++++++++--
> 4 files changed, 28 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 3020fd7..371ac63 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -603,7 +603,14 @@ int ext4_claim_free_clusters(struct ext4_sb_info =
*sbi,
>  */
> int ext4_should_retry_alloc(struct super_block *sb, int *retries)
> {
> -	if (!ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
> +	unsigned int pending_blocks;
> +
> +	spin_lock(&EXT4_SB(sb)->s_md_lock);
> +	pending_blocks =3D EXT4_SB(sb)->s_mb_free_pending;
> +	spin_unlock(&EXT4_SB(sb)->s_md_lock);

Is there a benefit of having a spinlock here?  The read of free_pending
should be atomic.

Cheers, Andreas

> +
> +	if (pending_blocks =3D=3D 0 ||
> +	    !ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
> 	    (*retries)++ > 3 ||
> 	    !EXT4_SB(sb)->s_journal)
> 		return 0;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b84aa1c..96c73e6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1430,6 +1430,7 @@ struct ext4_sb_info {
> 	unsigned short *s_mb_offsets;
> 	unsigned int *s_mb_maxs;
> 	unsigned int s_group_info_size;
> +	unsigned int s_mb_free_pending;
>=20
> 	/* tunables */
> 	unsigned long s_stripe;
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 09c1ef3..b1d52c1 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -175,6 +175,13 @@ struct ext4_journal_cb_entry {
>  * There is no guaranteed calling order of multiple registered =
callbacks on
>  * the same transaction.
>  */
> +static inline void _ext4_journal_callback_add(handle_t *handle,
> +			struct ext4_journal_cb_entry *jce)
> +{
> +	/* Add the jce to transaction's private list */
> +	list_add_tail(&jce->jce_list, =
&handle->h_transaction->t_private_list);
> +}
> +
> static inline void ext4_journal_callback_add(handle_t *handle,
> 			void (*func)(struct super_block *sb,
> 				     struct ext4_journal_cb_entry *jce,
> @@ -187,10 +194,11 @@ static inline void =
ext4_journal_callback_add(handle_t *handle,
> 	/* Add the jce to transaction's private list */
> 	jce->jce_func =3D func;
> 	spin_lock(&sbi->s_md_lock);
> -	list_add_tail(&jce->jce_list, =
&handle->h_transaction->t_private_list);
> +	_ext4_journal_callback_add(handle, jce);
> 	spin_unlock(&sbi->s_md_lock);
> }
>=20
> +
> /**
>  * ext4_journal_callback_del: delete a registered callback
>  * @handle: active journal transaction handle on which callback was =
registered
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index c1ab3ec..77249e1 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2627,6 +2627,7 @@ int ext4_mb_init(struct super_block *sb)
>=20
> 	spin_lock_init(&sbi->s_md_lock);
> 	spin_lock_init(&sbi->s_bal_lock);
> +	sbi->s_mb_free_pending =3D 0;
>=20
> 	sbi->s_mb_max_to_scan =3D MB_DEFAULT_MAX_TO_SCAN;
> 	sbi->s_mb_min_to_scan =3D MB_DEFAULT_MIN_TO_SCAN;
> @@ -2814,6 +2815,9 @@ static void ext4_free_data_callback(struct =
super_block *sb,
> 	/* we expect to find existing buddy because it's pinned */
> 	BUG_ON(err !=3D 0);
>=20
> +	spin_lock(&EXT4_SB(sb)->s_md_lock);
> +	EXT4_SB(sb)->s_mb_free_pending -=3D entry->efd_count;
> +	spin_unlock(&EXT4_SB(sb)->s_md_lock);
>=20
> 	db =3D e4b.bd_info;
> 	/* there are blocks to put in buddy to make them really free */
> @@ -4583,6 +4587,7 @@ ext4_mb_free_metadata(handle_t *handle, struct =
ext4_buddy *e4b,
> {
> 	ext4_group_t group =3D e4b->bd_group;
> 	ext4_grpblk_t cluster;
> +	ext4_grpblk_t clusters =3D new_entry->efd_count;
> 	struct ext4_free_data *entry;
> 	struct ext4_group_info *db =3D e4b->bd_info;
> 	struct super_block *sb =3D e4b->bd_sb;
> @@ -4649,8 +4654,11 @@ ext4_mb_free_metadata(handle_t *handle, struct =
ext4_buddy *e4b,
> 		}
> 	}
> 	/* Add the extent to transaction's private list */
> -	ext4_journal_callback_add(handle, ext4_free_data_callback,
> -				  &new_entry->efd_jce);
> +	new_entry->efd_jce.jce_func =3D ext4_free_data_callback;
> +	spin_lock(&sbi->s_md_lock);
> +	_ext4_journal_callback_add(handle, &new_entry->efd_jce);
> +	sbi->s_mb_free_pending +=3D clusters;
> +	spin_unlock(&sbi->s_md_lock);
> 	return 0;
> }
>=20
> --
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_FD60875A-2540-4852-AEA3-4DF60F52D652
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV1eOA3Kl2rkXzB/gAQhgkA//fvPkpOYbiKKQ8qUw9eJolHN9q6hioKZk
MJDwBMNKoFOTZ3BeC4Si4gLFOPw6GfUF9dj7JI8hcYRVdiKEWgSSU9YseFfhqYAG
S64TSkGix8PNog5pDMAatMLlregMexHmydSPzd7MJLV/WZhWBUXl04vR5VRawBJJ
8ELu6gL+qktFLnhKRvqshK9GPXlOcYYsoWboW3QCSvUyS9vOlh+1igocD+1vdh1M
2s6ZUknfTaH2s+7hJYOqD+3Tvd9ro58vm4vpvghDjXggaXqeR3A98NnGcjIXX+nX
M8HkitTXbL5qqhbZrhzNrhvC/mCNaLNLxi86Ikhwtd6vhEMRyPgJA2BYayGEdZm8
DI4HVYDmPmfUSdLkbnPfelATzNu3O/CNiVj1n5hxJYawrgDPH+nrkvwog0b31TON
VB4rWjLq67lOnbWpJMVr9NVyq/Ig/wTcqjJJt/O2IfxuRJF28LPx08YMkWqHpkHt
7U6kbFZ+/v3qaIHVLD9gENSRG5y0ClGP95emzHS9EEvHxOrQNfOJxwtJ2TfywX2n
501zIiG2Hy2sjO0tK0tS8qE3GbWkFz/15ohDPUEkcVxtIuUxucR7OvnWxrb30KuR
EQWPM2p8KdmEpji9h1420NVN7f/flUmjdFSSoxO2gsgglnMQhGiNbFoxKR2C3PTK
UfLMq5pAkoQ=
=zlT2
-----END PGP SIGNATURE-----

--Apple-Mail=_FD60875A-2540-4852-AEA3-4DF60F52D652--
