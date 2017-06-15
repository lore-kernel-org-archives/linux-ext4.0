From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 26/28] ext4: cleanup transaction restarts during inode
 deletion
Date: Wed, 14 Jun 2017 18:11:10 -0600
Message-ID: <A15C59A1-EC1C-4A58-927C-C086CD90A524@dilger.ca>
References: <20170531081517.11438-26-tahsin@google.com>
 <20170614141714.18330-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_21E2F609-C9A1-4984-BB5D-B34056988188";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170614141714.18330-1-tahsin@google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_21E2F609-C9A1-4984-BB5D-B34056988188
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 14, 2017, at 8:17 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> During inode deletion, journal credits that will be needed are hard to
> determine, that is why we have journal extend/restart calls in several
> places. Whenever a transaction is restarted, filesystem must be in a
> consistent state because there is no atomicity guarantee beyond a
> restart call.
>=20
> Add ext4_xattr_ensure_credits() helper function which takes care of
> journal extend/restart logic. It also handles getting jbd2 write =
access
> and dirty metadata calls. This function is called at every iteration =
of
> handling an ea_inode reference.

Another option that might be less complex is to just add the xattr =
inodes
to the orphan list in the main transaction (which should be a fixed =
number
of credits), and then truncate/unlink the xattr inodes after the main
transaction has completed rather than making the transactions =
arbitrarily
large.  At one point we even had a separate unlink thread to handle this
in the background to reduce the unlink latency for very large files, =
which
also avoids issues with nested transactions.

Cheers, Andreas

> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> v2: made ext4_xattr_ensure_credits() static
>=20
> fs/ext4/inode.c |  66 ++++-----------
> fs/ext4/xattr.c | 257 =
++++++++++++++++++++++++++++++++++++--------------------
> fs/ext4/xattr.h |   3 +-
> 3 files changed, 183 insertions(+), 143 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cf91532765a4..4d6936f0d8a4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -239,7 +239,11 @@ void ext4_evict_inode(struct inode *inode)
> 	 */
> 	sb_start_intwrite(inode->i_sb);
>=20
> -	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE, =
extra_credits);
> +	if (!IS_NOQUOTA(inode))
> +		extra_credits +=3D =
EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
> +
> +	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE,
> +				 =
ext4_blocks_for_truncate(inode)+extra_credits);
> 	if (IS_ERR(handle)) {
> 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
> 		/*
> @@ -251,36 +255,9 @@ void ext4_evict_inode(struct inode *inode)
> 		sb_end_intwrite(inode->i_sb);
> 		goto no_delete;
> 	}
> +
> 	if (IS_SYNC(inode))
> 		ext4_handle_sync(handle);
> -
> -	/*
> -	 * Delete xattr inode before deleting the main inode.
> -	 */
> -	err =3D ext4_xattr_delete_inode(handle, inode, &ea_inode_array);
> -	if (err) {
> -		ext4_warning(inode->i_sb,
> -			     "couldn't delete inode's xattr (err %d)", =
err);
> -		goto stop_handle;
> -	}
> -
> -	if (!IS_NOQUOTA(inode))
> -		extra_credits +=3D 2 * =
EXT4_QUOTA_DEL_BLOCKS(inode->i_sb);
> -
> -	if (!ext4_handle_has_enough_credits(handle,
> -			ext4_blocks_for_truncate(inode) + =
extra_credits)) {
> -		err =3D ext4_journal_extend(handle,
> -			ext4_blocks_for_truncate(inode) + =
extra_credits);
> -		if (err > 0)
> -			err =3D ext4_journal_restart(handle,
> -			ext4_blocks_for_truncate(inode) + =
extra_credits);
> -		if (err !=3D 0) {
> -			ext4_warning(inode->i_sb,
> -				     "couldn't extend journal (err %d)", =
err);
> -			goto stop_handle;
> -		}
> -	}
> -
> 	inode->i_size =3D 0;
> 	err =3D ext4_mark_inode_dirty(handle, inode);
> 	if (err) {
> @@ -298,25 +275,17 @@ void ext4_evict_inode(struct inode *inode)
> 		}
> 	}
>=20
> -	/*
> -	 * ext4_ext_truncate() doesn't reserve any slop when it
> -	 * restarts journal transactions; therefore there may not be
> -	 * enough credits left in the handle to remove the inode from
> -	 * the orphan list and set the dtime field.
> -	 */
> -	if (!ext4_handle_has_enough_credits(handle, extra_credits)) {
> -		err =3D ext4_journal_extend(handle, extra_credits);
> -		if (err > 0)
> -			err =3D ext4_journal_restart(handle, =
extra_credits);
> -		if (err !=3D 0) {
> -			ext4_warning(inode->i_sb,
> -				     "couldn't extend journal (err %d)", =
err);
> -		stop_handle:
> -			ext4_journal_stop(handle);
> -			ext4_orphan_del(NULL, inode);
> -			sb_end_intwrite(inode->i_sb);
> -			goto no_delete;
> -		}
> +	/* Remove xattr references. */
> +	err =3D ext4_xattr_delete_inode(handle, inode, &ea_inode_array,
> +				      extra_credits);
> +	if (err) {
> +		ext4_warning(inode->i_sb, "xattr delete (err %d)", err);
> +	stop_handle:
> +		ext4_journal_stop(handle);
> +		ext4_orphan_del(NULL, inode);
> +		sb_end_intwrite(inode->i_sb);
> +		ext4_xattr_inode_array_free(ea_inode_array);
> +		goto no_delete;
> 	}
>=20
> 	/*
> @@ -342,7 +311,6 @@ void ext4_evict_inode(struct inode *inode)
> 		ext4_clear_inode(inode);
> 	else
> 		ext4_free_inode(handle, inode);
> -
> 	ext4_journal_stop(handle);
> 	sb_end_intwrite(inode->i_sb);
> 	ext4_xattr_inode_array_free(ea_inode_array);
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 3ee7e2f68476..abc7d5f84e5f 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -108,6 +108,10 @@ const struct xattr_handler *ext4_xattr_handlers[] =
=3D {
> #define EXT4_GET_MB_CACHE(inode)	(((struct ext4_sb_info *) \
> 				inode->i_sb->s_fs_info)->s_mb_cache)
>=20
> +static int
> +ext4_expand_inode_array(struct ext4_xattr_inode_array =
**ea_inode_array,
> +			struct inode *inode);
> +
> #ifdef CONFIG_LOCKDEP
> void ext4_xattr_inode_set_class(struct inode *ea_inode)
> {
> @@ -653,6 +657,127 @@ static void =
ext4_xattr_update_super_block(handle_t *handle,
> 	}
> }
>=20
> +static int ext4_xattr_ensure_credits(handle_t *handle, struct inode =
*inode,
> +				     int credits, struct buffer_head =
*bh,
> +				     bool dirty, bool block_csum)
> +{
> +	int error;
> +
> +	if (!ext4_handle_valid(handle))
> +		return 0;
> +
> +	if (handle->h_buffer_credits >=3D credits)
> +		return 0;
> +
> +	error =3D ext4_journal_extend(handle, credits - =
handle->h_buffer_credits);
> +	if (!error)
> +		return 0;
> +	if (error < 0) {
> +		ext4_warning(inode->i_sb, "Extend journal (error %d)", =
error);
> +		return error;
> +	}
> +
> +	if (bh && dirty) {
> +		if (block_csum)
> +			ext4_xattr_block_csum_set(inode, bh);
> +		error =3D ext4_handle_dirty_metadata(handle, NULL, bh);
> +		if (error) {
> +			ext4_warning(inode->i_sb, "Handle metadata =
(error %d)",
> +				     error);
> +			return error;
> +		}
> +	}
> +
> +	error =3D ext4_journal_restart(handle, credits);
> +	if (error) {
> +		ext4_warning(inode->i_sb, "Restart journal (error %d)", =
error);
> +		return error;
> +	}
> +
> +	if (bh) {
> +		error =3D ext4_journal_get_write_access(handle, bh);
> +		if (error) {
> +			ext4_warning(inode->i_sb,
> +				     "Get write access failed (error =
%d)",
> +				     error);
> +			return error;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void
> +ext4_xattr_inode_remove_all(handle_t *handle, struct inode *parent,
> +			    struct buffer_head *bh,
> +			    struct ext4_xattr_entry *first, bool =
block_csum,
> +			    struct ext4_xattr_inode_array =
**ea_inode_array,
> +			    int extra_credits)
> +{
> +	struct inode *ea_inode;
> +	struct ext4_xattr_entry *entry;
> +	bool dirty =3D false;
> +	unsigned int ea_ino;
> +	int err;
> +	int credits;
> +
> +	/* One credit for dec ref on ea_inode, one for orphan list =
addition, */
> +	credits =3D 2 + extra_credits;
> +
> +	for (entry =3D first; !IS_LAST_ENTRY(entry);
> +	     entry =3D EXT4_XATTR_NEXT(entry)) {
> +		if (!entry->e_value_inum)
> +			continue;
> +		ea_ino =3D le32_to_cpu(entry->e_value_inum);
> +		err =3D ext4_xattr_inode_iget(parent, ea_ino, =
&ea_inode);
> +		if (err)
> +			continue;
> +
> +		err =3D ext4_expand_inode_array(ea_inode_array, =
ea_inode);
> +		if (err) {
> +			ext4_warning_inode(ea_inode,
> +					   "Expand inode array err=3D%d", =
err);
> +			iput(ea_inode);
> +			continue;
> +		}
> +
> +		err =3D ext4_xattr_ensure_credits(handle, parent, =
credits, bh,
> +						dirty, block_csum);
> +		if (err) {
> +			ext4_warning_inode(ea_inode, "Ensure credits =
err=3D%d",
> +					   err);
> +			continue;
> +		}
> +
> +		inode_lock(ea_inode);
> +		clear_nlink(ea_inode);
> +		ext4_orphan_add(handle, ea_inode);
> +		inode_unlock(ea_inode);
> +
> +		/*
> +		 * Forget about ea_inode within the same transaction =
that decrements the ref
> +		 * count. This avoids duplicate decrements in case the =
rest of the work
> +		 * spills over to subsequent transactions.
> +		 */
> +		entry->e_value_inum =3D 0;
> +		entry->e_value_size =3D 0;
> +
> +		dirty =3D true;
> +	}
> +
> +	if (dirty) {
> +		/*
> +		 * Note that we are deliberately skipping csum =
calculation for
> +		 * the final update because we do not expect any journal
> +		 * restarts until xattr block is freed.
> +		 */
> +
> +		err =3D ext4_handle_dirty_metadata(handle, NULL, bh);
> +		if (err)
> +			ext4_warning_inode(parent,
> +					   "handle dirty metadata =
err=3D%d", err);
> +	}
> +}
> +
> /*
>  * Release the xattr block BH: If the reference count is > 1, =
decrement it;
>  * otherwise free the block.
> @@ -1985,42 +2110,6 @@ ext4_expand_inode_array(struct =
ext4_xattr_inode_array **ea_inode_array,
> 	return 0;
> }
>=20
> -/**
> - * Add xattr inode to orphan list
> - */
> -static int
> -ext4_xattr_inode_orphan_add(handle_t *handle, struct inode *inode, =
int credits,
> -			    struct ext4_xattr_inode_array =
*ea_inode_array)
> -{
> -	int idx =3D 0, error =3D 0;
> -	struct inode *ea_inode;
> -
> -	if (ea_inode_array =3D=3D NULL)
> -		return 0;
> -
> -	for (; idx < ea_inode_array->count; ++idx) {
> -		if (!ext4_handle_has_enough_credits(handle, credits)) {
> -			error =3D ext4_journal_extend(handle, credits);
> -			if (error > 0)
> -				error =3D ext4_journal_restart(handle, =
credits);
> -
> -			if (error !=3D 0) {
> -				ext4_warning(inode->i_sb,
> -					"couldn't extend journal "
> -					"(err %d)", error);
> -				return error;
> -			}
> -		}
> -		ea_inode =3D ea_inode_array->inodes[idx];
> -		inode_lock(ea_inode);
> -		ext4_orphan_add(handle, ea_inode);
> -		inode_unlock(ea_inode);
> -		/* the inode's i_count will be released by caller */
> -	}
> -
> -	return 0;
> -}
> -
> /*
>  * ext4_xattr_delete_inode()
>  *
> @@ -2033,16 +2122,23 @@ ext4_xattr_inode_orphan_add(handle_t *handle, =
struct inode *inode, int credits,
>  */
> int
> ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
> -			struct ext4_xattr_inode_array **ea_inode_array)
> +			struct ext4_xattr_inode_array **ea_inode_array,
> +			int extra_credits)
> {
> 	struct buffer_head *bh =3D NULL;
> 	struct ext4_xattr_ibody_header *header;
> 	struct ext4_inode *raw_inode;
> -	struct ext4_iloc iloc;
> -	struct ext4_xattr_entry *entry;
> -	struct inode *ea_inode;
> -	unsigned int ea_ino;
> -	int credits =3D 3, error =3D 0;
> +	struct ext4_iloc iloc =3D { .bh =3D NULL };
> +	int error;
> +
> +	error =3D ext4_xattr_ensure_credits(handle, inode, =
extra_credits,
> +					  NULL /* bh */,
> +					  false /* dirty */,
> +					  false /* block_csum */);
> +	if (error) {
> +		EXT4_ERROR_INODE(inode, "ensure credits (error %d)", =
error);
> +		goto cleanup;
> +	}
>=20
> 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> 		goto delete_external_ea;
> @@ -2050,31 +2146,20 @@ ext4_xattr_delete_inode(handle_t *handle, =
struct inode *inode,
> 	error =3D ext4_get_inode_loc(inode, &iloc);
> 	if (error)
> 		goto cleanup;
> +
> +	error =3D ext4_journal_get_write_access(handle, iloc.bh);
> +	if (error)
> +		goto cleanup;
> +
> 	raw_inode =3D ext4_raw_inode(&iloc);
> 	header =3D IHDR(inode, raw_inode);
> -	for (entry =3D IFIRST(header); !IS_LAST_ENTRY(entry);
> -	     entry =3D EXT4_XATTR_NEXT(entry)) {
> -		if (!entry->e_value_inum)
> -			continue;
> -		ea_ino =3D le32_to_cpu(entry->e_value_inum);
> -		error =3D ext4_xattr_inode_iget(inode, ea_ino, =
&ea_inode);
> -		if (error)
> -			continue;
> -		error =3D ext4_expand_inode_array(ea_inode_array, =
ea_inode);
> -		if (error) {
> -			iput(ea_inode);
> -			brelse(iloc.bh);
> -			goto cleanup;
> -		}
> -		entry->e_value_inum =3D 0;
> -	}
> -	brelse(iloc.bh);
> +	ext4_xattr_inode_remove_all(handle, inode, iloc.bh, =
IFIRST(header),
> +				    false /* block_csum */, =
ea_inode_array,
> +				    extra_credits);
>=20
> delete_external_ea:
> 	if (!EXT4_I(inode)->i_file_acl) {
> -		/* add xattr inode to orphan list */
> -		error =3D ext4_xattr_inode_orphan_add(handle, inode, =
credits,
> -						    *ea_inode_array);
> +		error =3D 0;
> 		goto cleanup;
> 	}
> 	bh =3D sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> @@ -2092,46 +2177,32 @@ ext4_xattr_delete_inode(handle_t *handle, =
struct inode *inode,
> 		goto cleanup;
> 	}
>=20
> -	for (entry =3D BFIRST(bh); !IS_LAST_ENTRY(entry);
> -	     entry =3D EXT4_XATTR_NEXT(entry)) {
> -		if (!entry->e_value_inum)
> -			continue;
> -		ea_ino =3D le32_to_cpu(entry->e_value_inum);
> -		error =3D ext4_xattr_inode_iget(inode, ea_ino, =
&ea_inode);
> -		if (error)
> -			continue;
> -		error =3D ext4_expand_inode_array(ea_inode_array, =
ea_inode);
> -		if (error)
> -			goto cleanup;
> -		entry->e_value_inum =3D 0;
> -	}
> -
> -	/* add xattr inode to orphan list */
> -	error =3D ext4_xattr_inode_orphan_add(handle, inode, credits,
> -					*ea_inode_array);
> -	if (error)
> -		goto cleanup;
> -
> -	if (!IS_NOQUOTA(inode))
> -		credits +=3D 2 * EXT4_QUOTA_DEL_BLOCKS(inode->i_sb);
> -
> -	if (!ext4_handle_has_enough_credits(handle, credits)) {
> -		error =3D ext4_journal_extend(handle, credits);
> -		if (error > 0)
> -			error =3D ext4_journal_restart(handle, credits);
> +	if (ext4_has_feature_ea_inode(inode->i_sb)) {
> +		error =3D ext4_journal_get_write_access(handle, bh);
> 		if (error) {
> -			ext4_warning(inode->i_sb,
> -				"couldn't extend journal (err %d)", =
error);
> +			EXT4_ERROR_INODE(inode, "write access %llu",
> +					 EXT4_I(inode)->i_file_acl);
> 			goto cleanup;
> 		}
> +		ext4_xattr_inode_remove_all(handle, inode, bh,
> +					    BFIRST(bh),
> +					    true /* block_csum */,
> +					    ea_inode_array,
> +					    extra_credits);
> 	}
>=20
> 	ext4_xattr_release_block(handle, inode, bh);
> +	/* Update i_file_acl within the same transaction that releases =
block. */
> 	EXT4_I(inode)->i_file_acl =3D 0;
> -
> +	error =3D ext4_mark_inode_dirty(handle, inode);
> +	if (error) {
> +		EXT4_ERROR_INODE(inode, "mark inode dirty (error %d)",
> +				 error);
> +		goto cleanup;
> +	}
> cleanup:
> +	brelse(iloc.bh);
> 	brelse(bh);
> -
> 	return error;
> }
>=20
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index adf761518a73..b2005a2716d9 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -169,7 +169,8 @@ extern int ext4_xattr_set_credits(struct inode =
*inode, size_t value_len);
>=20
> extern int ext4_xattr_inode_unlink(struct inode *inode, unsigned long =
ea_ino);
> extern int ext4_xattr_delete_inode(handle_t *handle, struct inode =
*inode,
> -				   struct ext4_xattr_inode_array =
**array);
> +				   struct ext4_xattr_inode_array =
**array,
> +				   int extra_credits);
> extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array =
*array);
>=20
> extern int ext4_expand_extra_isize_ea(struct inode *inode, int =
new_extra_isize,
> --
> 2.13.1.508.gb3defc5cc-goog
>=20


Cheers, Andreas






--Apple-Mail=_21E2F609-C9A1-4984-BB5D-B34056988188
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZQdCfpIg59Q01vtYRAucqAJ9Wnl4PYdMQUMxTSYNmphjCo42NTQCfYZwv
MT7Dszoo/4uvxF2bt1d3x4w=
=FZ+1
-----END PGP SIGNATURE-----

--Apple-Mail=_21E2F609-C9A1-4984-BB5D-B34056988188--
