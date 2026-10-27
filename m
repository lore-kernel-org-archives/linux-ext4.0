Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793136333;
	b=2kxubIW7IbGW/7C3PGOvsMzND1C+THZ2xBPUT3Mi8Wu9VjBmq8VumkqWXfXqQ9vwGSiO
	 LQfJqsD9YxsalR1vjMGpxoGEyaMjHrLt00tFYQn0hYrcBC20c1xFywlIumOsIR+mD/rX7
	 tMnH0Repo9j/ebHrq0ZUq4mjgxAf3CLMUClXU1ZUm5ceWSKKW1esZQpwchmFIa59in8KK
	 iiNAM3G+DSd7NkJfkym/43pwLCmd1bbqIIJ+2RuFNn3UA3bWbVNcNVaPKxeLm01KUWj+N
	 jVhdMqljTcPMI6Ok/+oQEIX63yzWqOYEHtzfuC5+iZxYjl9fiYTfkfVKHctWjTqFNOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793136333;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=b4KVFtARTFsrsh/C6khtrrmAnV8IUt8SZ28m7czEQ+g=;
	b=GBHUso62QSv6ILOP9M7hkkL8WtAzXEtcyEIX5yC5/FaeENvo/rpMHP9os/6LFpqGO4WM
	 yaIexEs5psCVVgeOY9qAlwTBgYC6acsZcOoJYVMdqo8m6YGC87N1lSnlZntBgp9BQ+61f
	 KKrniXHI2QpxONIq19wVhgiuX89UDPCOdchQR2Trcg8d9epHEOdCYM3F7LmfWNfzsjdaK
	 K0a95Uo+eX4Y9iJwRjw+ptR4kyUhM4P+xbLXVE4fBFADGebQfa0ew2s70bIVgejPeWqgp
	 3CM6bzNEkZT7iyL+rGMRQv0ohsx6MmEXGMweSoi1mZowZh6P4xtuMz1QUX3o8lp2tkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTHGDcrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A3606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTHGDcrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0546C1F01825;
	Tue, 27 Oct 2026 21:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136333;
	bh=b4KVFtARTFsrsh/C6khtrrmAnV8IUt8SZ28m7czEQ+g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QTHGDcrEfuyP4okWaY0ZPi9T1r31QtfistUr04s5kHrVwPdd1tH4UIYlG/6tP5q8Q
	 ZVQlRcIaK1JRbrnmByYo6LZ7dzxKC2y9yg2Iiew8o+eNjV6KTr9jywti2rX7ls/fsR
	 PXhVTzDvMgdo+5zCGdP62P1DAF3sbjDbSLzWdSVjPQ1LNAflr91/GC4yHL0Ibfsj6u
	 Uk07uJiUOEUZoDVzk5jOLW8V2x7JoDR4IISGLdQhsga8PhY2eV/p5K9B74FQHc9m+h
	 8QiUOWcHLzOrrjJW+TS3Cgd88hTmUbpTpRnjaoX9YwC3aCaF9pesMXqlHZLzAmhtVx
	 MA+BO4sHCF/Hw==
Message-ID: <sashiko-outbox-187119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/10] ovl: mark the overlay inode dirty on modification
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-6-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-6-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:25:32 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ovl: hash inode before publishing upperdentry in ovl_inode_updat=
e()
--

commit 53ca5c8437292ff03846e00c2b5c4e07c6ba3c86
Author: Josef Bacik <josef@toxicpanda.com>

ovl: mark the overlay inode dirty on modification

This commit marks the overlay inode dirty whenever its upper inode is
modified through the overlay, placing the overlay inode on the overlay
bdi dirty list when SB_I_OVL_USE_SYNC_FS is set on the upper superblock.

Link: https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.n=
et

> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 521717209b2e4..e7402459548ee 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -604,6 +604,8 @@ void ovl_inode_update(struct inode *inode, struct den=
try *upperdentry)
>  		inode->i_private =3D upperinode;
>  		__insert_inode_hash(inode, (unsigned long) upperinode);
>  	}
> +	/* The copy up has written to the upper inode */
> +	ovl_mark_inode_dirty(inode);
>  }

[Severity: Medium]
Can a concurrent ovl_update_time() call mark the overlay inode dirty while
it is still unhashed in ovl_inode_update(), preventing it from ever being
added to the bdi dirty list?

When a lower non-directory file with i_nlink > 1 is looked up with
index=3Doff, ovl_get_inode() allocates the overlay inode via new_inode()
without hashing it:

fs/overlayfs/inode.c:ovl_get_inode() {
	...
	} else {
		/* Lower hardlink that will be broken on copy up */
		inode =3D new_inode(sb);
		if (!inode) {
			err =3D -ENOMEM;
			goto out_err;
		}
		ino =3D realinode->i_ino;
		fsid =3D lowerpath->layer->fsid;
	}
	...
}

When this inode is later copied up, ovl_inode_update() publishes
OVL_I(inode)->__upperdentry before calling __insert_inode_hash():

fs/overlayfs/util.c:ovl_inode_update() {
	...
	smp_wmb();
	OVL_I(inode)->__upperdentry =3D upperdentry;
	if (inode_unhashed(inode)) {
		inode->i_private =3D upperinode;
		__insert_inode_hash(inode, (unsigned long) upperinode);
	}
	/* The copy up has written to the upper inode */
	ovl_mark_inode_dirty(inode);
}

Because ovl_update_time() runs without OVL_I(inode)->lock or
inode->i_rwsem, a concurrent atime update (for example via
ovl_file_accessed() -> touch_atime() -> ovl_update_time()) can observe
the newly published __upperdentry and call ovl_mark_inode_dirty(inode)
before __insert_inode_hash() runs:

fs/overlayfs/inode.c:ovl_update_time() {
	if (type =3D=3D FS_UPD_ATIME) {
		struct ovl_fs *ofs =3D OVL_FS(inode->i_sb);
		struct path upperpath =3D {
			.mnt =3D ovl_upper_mnt(ofs),
			.dentry =3D ovl_upperdentry_dereference(OVL_I(inode)),
		};

		if (upperpath.dentry) {
			if (flags & IOCB_NOWAIT)
				return -EAGAIN;
			touch_atime(&upperpath);
			inode_set_atime_to_ts(inode,
					      inode_get_atime(d_inode(upperpath.dentry)));
			ovl_mark_inode_dirty(inode);
		}
	}
	return 0;
}

In fs/fs-writeback.c:__mark_inode_dirty(), calling mark_inode_dirty() on
an unhashed inode sets I_DIRTY in inode->i_state and then bails out at
inode_unhashed(inode) without adding the inode to wb->b_dirty:

fs/fs-writeback.c:__mark_inode_dirty() {
	if ((inode_state_read_once(inode) & flags) =3D=3D flags)
		return;

	spin_lock(&inode->i_lock);
	if ((inode_state_read(inode) & flags) !=3D flags) {
		...
		inode_state_set(inode, flags);
		...
		if (!S_ISBLK(inode->i_mode)) {
			if (inode_unhashed(inode))
				goto out_unlock;
		}
		...
	}
}

Once I_DIRTY is set in inode->i_state, the subsequent
ovl_mark_inode_dirty(inode) call in ovl_inode_update() (as well as any
future ovl_mark_inode_dirty() calls on that inode) will see the flags
already set and return early without queuing the inode on wb->b_dirty.

Should ovl_inode_update() hash the inode before setting
OVL_I(inode)->__upperdentry so that __upperdentry is never visible on an
unhashed overlay inode?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D6
