Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376610;
	b=V7+ulhDLStoB6Rm+SgReYUtAElwcwLIl/JdKh1hJgomsbCbcpPxQ4D3JaeNDXp3NIk1y
	 xokTqIhT26Cf/0AtSxFfminFUv7JV1EA+DWeOmCU/FCuOfisMy6lGM6RiBVb5hbLrJOoL
	 VT1TmHPLNqPM1qPW/1JVF4j0DC4F3X1/8/Gmr02gXGi29r6X1InQPVWCFhtnvpEDJtX4n
	 5lrycyxFIaF+wst1lhlsIbzvF3aeQXVwwRfgF52assz7Yr3FYz1IljCo0P4oqvbsJBBtE
	 JXFxdFEunCDK8TVFmJGYhLR6OD4xH/KYSiDYkrrsUmEqXTud9yVwf6N4uCe4l1k7Lzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376610;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BlBJcG/mHzd+bSxyJ7Hr/XNLqvI/KNeShi4TWVGpRMA=;
	b=hlqwOJ++mkxzFHzGdsY/IDjqePX+Ms8/zxAup/JBF+9fMknaCEgBzFxHeUdI8xkcro9L
	 iNHHoEvVMTp164O+rKkMoNWf9228NiW5wIW4Ow9+uN+vhgQN16MedicFE8ggO8chqYAXw
	 +ZdfhF5yKnUJSTaMiw9+5y5o7hhlL+SHdXvTArMb1NuD89LJ3ujWg9wL4S0d5i+Jwxmuv
	 nlKjr+63h801ZC97NoC0HiGukF2ZU/XKSiJN5wk0sBYHX//KxeL8Dsj5aFp0RiMe62Ry7
	 V2lvYFnoPBnNHGFNrqXeC4r7yO4fEhBBrUVGn7gzDqBYmAIY3XU0cn4/xiOozIlzB0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="D/AqvhRZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A09F606A32F;
	Fri, 30 Oct 2026 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D/AqvhRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966A51F0093A;
	Fri, 30 Oct 2026 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376610;
	bh=BlBJcG/mHzd+bSxyJ7Hr/XNLqvI/KNeShi4TWVGpRMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/AqvhRZy53z7cDhKwZsVvsyi75Y3cw4TMDVGVoQyGakjk6/Hsm81UrhNUKh8lpK8
	 9OBUprIEhacNJzUARTORbGE8nzZsXavQX5moSmXeTaHTkZg0biGi+Jqq1vzQ8hIp4Q
	 bZlIsaZimYR4kXUhi/DFZdAeGfQyf7aGvF73AiCDRIfGSsxgPHES329JutGW2yHMQ8
	 KW1CL+7VGZz7YAhF+HvmS3M2JC3WSkhoL0cTp/XUbv0QHMXiYciLVrdqjqlmmgFBfx
	 asrcDTboC/2rlsxegb+2YSDO8Mpp5zJoUWSQ9JVOWz/a8Y25DSqzSsW/oCD+/WLFCZ
	 r5eLPGGx33uZA==
Message-ID: <sashiko-outbox-191244@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/34] gfs2: wait for a pending withdraw before
 remounting read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:09 +0000
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
- [High] gfs2: hang in gfs2_make_fs_ro() if withdraw occurs before SB_BORN
--

commit 4dbc43efc316d1e6209f721b5c7c0e13b2e81f95
Author: Christian Brauner <brauner@kernel.org>

gfs2: wait for a pending withdraw before remounting read-only

This commit fixes a race between asynchronous filesystem withdraw and
read-only remount by synchronizing SDF_JOURNAL_LIVE under sd_log_flush_lock=
 in
gfs2_make_fs_rw(), waking waiters when do_withdraw() clears SDF_JOURNAL_LIV=
E,
and waiting for SDF_JOURNAL_LIVE to clear in gfs2_make_fs_ro() before calli=
ng
gfs2_quota_cleanup().

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 04bb4cf787d4d..f61c309368ef1 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
>  	}
> =20
>  	error =3D gfs2_quota_init(sdp);
> -	if (!error && gfs2_withdrawn(sdp)) {
> -		gfs2_quota_cleanup(sdp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Check for a withdraw under the lock do_withdraw() holds while it
> +	 * takes a live journal down, so one of them sees the other.
> +	 */
> +	down_write(&sdp->sd_log_flush_lock);
> +	if (gfs2_withdrawn(sdp))
>  		error =3D -EIO;
> -	}
> -	if (!error)
> +	else
>  		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> +	up_write(&sdp->sd_log_flush_lock);
> +	if (error)
> +		gfs2_quota_cleanup(sdp);
>  	return error;
>  }
> =20
> @@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
>  				   HZ * 5);
>  		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
>  	}
> +	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
> +	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
> +		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);

[Severity: High]
Can wait_on_bit() in gfs2_make_fs_ro() hang forever in TASK_UNINTERRUPTIBLE
if a withdraw happens after gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE during
mount, but before vfs_get_tree() sets SB_BORN?

During a read-write mount, vfs_get_tree() calls gfs2_get_tree() ->
get_tree_bdev_flags() -> gfs2_fill_super() before setting SB_BORN on
sb->s_flags. Inside gfs2_fill_super(), sysfs and the daemon threads are
started before gfs2_make_fs_rw() is called:

fs/gfs2/ops_fstype.c:gfs2_fill_super() {
	...
	if (!sb_rdonly(sb))
		error =3D gfs2_make_fs_rw(sdp);

	if (error) {
		gfs2_freeze_unlock(sdp);
		fs_err(sdp, "can't make FS RW: %d\n", error);
		goto fail_per_node;
	}
	gfs2_glock_dq_uninit(&mount_gh);
	gfs2_online_uevent(sdp);
	return 0;
}

Once gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE under sd_log_flush_lock, there
is still a window before vfs_get_tree() sets SB_BORN where gfs2_logd,
gfs2_quotad, glock workqueues, or sysfs can trigger gfs2_withdraw().

In gfs2_withdraw(), SDF_WITHDRAWN is set, and then it returns early without
queuing sd_withdraw_work because SB_BORN is not yet set:

fs/gfs2/util.c:gfs2_withdraw() {
	...
		if (test_and_set_bit(SDF_WITHDRAWN, &sdp->sd_flags))
			return;

		dump_stack();
		/*
		 * There is no need to withdraw when the superblock hasn't been
		 * fully initialized, yet.
		 */
		if (!(sdp->sd_vfs->s_flags & SB_BORN))
			return;
		fs_err(sdp, "about to withdraw this file system\n");
		schedule_work(&sdp->sd_withdraw_work);
	...
}

Because SDF_WITHDRAWN is already set, no later gfs2_withdraw() call can
queue sd_withdraw_work, and gfs2_fill_super() returns 0 with both
SDF_WITHDRAWN and SDF_JOURNAL_LIVE set while do_withdraw() never runs.

If the filesystem is subsequently remounted read-only via
gfs2_reconfigure() -> gfs2_make_fs_ro(), gfs2_log_flush() bails out early on
the withdrawn filesystem without clearing SDF_JOURNAL_LIVE, leaving
wait_on_bit() in gfs2_make_fs_ro() sleeping forever while holding
sb->s_umount.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D25
