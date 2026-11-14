Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657831;
	b=kw40186Lv5ywptEWQvRHSP+pLKBWgcdlrFe8gnbXIvQoygKEAt8mGU/dnh9HVLZXqSxl
	 D3gfIsLdrT3xGBAIgE0IyZX+6bxmRhNV38YqIxSb80ej/5Ms+Vgi5vgYFWkXQebGdfi9A
	 JhXUQLB3QGM1mmh08bOzGPOo5p8xwpP3wDlIGokoeIwDwh9pfxIf/q2/50QNzM86r1D1R
	 NCjfcks0JWJuE7QhgmE4e0mbca26+qWP7sFIYGAKPnfVklDhOcx4mjsaUN/CAvKMQOpXY
	 V8ND+BnjlRs9vkhhN3JmuBJRIoV+BZfQOQTA6zeb2Zfxpgbf+llqgLWxnLSOYu7w2Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657831;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=En1pIhjDCbi5uQnQl7d6tI2Nsu015/E0bz+ywSlsPnE=;
	b=dld0w6oa8WWzCHy1MRh63x6YTPSvXnQ2k0sfC3EVEY3IBDuuC79/mt0CZDGPyciAXUta
	 Q+pRFVrjUJunz/L0WIJgDD7QM9oj/Gz5tp599m94xg/eQvIwkOdGQ6bxPbU4hB/2maMW0
	 j8u0z4qD2OvaP9GfNfH1uuofDYpODo34RgXMXauy6jfVNSAaDEpzH9pJwNmaXWRIvFMmd
	 1iayogaz8u2ixYlvZWjPOuTkBro6lQSGqABc45HRPnJSvn7MD/ewTqqspPAHz2Tl2n5Se
	 bAQDZtVfwprxdLOUjhMk3/t3+ohAwGFA6i4eZvGr90bvUQlox5jfvCoK9BdI+1U/z1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VeywEVYJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CEA606A323;
	Sat, 14 Nov 2026 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VeywEVYJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE21F000C9;
	Sat, 14 Nov 2026 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657830;
	bh=En1pIhjDCbi5uQnQl7d6tI2Nsu015/E0bz+ywSlsPnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VeywEVYJqBXdIqQauniLt4BbXJa9NUpolBn3UOhybWzaDzFI4ZaNrtiKQthduaCM3
	 7ScNtsc1tbnNvJ+FYgUaC4iULaL2ypvW+KMhPtsQlS3ePlnsfyOZeBjc97Ssxutkty
	 ssbhTAZfpqXmeeyJWgW2K/JHPxrFbrLydIehy2W6oxpc7Ev7qn0avjRo7la8YpNT8z
	 McyaKX0OiHh5UYGNU93CjDuwt1lUPO7gOwhZYMIT+7fxi40zctK6QLUgIlnpCBCtlY
	 5d8n/iZcLNVBe+FIP02ys6FjECfX0PDlklCu1NziY9uadmTKvuhrQM5iEB2snrlMG5
	 luOHrjHuITL5g==
Message-ID: <sashiko-outbox-214478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/33] gfs2: wait for a pending withdraw before
 remounting read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] gfs2: hang in gfs2_make_fs_ro() if withdraw occurs before
  SB_BORN
--

commit f8b5b1daf48e3f825a415215536a375fb6cd8b9d
Author: Christian Brauner <brauner@kernel.org>

gfs2: wait for a pending withdraw before remounting read-only

This commit serializes setting SDF_JOURNAL_LIVE in gfs2_make_fs_rw() with
do_withdraw() under sd_log_flush_lock, and makes gfs2_make_fs_ro() wait for
SDF_JOURNAL_LIVE to clear before calling gfs2_quota_cleanup().

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
>  	gfs2_quota_cleanup(sdp);
>  }

[Severity: High]
Can wait_on_bit() in gfs2_make_fs_ro() hang forever if a withdraw happens
during initial mount after gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE, but
before vfs_get_tree() sets SB_BORN?

During initial read-write mount, gfs2_fill_super() starts the logd and
quotad threads, registers the sysfs interface, and calls gfs2_make_fs_rw()
before SB_BORN is set on sb->s_flags.  If gfs2_withdraw() runs after
gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE and before vfs_get_tree() sets
SB_BORN, it sets SDF_WITHDRAWN and returns early without scheduling
sd_withdraw_work:

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

CPU0 (mount / remount)            CPU1 (kthread / workqueue / sysfs)
vfs_get_tree()
  ...
  gfs2_fill_super()
    gfs2_make_fs_rw()
      set_bit(SDF_JOURNAL_LIVE)
                                  gfs2_withdraw()
                                    test_and_set_bit(SDF_WITHDRAWN)
                                    if (!(s_flags & SB_BORN))
                                      return;
  sb->s_flags |=3D SB_BORN

gfs2_reconfigure()
  gfs2_make_fs_ro()
    gfs2_log_flush()
      if (gfs2_withdrawn(sdp))
        return;
    wait_on_bit(..., SDF_JOURNAL_LIVE, ...)
      <-- sleeps forever holding sb->s_umount

Because SDF_WITHDRAWN is already set, later calls to gfs2_withdraw() also
return early, so do_withdraw() never runs to clear SDF_JOURNAL_LIVE.  A
subsequent read-only remount bails out of gfs2_log_flush() and blocks
forever in wait_on_bit() with sb->s_umount held in write mode.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D27
