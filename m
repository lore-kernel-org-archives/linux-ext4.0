Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458166;
	b=Ku5iPykVDMIgxTYSdcBp0u1ow9SD2XfG9HZXDjA8O/eFjlm2EUw2e8C8Nt++TicUFRpG
	 9BNCoeO/kZQrxSt7rCPxIcqlmpQ3TxseRWFKtsAlSs2jGTFp8vzzU1EDR03fM0fpPi91F
	 4JjduTK8R+roLn6LSb7vboTHwcu70CYe8sz7e5dppizqMSGEoVt6Ka+40cj2+UD6sAVz1
	 UZREurm1TcJY5cjjQfMqc4u8DAuTypiplyL6d6ah9bCdd83UsWL4cAikloDXJCo2xKfhw
	 7c5fVxmyZfe2hZQ1UGXlqtjnh3Rt94R0/htqiGfvUwSxXQ2Q/Z8jpId3xEIMUF+gXIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2Z8cgFNO5iRNuTOXm1aO8oKUKwScQqHp0nq3OmL/kvk=;
	b=T6QDIbU2bFsD5xbxgq7NRkpzeNaSHh1DoT+1UkG/Dzmak4nngoVRfaLmpSScJCQ7iBPS
	 NkK4OGgWMltFxTCK5Jb+d0TTNYTZFXHfCejiT4gw2q+DhDH8xv6HDfhKWYtfszehim+sP
	 Enb8Na7YYAFmhLk/9FlZvtPegq6aKmtlEYQmupHQMkK4g5SjSteWT7FsdZl9HadDoFTKG
	 FltJbJBfY6jOhigzPlNkOWcAum3lnjKR1f0ouFetdx3ieyOrOMcGRjCZts3oBC9cAb07e
	 XAA52RyXCPwixW6Q50e/f4AsO3/jZFvuzNsDH4XBqLTA96S/nzWmppooVkfbixeBsmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Upd+vKlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E02A606A8BE
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Upd+vKlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11E81F00A05;
	Thu, 12 Nov 2026 04:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458166;
	bh=2Z8cgFNO5iRNuTOXm1aO8oKUKwScQqHp0nq3OmL/kvk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Upd+vKlbR0QKAH1pt8OvljGObklhj/Vy/J2waEXX3LOqrayQSBr68R+EqBiLzP7Xa
	 IqiCNQmYRf3sa1E1rg78hTQ2DRmZPjw4s10iGw2/O/gEjXRUx4+0m35qSE6EIY55mn
	 l7XcVQz/j7YQRWWcJ15WPLexEedd2hWquvX7yWIZYqbhjLSdPV4Rf0hMiI4UPdz1yp
	 K2//iVK8AJ1u6rSVeL632ASqP6g6CG8e47mgeuRFhW6x479aZW7jFjmz0kGsHlHBa2
	 9Dg+fU+r84fA4YDeb4hi8iz7/a14XsmzD7Rp8u0dcIfcigj7+jR5/Jukv/ATT8Q7vD
	 k3MzeCMosxUpw==
Message-ID: <sashiko-outbox-210367@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/27] ext4: expand KUnit tests for fs/ext4/inode.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-11-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-11-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:36:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4: use-after-free of mock superblock and inodes in
  inode_test_cleanup()
- [Medium] ext4: highmem NULL deref on bh->b_data in
  inode_test_read_bh_lock_stub()
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [Medium] ext4: user-triggerable WARN_ON_ONCE in ext4_iomap_begin() [1]
- [Critical] ext4: stale data leak to concurrent readers in
  ext4_setattr() [2]
--

commit f093b56ce7ca8d901aefc501ae9f381a7877b64a
Author: Theodore Ts'o <tytso@mit.edu>

ext4: expand KUnit tests for fs/ext4/inode.c

This commit expands the ext4_inode_test KUnit test suite to exercise
fs/ext4/inode.c using an in-memory VFS superblock and mock block pool, and
adds KUnit static stub redirects and symbol exports for the tested entry
points.

> diff --git a/fs/ext4/inode-test.c b/fs/ext4/inode-test.c
> index 749af7ad4e09c..e8d19c1d42707 100644
> --- a/fs/ext4/inode-test.c
> +++ b/fs/ext4/inode-test.c
> @@ -267,8 +284,3432 @@ static void inode_test_xtimestamp_decoding(struct =
kunit *test)

[ ... ]

