Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E511DF748
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064782; cv=none; b=FtKLbVNbdD7Y1uAW/z7mXzn6mKs367FFmjyxBoSLO6Me3Oi2yPbttKZ78uLC+e5RFo/2AX+GFFqriUk+fi4ir3Ome14E4zZSKUWS2n9KCtoFywkPazJN0ThH+FcETYXxeyYR49ptVk05SlMVoL/Wql8iARm6qTd7YhazvXS8+lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064782; c=relaxed/simple;
	bh=jlWX0WFz6BTgmBQKVnQk1JLhW8VkEKr6j3FVadvzrAU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LBEdlMOtQgzggW7mtXN+qhoWkquckXO/ROye4mvDqwq0WmxHERv6kKPlsFhJAaP1jw+bQJhikmrf/JRwKbXcCrk/a/8C/uqEBBZpW6oMcgn/Be1IotZ88ZfgAwyVdg9eJqLZ+q9YNeB9a9RtEuXnyFLw0/31QPZrtBdN5285jHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFHgGmEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFHgGmEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C3A1F000E9;
	Sun, 30 Aug 2026 04:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064781;
	bh=Sl+oKlvR6grUAJr7/W3ijnK5a4SY/23ep3S9Twx1dWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JFHgGmEu471lIRnM++tVuZQkJOu0B/xtzbhzFLh4p5Et5EZb5kN6L4vxH8+A4TBma
	 4wePL43/HT2bN7qYUmvQh0VpyU6d95qTUbj+z0alVb/jfqOqsOEtwgHire5tv5O0gX
	 /fBA+L3L/+yvIdbr2tRpd+ziaEGr7KXN19uZtTQ07jb/d516L/rBF8hxaE/2nDWP6o
	 yFf8whQ9RjOGc8vU4TI0IDPwdFr9nSdzPUKkb7EvOJhNnjOxg821aKEnzuKNvkcOig
	 aKivS2LUJoilet45eXq8JmGLu2D5Y2j8BppZd9eEw51m9XEO+10C6zIwoI3B7Bwk9p
	 a5vgXyJ1G2osQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] ntfs: Remove FGP_NOFS from
 __ntfs_inode_resident_attr_pwrite()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, "Chuck Lever" <cel@kernel.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20260830041901.2668-6-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-6-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:39:40 +0000
Message-Id: <20260830043941.13C3A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Deadlock due to missing NOFS protection when allocating page cache=
 memory under mrec_lock
--

commit cf448ed1a05ff7894f41c5a1a1f1f6cc405004f7
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()

This commit removes the FGP_NOFS flag from the folio allocation in
__ntfs_inode_resident_attr_pwrite(). The commit message notes that if the
protection is needed, it should be done using memalloc_nofs_save() at a
higher level.

> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index 32edb4045178a..36a0d6b26c02e 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -3676,7 +3676,7 @@ static s64 __ntfs_inode_resident_attr_pwrite(struct=
 inode *vi,
>  	mark_mft_record_dirty(ctx->ntfs_ino);
> =20
>  	/* Keep the first page clean and uptodate */
> -	folio =3D __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio =3D __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,

[Severity: High]
Does removing FGP_NOFS here without adding the higher-level
memalloc_nofs_save() protection introduce a deadlock with flusher threads?

If a user writes a resident extended attribute via ntfs_setxattr(), the
call path acquires mrec_lock before reaching this allocation:

fs/ntfs/ea.c:ntfs_setxattr() {
    ...
    mutex_lock(&ni->mrec_lock);
    err =3D ntfs_set_ea(inode, name, strlen(name), value, size, flags, NULL=
);
    mutex_unlock(&ni->mrec_lock);
    ...
}

Without FGP_NOFS, the folio allocation can now occur with __GFP_FS enabled.
If the system is under memory pressure and blocks to wait for flusher
threads, those threads may attempt to write back pages for this NTFS
filesystem. The writeback path also unconditionally acquires the same
mrec_lock:

fs/ntfs/iomap.c:ntfs_write_iomap_begin_non_resident() {
    ...
    mutex_lock(&NTFS_I(inode)->mrec_lock);
    ...
}

Can this cause a cyclic deadlock on mrec_lock if the flusher thread blocks
waiting on the locked inode?

>  				   mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		err =3D PTR_ERR(folio);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D5
