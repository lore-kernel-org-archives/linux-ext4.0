Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376604;
	b=a/qqIU7tkFhLMWehKQCq9OELaeKgMD7QAQxq8hBhcz+9HPG/+Uom44t9Bu44Svt2Rqtk
	 pZu0C7CgipxSvTkZcRChUiKzMqNfHQBA/o4A9fdOa3Qz0VSKRFFroaNELMH4YQMAcyLdO
	 X3rY4OgkNjTg0o33gOoBcaAIX48f7Qcy6N1a6qfidi9Lg7XTLZ8o+p35AGrcR8MJXyH+q
	 QjQdLJFawDVSNtTOKIkDE5ai54sIUWncS1VH8YTBJMCnfeR0ZIOfMVAgT5AXEFzpBaQJr
	 XDpZ+7hWfLO47Pgrw8i+j50RTRqTNxurLVHWdmsCEuAG/x4uwmdJWGLt7MtlTQAuL4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376604;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v6Q73W+VdmnakUy7Y5elmMaCWEDdB23SrYHzIAMDn7g=;
	b=JWMMTrtHOSf69kEKocDcuYLwbSZALqbDBkHukhZlGQBUeRYQboRUiQvM+u66gIDTSP/m
	 p+X+PKXsuIGIhg+pxIIORS5rQdqSY6MqxPT0BPfxNxMrCxolzRaXGcFE4h5iI477AbFEM
	 JZZwGkU5IceyZUWgv6OtWLSaCc3wcImSh7yz6GT0mtEOM/SRj/ow9JOxBlE+2l1btzQV8
	 YEyUPRHnRPwiCztFD/eaXIsOhWb6kzqFoZQ0o30zSASSaoc0jedq1ejOm07OONKYJQVRc
	 UNSf57qv0jaNJcYoucszfjy8y0ImL/Mcj+Iqzf9YiEbEB4BIRht89RH0lmoccIS0Dug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BAF3VZkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD081606A338;
	Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BAF3VZkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1431F0093A;
	Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376603;
	bh=v6Q73W+VdmnakUy7Y5elmMaCWEDdB23SrYHzIAMDn7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BAF3VZkcESPBHNBLVO+30EPHzGf30kWo2ewHfgcMcy0jZo/r31QELbi3CpNQSemRk
	 3jFK0IS0u1K8btB8A4IZtH4bxRpuOgmyD/v0pMe1RDMYYMgCeikbG9p5MfYBp+aFIy
	 q5o2RcOwBTAlx0TKCDeLbm1S1Esxvcy7VxkzcSTuhRDKa2/OWC5ieOSS1A/RNedgjc
	 lv00s+NpcaSsuscaiBChDBuC3qDMvI+l7HDCHsaqNeum48k/ObujKmh1wZeDbFJ+4a
	 yiUQ9ThrQ9Ownz28NCXdyTMWXDUd7uT6q8giDsM/ukhvIcLJoyAzUrxqWXsNHtWgkF
	 vWVomann4IZOA==
Message-ID: <sashiko-outbox-191236@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] ntfs: missing ntfs_emergency_state() check in ntfs_drop_big_inod=
e()
- [Medium] ntfs: ntfs_trim_prealloc() mutates MFT records in emergency RO s=
tate
--

commit f2f6f70fa52c8d2d01384c57dde6822ea706a5e3
Author: Christian Brauner <brauner@kernel.org>