> +static void inode_test_read_bh_nowait_stub(struct buffer_head *bh,
> +					   blk_opf_t op_flags,
> +					   bio_end_io_t end_io,
> +					   bool simu_fail)
> +{
> +	struct kunit *test =3D kunit_get_current_test();
> +	struct inode_test_ctx *ctx =3D test ? test->priv : NULL;
> +	struct inode_test_blk *slot;
> +
> +	if (!ctx) {
> +		unlock_buffer(bh);
> +		return;
> +	}
> +	ctx->read_nowait_calls++;
> +	if (ctx->fail_read_eio || simu_fail) {
> +		clear_buffer_uptodate(bh);
> +		unlock_buffer(bh);
> +		return;
> +	}
> +	slot =3D inode_test_find_blk_by_bh(ctx, bh);
> +	if (!slot)
> +		slot =3D inode_test_find_blk(ctx, bh->b_blocknr);
> +	if (slot) {
> +		memcpy(bh->b_data, slot->disk_buf, bh->b_size);
> +		set_buffer_uptodate(bh);
> +	} else {
> +		clear_buffer_uptodate(bh);
> +	}
> +	unlock_buffer(bh);
> +}
> +
> +static int inode_test_read_bh_lock_stub(struct buffer_head *bh,
> +					blk_opf_t op_flags, bool wait)
> +{
> +	struct kunit *test =3D kunit_get_current_test();
> +	struct inode_test_ctx *ctx =3D test ? test->priv : NULL;
> +	struct inode_test_blk *slot;
> +
> +	if (!ctx)
> +		return -EIO;
> +	ctx->read_lock_calls++;
> +	lock_buffer(bh);
> +	if (ctx->fail_read_eio) {
> +		clear_buffer_uptodate(bh);
> +		unlock_buffer(bh);
> +		return wait ? -EIO : 0;
> +	}
> +	slot =3D inode_test_find_blk_by_bh(ctx, bh);
> +	if (!slot)
> +		slot =3D inode_test_find_blk(ctx, bh->b_blocknr);
> +	if (!slot) {
> +		clear_buffer_uptodate(bh);
> +		unlock_buffer(bh);
> +		return wait ? -EIO : 0;
> +	}
> +	memcpy(bh->b_data, slot->disk_buf, bh->b_size);
> +	set_buffer_uptodate(bh);
> +	unlock_buffer(bh);
> +	return 0;
> +}

[Severity: Medium]
Can copying directly to bh->b_data in inode_test_read_bh_lock_stub() and
inode_test_read_bh_nowait_stub() cause a NULL or low-address pointer
dereference on 32-bit CONFIG_HIGHMEM=3Dy kernels?

inode_test_setup() configures inode->i_data with GFP_HIGHUSER_MOVABLE.
When inode_test_zero_partial_and_eof() or inode_test_setattr() calls
ext4_zero_partial_blocks() -> ext4_block_zero_range() -> ext4_load_tail_bh(=
),
the pagecache folio allocated for inode->i_mapping can come from highmem.
create_empty_buffers() -> folio_set_bh() sets bh->b_data on a highmem folio
to (char *)(0 + offset) rather than a kernel virtual address, so
memcpy(bh->b_data, ...) faults when ext4_load_tail_bh() calls
ext4_read_bh_lock().  Using memcpy_to_folio(bh->b_folio, bh_offset(bh), ...)
when bh->b_folio is present (or dropping __GFP_HIGHMEM from inode->i_data)
would avoid this.

[ ... ]

