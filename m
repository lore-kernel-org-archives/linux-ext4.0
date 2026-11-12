Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457005;
	b=FqdFFozPdpNsswUARzzthlSGWXNnaU+tmTSV896y2XFQwDZKlCU27Y+VvlN58ZuCS7VK
	 qzTkJ1JNMbSjOJXjL5w3tC6tSHaHMlYOJ5/Y0rpqdi3KtgHbQKwbCpW/OZnawfUVoLIsf
	 diKWSzgZD41ZtCdcSyh34D6eGGX5uPnrA0r27+mjMMUzZeHzp2OS+K6gZqlKXUEe8ykma
	 JXZdsBMRx23NCvuF3PM+DgmzaOqXKYlWZKhniM4F9NhO6DnsaEJULsYzDSRw2mzGs3beM
	 MllpKT3TMhpRc3IlO8CB1fJG36MMN+7zR8VYOsw5apFAI9eXqCrp/fKE15shGKKDtKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457005;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NPinxNrgqhhOwTcTygVDbonKQ//XTcODyloMqhzSlqY=;
	b=nErPIT4OsOGMFxR1KgExgSwSsajnVK5lyND6DfYfqvoch2dRkjYF0lMtAPXzDA/qukfR
	 D+W+S03rEDWAuTTVLKLaLdhnt1Nh785RkTBa9XtecMwbXn/vKabuEPAW4BWnT4SVRQfI3
	 qGjE5oc3TtCxLFL+mgi8bhgVOguO9A7ErpgpV+axczOkv7L0QFaLAg6kCPJ9J+ZKXmSAb
	 H2vQ4LiM4wTEghTf+sknQK94mNua+hA/PSU6LwtOQnzWIla5Om0YPMouZzTQpkqEGxqIP
	 QYmLbrQ5jXRnwIYrfwOm/EMYS+GNNN9UAgzpDr6W63CZJKje6aSMWg7vWPVPdOr93vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAeNovCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D9606A327
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAeNovCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE77D1F00A05;
	Thu, 12 Nov 2026 04:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457005;
	bh=NPinxNrgqhhOwTcTygVDbonKQ//XTcODyloMqhzSlqY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EAeNovCpA7fvzqGNLZPH7WSMsTS3f27Zo8DzA0/Ewp+8gw55z1/CiF7ldCq4hEm0j
	 gWzAtpDRMRaq9x8dqxSqxz7uDN8rMnrM9ZI5QGypJZ+PA6EOffT50PcSfQ/nXz6RCW
	 llzQyyYbPl0qiNoYfIMfaRvbxkCojiL/hdQSFGbW8jI4rvVTYVSzzVo42LYZUWJtfR
	 mVE/joAVeiyQ7hCB7jAeSB0990E3jrcxRmH4FOd+hk+u9SUNKFKnZAI+IrNi8Ek2hZ
	 XOEKJm/SjLQuTSDOLAeVPFUlz7T8MIp6m9H8Nn17E7QfWnn8zF6YNPnO5GFAE41OvK
	 oJqZN2Nf2QqaQ==
Message-ID: <sashiko-outbox-210317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/27] ext4: zero s_fc_replay_state in
 ext4_fc_replay_cleanup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-9-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-9-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:16:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] ext4: missing s_ea_inode_work flush before
  ext4_fc_replay_cleanup() [1]
--

commit a4ccfbc7c2db4e8403230f07464457a51d148eaa
Author: Theodore Ts'o <tytso@mit.edu>

ext4: zero s_fc_replay_state in ext4_fc_replay_cleanup()

This commit zeroes sbi->s_fc_replay_state in ext4_fc_replay_cleanup()
after freeing fc_regions and fc_modified_inodes so that repeated calls to
ext4_fc_replay_cleanup() are idempotent.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..15bd040c2329b 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2398,6 +2398,7 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
>  	sbi->s_mount_state &=3D ~EXT4_FC_REPLAY;
>  	kfree(sbi->s_fc_replay_state.fc_regions);
>  	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
> +	memset(&sbi->s_fc_replay_state, 0, sizeof(sbi->s_fc_replay_state));
>  }

[Severity: High]
This problem wasn't introduced by this patch, but can
ext4_fc_replay_cleanup() clear EXT4_FC_REPLAY before sbi->s_ea_inode_work
is flushed [1]?

When fast-commit replay unlinks an inode that owns an extended attribute
inode, ext4_xattr_inode_dec_ref_all() -> ext4_put_ea_inode() queues the EA
inode onto sbi->s_ea_inode_to_free and schedules sbi->s_ea_inode_work.
Unlike the failed_mount3a error path, the normal mount path in
__ext4_fill_super() calls ext4_fc_replay_cleanup() without flushing
sbi->s_ea_inode_work first, clearing EXT4_FC_REPLAY before ext4_mb_init()
initializes sbi->s_group_info:

fs/ext4/super.c:__ext4_fill_super() {
	...
	ext4_fc_replay_cleanup(sb);

	ext4_ext_init(sb);

	/* Register extent status tree shrinker */
	err =3D ext4_es_register_shrinker(sbi);
	if (err)
		goto failed_mount3;

	err =3D ext4_Inode_table_init(sb);
	...
	err =3D ext4_mb_init(sb);
	...
failed_mount3a:
	/* Drain deferred EA inode iputs from journal replay */
	flush_delayed_work(&sbi->s_ea_inode_work);
	ext4_fc_replay_cleanup(sb);
	...
}

If ext4_ea_inode_work() runs before ext4_mb_init() populates
sbi->s_group_info (or when mount failure jumps to failed_mount_wq after
ext4_mb_release()), ext4_evict_inode() -> ext4_free_inode() runs with
EXT4_FC_REPLAY cleared and ext4_get_group_info() returning NULL, which
triggers ext4_std_error(sb, -EFSCORRUPTED).

Should ext4_fc_replay_cleanup() (or __ext4_fill_super() right before it)
call flush_delayed_work(&sbi->s_ea_inode_work) before clearing
EXT4_FC_REPLAY?

[1] https://sashiko.dev/#/bug/linux-f893d2ed-6353-413a-8dd1-c6bc439b880a

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D8