ntfs: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on filesystem errors when mounted wi=
th
errors=3Dremount-ro with a new NV_EmergencyRO volume flag and an
ntfs_emergency_state() helper so that freezing and thawing the superblock
does not leave s_writers locked. It also adds an error_work work item to
persist the dirty volume flag and updates write paths to check
ntfs_emergency_state().

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index b2f5882d9990d..fbfbd94c60924 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -55,9 +55,14 @@
>  int ntfs_file_open(struct inode *vi, struct file *filp)
>  {
>  	struct ntfs_inode *ni =3D NTFS_I(vi);
> +	int err;
> =20
> -	if (NVolShutdown(ni->vol))
> -		return -EIO;
> +	if (filp->f_mode & FMODE_WRITE)
> +		err =3D ntfs_emergency_state(ni->vol);
> +	else
> +		err =3D NVolShutdown(ni->vol) ? -EIO : 0;
> +	if (err)
> +		return err;

[Severity: Medium]
Should ntfs_trim_prealloc() (called from ntfs_file_release() and
ntfs_stream_file_release()) also check ntfs_emergency_state(vol) before
rolling back preallocated blocks?

When small writes in ntfs_file_write_iter() -> ntfs_expand_for_write() leave
ni->allocated_size larger than ni->data_size using trailing LCN_HOLE runlist
entries, and the volume subsequently enters NV_EmergencyRO or NV_Shutdown,
closing the open file descriptor invokes:

  ntfs_file_release()
    ntfs_trim_prealloc()
      ntfs_rl_truncate_nolock()
      ntfs_attr_update_mapping_pairs_locked()

Because neither function checks ntfs_emergency_state(vol), closing the file
mutates the runlist and MFT record mapping pairs and dirties the MFT record
and VFS inode even though __ntfs_write_inode() and ntfs_mft_writepages() now
refuse writeback with -EROFS or -EIO.

If the trailing hole run spanned an extent MFT record,
__ntfs_attr_update_mapping_pairs() -> ntfs_attr_record_rm() removes the
attribute and $ATTRIBUTE_LIST entry and then calls ntfs_mft_record_free(),
which now fails with -EROFS due to the new ntfs_emergency_state(vol) check,
leaving the extent partially removed and triggering secondary ntfs_error()
messages.

[ ... ]

> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index 206db4e99ef13..6219aed945dfc 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -2434,7 +2434,11 @@ void ntfs_evict_big_inode(struct inode *vi)
> =20
>  	truncate_inode_pages_final(&vi->i_data);
> =20
> -	if (!vi->i_nlink) {
> +	/*
> +	 * After an error the freed mft record would go out right away while
> +	 * the rest of the deletion can't, leave the inode to chkdsk.
> +	 */
> +	if (!vi->i_nlink && !ntfs_emergency_state(ni->vol)) {
>  		if (!NInoAttr(ni)) {
>  			/* Never called with extent inodes */
>  			WARN_ON(ni->nr_extents =3D=3D -1);

[Severity: Medium]
Does ntfs_drop_big_inode() need the same !ntfs_emergency_state(ni->vol) gua=
rd
when truncating unlinked inodes with I_SYNC set?

In fs/ntfs/inode.c:ntfs_drop_big_inode():

	if (!inode_unhashed(inode) && inode_state_read_once(inode) & I_SYNC) {
		if (ni->type =3D=3D AT_DATA || ni->type =3D=3D AT_INDEX_ALLOCATION) {
			if (!inode->i_nlink) {
				...
				truncate_setsize(VFS_I(ni), 0);
				ntfs_truncate_vfs(VFS_I(ni), 0, 1);

If an unlinked inode is undergoing writeback with I_SYNC set in
ntfs_writepages() or __ntfs_write_inode() when an error triggers
ntfs_handle_error() and sets NV_EmergencyRO (or in commit "ntfs: use the
generic emergency read-only state", SB_STATE_EMERGENCY_RO), dropping the la=
st
inode reference via iput() while I_SYNC is still held enters
ntfs_drop_big_inode().

Without checking !ntfs_emergency_state(ni->vol), ntfs_drop_big_inode() still
calls ntfs_truncate_vfs() -> __ntfs_attr_truncate_vfs() ->
ntfs_non_resident_attr_shrink() -> ntfs_cluster_free(), which frees clusters
in $Bitmap, fails partway through extent removal when ntfs_mft_record_free()
returns -EROFS, and on mounts with NVolDiscard issues blkdev_issue_discard()
on the file's clusters even though the on-disk MFT record and bitmap updates
cannot be written back for chkdsk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D17