> +static void inode_test_cleanup(void *data)
> +{
> +	struct inode_test_ctx *ctx =3D data;
> +	struct inode *inode =3D &ctx->ei.vfs_inode;
> +	struct mapping_metadata_bhs *mmb;
> +	unsigned int i;
> +
> +	ctx->sbi.s_journal =3D NULL;
> +
> +	for (i =3D 0; i < ctx->nr_tracked_inodes; i++) {
> +		struct inode *ti =3D ctx->tracked_inodes[i];
> +
> +		if (ti) {
> +			spin_lock(&ti->i_lock);
> +			inode_state_clear(ti, I_DIRTY_TIME);
> +			spin_unlock(&ti->i_lock);
> +			iput(ti);
> +			ctx->tracked_inodes[i] =3D NULL;
> +		}
> +	}
> +	ctx->nr_tracked_inodes =3D 0;
> +
> +	truncate_inode_pages_final(&inode->i_data);
> +	inode_io_list_del(inode);
> +	ext4_fc_del(inode);
> +	mmb =3D ext4_i_metadata_bhs(inode);
> +	if (mmb)
> +		mmb_invalidate(mmb);
> +	inode_test_cleanup_ext4_trees(inode);
> +	if (ctx->ei.jinode) {
> +		jbd2_free_inode(ctx->ei.jinode);
> +		ctx->ei.jinode =3D NULL;
> +	}
> +
> +	deactivate_super(ctx->sb);
> +	rcu_barrier();
> +
> +	ext4_es_unregister_shrinker(&ctx->sbi);
> +	percpu_counter_destroy(&ctx->sbi.s_dirtyclusters_counter);
> +	percpu_counter_destroy(&ctx->sbi.s_freeclusters_counter);
> +
> +	kfree(mmb);
> +	kfree(ctx);
> +}
> +
> +static struct inode_test_ctx *inode_test_setup(struct kunit *test)
> +{
> +	struct inode_test_ctx *ctx;
> +	struct fs_context *fc;
> +	struct super_block *sb;
> +	struct ext4_sb_info *sbi;
> +	struct inode *inode;
> +	int err, i;
> +
> +	ctx =3D kzalloc_obj(*ctx);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +	test->priv =3D ctx;
> +
> +	fc =3D fs_context_for_mount(&inode_test_fs_type, 0);
> +	if (IS_ERR(fc)) {
> +		err =3D PTR_ERR(fc);
> +		kfree(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	sb =3D sget_fc(fc, NULL, set_anon_super_fc);
> +	put_fs_context(fc);
> +	if (IS_ERR(sb)) {
> +		err =3D PTR_ERR(sb);
> +		kfree(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	ctx->sb =3D sb;
> +	sbi =3D &ctx->sbi;
> +
> +	sbi->s_sb =3D sb;
> +	sb->s_fs_info =3D sbi;
> +	sb->s_op =3D &inode_test_sops;
> +#ifdef CONFIG_QUOTA
> +	sb->dq_op =3D &inode_test_qops;
> +#endif
> +	sb->s_flags |=3D SB_ACTIVE;

[Severity: Medium]
Can setting SB_ACTIVE while leaving sb->s_root NULL cause a use-after-free
of ctx->sb, ctx->sbi, and inodes after inode_test_cleanup() runs?

sget_fc() -> alloc_super() calls fserror_mount(sb), which sets
sb->s_pending_errors to 1.  When tests exercise corruption paths that call
__ext4_error() or __ext4_error_inode(), fserror_report() sees SB_ACTIVE and
s_pending_errors > 0, takes a reference on the inode via igrab(), and queues
fserror_worker() on system_dfl_wq.  Because ctx->sb->s_root is NULL,
deactivate_super() -> generic_shutdown_super() skips fserror_unmount(sb):

CPU0 (KUnit test)                 CPU1 (kworker)
inode_test_iget_corruptions()
  ext4_iget()
    __ext4_error_inode()
      fserror_report()
        igrab(inode)
        schedule_work(&event->work)
inode_test_cleanup()
  deactivate_super(ctx->sb)
    generic_shutdown_super()
      /* s_root is NULL: skips
         fserror_unmount() */
  kfree(ctx)
                                  fserror_worker()
                                    /* accesses freed event->sb */
                                    iput(event->inode)
                                      ext4_evict_inode()
                                        /* accesses freed ctx->sbi */
                                        <-- use-after-free

In addition, when __ext4_error_inode() is called on the embedded
&ctx->ei.vfs_inode (for example in inode_test_expand_extra_isize()),
fserror_worker() races with inode_test_reset_mock_inode() and calls iput()
on the embedded inode after ctx is freed.  Calling fserror_unmount(sb) in
inode_test_setup() (or before freeing ctx in inode_test_cleanup()) would
prevent fserror_report() from queuing async work.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 67d37b39db938..98444d8ddb400 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -3858,12 +3888,14 @@ int ext4_iomap_begin(struct inode *inode, loff_t =
offset, loff_t length,
> =20
>  	return 0;
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_iomap_begin);

[Severity: Medium]
This problem wasn't introduced by this patch, but can an atomic write to an
encrypted file trigger WARN_ON_ONCE(1) in ext4_iomap_begin() [1]?

Before checking the IOMAP_ATOMIC length constraint, ext4_iomap_begin()
calls fscrypt_limit_io_blocks() to truncate map.m_len when an I/O crosses a
32-bit DUN boundary:

fs/ext4/inode.c:ext4_iomap_begin() {
    ...
	map.m_len =3D fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);

	/*
	 * Before returning to iomap, let's ensure the allocated mapping
	 * covers the entire requested length for atomic writes.
	 */
	if (flags & IOMAP_ATOMIC) {
		if (map.m_len < (length >> blkbits)) {
			WARN_ON_ONCE(1);
			return -EINVAL;
		}
	}
    ...
}

When an unprivileged user issues an atomic write across a DUN boundary on
an encrypted file, fscrypt_limit_io_blocks() shortens map.m_len below
length >> blkbits and triggers WARN_ON_ONCE(1).

[ ... ]

> @@ -6274,6 +6322,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct de=
ntry *dentry,
>  		error =3D rc;
>  	return error;
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_setattr);

[Severity: Critical]
This problem wasn't introduced by this patch, but when extending a file via
ext4_setattr(), can updating i_size before calling
pagecache_isize_extended() expose stale post-EOF pagecache data to
concurrent readers [2]?

When extending a file whose old size is block-aligned (or where blocksize <
PAGE_SIZE) and whose tail folio already has uptodate post-EOF data in the
pagecache (such as from an earlier mmap write past EOF), ext4_setattr()
writes the new i_size under i_data_sem before stopping the journal handle
and zeroing the extended pagecache range:

CPU0                              CPU1
ext4_setattr()
  i_size_write(inode, attr->ia_size)
                                  generic_file_read_iter()
                                    filemap_read()
                                      /* sees new i_size and copies
                                         unzeroed tail folio <-- stale data=
 */
  ext4_journal_stop(handle)
  pagecache_isize_extended()

Because buffered reads do not take i_rwsem, CPU1 can read the unzeroed
post-EOF portion of the folio before pagecache_isize_extended() zeroes it.

[1] https://sashiko.dev/#/bug/linux-38b43030-f0ce-4abf-8653-7266f768a948
[2] https://sashiko.dev/#/bug/linux-808e5d6d-ae12-4689-877c-3d6dc1f711d5

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D10
