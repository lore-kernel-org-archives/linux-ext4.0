Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321B03DAABD;
	Fri,  9 Oct 2026 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583680; cv=none; b=XZVBGJYgNVHLIBkzRWueTfu4wqGIprNXLZgybGDGPb/0/yyrvAEzUzNNJoD83V2qB05LWfmRzTS3jWKMQgcq8+OFg3zd7UTxL/2pJnviIJ+HNFtYDRudMlqePB/8xSmM+79N1flgKXPZ7J0yssoRFGOz9IT2UQhzP/g8jG3WHzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583680; c=relaxed/simple;
	bh=qLK4GYvyPJ0l5vosqxsqax1iw0hgZ1TvHVOJrEP+VQI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=h5LtPbresVE9D3CIpGBjW6FwndOBX5ekdpcbR3IDVOg2OJIJqINb6h9ie1zSpbMo/7HRxChekIIUtFL/RH39mZJLwy/O25coF/vrCpfw6RYY2pmKS8/4M0Z7QRQLdeZyF2I2LZKR3lAWZD61kazWnRYUR6In4SHeXSKgMl6oDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZYOajdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZYOajdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C181F000FF;
	Fri,  9 Oct 2026 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791583679;
	bh=EoTWyRJneR/OlpCaoajgmTS9kXXIhHP1c0GV1Dft92Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PZYOajdwb7RmfKsVTWz96c1ctT/fIpDHFVHDvL16q/3kFrckN8W5ZCC+8QE0+bS2D
	 FzKrKEHrEETbr3TmHn4lj68i3CeKIso+2oKEbNz75eLzANHl0evIQHTKO9xQgkUCem
	 kg4FK5uxFWDDYhkUN7r0ht7vW8uoY0jqUK6Jwt+bhEVq0MZq0fubwawLck2J2zjEXZ
	 hfq4OAOCf29xh1jTI+Zx7hXGrW9vKD0BA+yMLy2axt4+RWwrG2cUrR6ZGyQsruYtsK
	 LMbnQETOXEFxbVF6f0IAfrWDqXhhf9PKwd7vJDp8muk5hX7uZmMMhBDS5dJjilYz/x
	 Y33toWpmUk+DQ==
Message-ID: <sashiko-outbox-166125@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/8] afs: free the super info after a grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-work-fixes-rcu-v1-2-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-2-7446d2d335e6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 22:07:58 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] afs: TOCTOU race in afs_atcell_get_link() causes NULL dereference
--

commit 7e87d75fc751930aad8ea9a45c609797c83f1e6b
Author: Christian Brauner <brauner@kernel.org>

afs: free the super info after a grace period

afs_atcell_get_link() resolves the @cell and .@cell symlinks of a
dynamic root in rcu pathwalk mode. Before it looks at the dentry it gets
the afs_net through afs_i2net(), which reads ->net_ns from the
afs_super_info in sb->s_fs_info. The @cell dentries are kept around when
unused and the dynamic root has no ->d_revalidate(), so a lookup that
finds @cell in the dcache gets to ->get_link() in rcu mode.

afs_kill_super() frees the afs_super_info with a plain kfree() in
afs_destroy_sbi(). Right now a pathwalk can't still be in
afs_atcell_get_link() at that point, but only by accident. umount(2)
waits for a grace period in namespace_unlock() before it drops the
mount. And a mount whose last reference goes away elsewhere, like the
chdir out of a lazily unmounted directory, still gets a grace period
from bdi_unregister(). afs_fill_super() sets up a private bdi, so
generic_shutdown_super() unregisters it from kill_anon_super() and
bdi_remove_from_list() waits in synchronize_rcu_expedited() before
afs_destroy_sbi() runs. That grace period protects the rcu readers of
bdi_list in the writeback code. It has nothing to do with pathwalk.

Don't rely on it and free the afs_super_info after a grace period.

Fixes: 30bca65bbbae ("afs: Make /afs/@cell and /afs/.@cell symlinks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

[ ... ]

> diff --git a/fs/afs/super.c b/fs/afs/super.c
> index 82bb713825a0d..33b195821e36a 100644
> --- a/fs/afs/super.c
> +++ b/fs/afs/super.c
> @@ -523,7 +523,7 @@ static void afs_destroy_sbi(struct afs_super_info *as)
>  		afs_put_volume(as->volume, afs_volume_trace_put_destroy_sbi);
>  		afs_unuse_cell(as->cell, afs_cell_trace_unuse_sbi);
>  		put_net(as->net_ns);
> -		kfree(as);
> +		kfree_rcu(as, rcu);

[Severity: High]
Does this regression introduce a TOCTOU race in afs_atcell_get_link() that
can cause a NULL dereference?

By leaving put_net() executing before the RCU grace period, afs_net_exit() =
can
tear down the namespace while pathwalks are still active. If cleanup_net()
calls afs_cell_purge(), it replaces net->ws_cell with NULL.

Concurrently, a pathwalk in afs_atcell_get_link() can verify net->ws_cell is
non-NULL via rcu_access_pointer(), but the subsequent rcu_dereference() may
return NULL:

fs/afs/dynroot.c:afs_atcell_get_link() {
    ...
	if (!rcu_access_pointer(net->ws_cell))
		return ERR_PTR(-ENOENT);

	if (!dentry) {
		/* We're in RCU-pathwalk. */
		cell =3D rcu_dereference(net->ws_cell);
		if (dotted)
			name =3D cell->name - 1;
    ...
}

If the thread is preempted and afs_cell_purge() runs, could cell be NULL he=
re?

The same appears to happen in the non-RCU pathwalk:

fs/afs/dynroot.c:afs_atcell_get_link() {
    ...
	down_read(&net->cells_lock);

	cell =3D rcu_dereference_protected(net->ws_cell,
					 lockdep_is_held(&net->cells_lock));
	if (dotted)
		name =3D cell->name - 1;
	else
		name =3D cell->name;
    ...
}

Can net->ws_cell be cleared to NULL before the lock is acquired, causing a
NULL dereference here as well?

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-work-fixes=
-rcu-v1-0-7446d2d335e6@kernel.org?part=3D2
