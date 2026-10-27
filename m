Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793136780;
	b=uq4lnh6zVJzukig8H8gOZQ8wYax/pdym1gz6PfXh3CmrwVL7SpLrUNadDzPgAbC1zd6u
	 0Ep4El2qwxVvmQ2k/xptjzv3wCoKMFsMLhV8iIX51+UOrYcXPZts9XFPirQUydv5cpdSW
	 Tzh6wU3MmXje/21WsHUR0Jv59F4Q006Y9MojA7UnDjq9sVxTUPFCjkPmrTWQPm8tCEKlY
	 hDX429ebXXjdfOVfVeAvVlKuw2CatnmuarmuLfH8S8F8kpuO/EQLEKx1ISpYabdRzzrWV
	 yBxCE8oWD7twlg0oKg26RWIY9ZtCdNG1l5UxmJ7wUsYTWfLxMR+yrOMuj6IJFWXTqwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793136780;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZNwFHicQBSjxwNtaVTAS4sJS+YsbL94xf7l1R9dx5fM=;
	b=oaiSwHdOg3MEQcZkwrw+kWqtSCepfZlbDnT08SYodv1H9ronuwBdPKi0r+uF2VNtW5U9
	 f1OjUXLC92kJddU8FIbVxWdLHe4YpiDKxMKDF7J2aFbalt/WFwqtcNFzbzrvCMk/WZxFe
	 Dsb8lEIPWlIjFWBKcPPOTiPtRX+7cPbb+wkGqM95XU1ofLf0V9f55k41tSaZEU00Luvo0
	 Fm+mJM0DFaQtXcZcP87Jd827/TivH+8e6+l01C5QesRGVE09DWYSC1zNk7fA1hVfOH7AZ
	 ZgWAQIE0cXhKYkr+U/6ktkGnTAuqQp7JPjloMhCvtSEcX8pcH82WfrSzAeT6VzsRbjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogkuDeAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE5E606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogkuDeAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA401F01825;
	Tue, 27 Oct 2026 21:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136779;
	bh=ZNwFHicQBSjxwNtaVTAS4sJS+YsbL94xf7l1R9dx5fM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ogkuDeAegyrOpBFGHAQkLUeEdCFWTvOPYBnHnkZim7a/VQCmGubPLQERRPDyeiU7Y
	 kilnS9GKuH840pJvLJ3j3uNFJosKuqQD4q/lR6YJrws+dG9RYlmOiyCFmJesa4cROs
	 mGIPpVuJsvSiIDAI7KTMrUStJBVRDbXbgZeQRZubG073Z4IzQnwug1yXQJUecqs+ZQ
	 wGHihtDrmq7A7LkExNAu2PEIQtvno+x3slgY7v6HGv2wDAGJKutfPt6QiNuxm86D+2
	 gRla4x+Tg0Gn3m3IFYBAYqa/G+wzCXPL3uTFC4D+Bt+Ay4GOUjLLfLS+4IXRRY6j0T
	 /SNJor2UypCWQ==
Message-ID: <sashiko-outbox-187123@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/10] ovl: implement overlayfs' own ->write_inode
 operation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-7-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-7-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:32:59 +0000
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
- [Medium] ovl: missing read barrier in ovl_upper_unfinished()
--

commit f54ebddb1b6549b6ed1156d9609ee0d8a34e7718
Author: Chengguang Xu <charliecgxu@tencent.com>

ovl: implement overlayfs' own ->write_inode operation

This commit implements overlayfs's own ->write_inode() operation to sync
dirty data and metadata of the upper inode. It also keeps the overlay
inode marked dirty via ovl_upper_unfinished() while the upper inode is open
for writing or still has dirty or writeback pages.

> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d21e7cbb70c28..0aec7059e9da7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c

[ ... ]

> @@ -313,12 +315,62 @@ static int ovl_statfs(struct dentry *dentry, struct=
 kstatfs *buf)
>  	return err;
>  }
> =20
> +/*
> + * Could there be anything left to write or to wait for on @upper?
> + *
> + * Whoever has it open for writing may have it mapped, and stores throug=
h a
> + * mapping go unnoticed.  The mapping holds the file open.
> + *
> + * Writeback which was only started, by us or by the flusher of the upper
> + * filesystem, shows in the page cache tags until it is done.  The dirty=
 flags
> + * of the inode do not, they are cleared at the start.
> + *
> + * Metadata is not looked at.  The upper filesystem logs it, see
> + * ovl_tracks_dirty(), and ovl_sync_fs() has the log committed.
> + *
> + * Nothing orders these reads.  The one order which matters is to not see
> + * i_writecount at zero and miss the tag of a page which was dirtied thr=
ough
> + * the mapping.  The tag is set when the mapping goes away at the latest=
, the
> + * count drops when the file is released after that, with the locks of
> + * unmapping and of the final fput in between.
> + */
> +static bool ovl_upper_unfinished(struct inode *upper)
> +{
> +	struct address_space *mapping =3D upper->i_mapping;
> +
> +	return inode_is_open_for_write(upper) ||
> +	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
> +	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +	       (inode_state_read_once(upper) & I_SYNC);
> +}

[Severity: Medium]
Can ovl_upper_unfinished() still observe upper->i_writecount =3D=3D 0 while
missing PAGECACHE_TAG_DIRTY without a read barrier on the reader side?

The comment above ovl_upper_unfinished() notes that the critical ordering is
not to see i_writecount at zero and miss the dirty tag of a page dirtied
through a shared writable mapping, relying on the locks between unmapping
and the final fput on the writer side.

However, in ovl_upper_unfinished():
- inode_is_open_for_write(upper) performs a relaxed
  atomic_read(&upper->i_writecount)
- mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) performs a plain load of
  mapping->i_pages.xa_flags via xa_marked()

Consider the following race when background writeback runs
ovl_write_inode() -> write_inode_now(upper, false) while upper is initially
clean:

CPU 0                                 CPU 1
ovl_write_inode()
  write_inode_now(upper, false)
  ovl_upper_unfinished(upper)
                                      munmap() dirty shared mapping
                                        sets PAGECACHE_TAG_DIRTY in xa_flags
                                      close() -> __fput() -> put_file_acces=
s()
                                        atomic_dec(&upper->i_writecount)
    inode_is_open_for_write(upper)
    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)

Because there is no smp_rmb() or acquire barrier between reading
upper->i_writecount and reading mapping->i_pages.xa_flags on CPU 0, can the
compiler or a weakly-ordered CPU reorder the xa_flags load before the
i_writecount load, causing ovl_upper_unfinished() to return false and leave
the overlay inode clean while upper still has dirty pages that a subsequent
syncfs() will miss?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D7
