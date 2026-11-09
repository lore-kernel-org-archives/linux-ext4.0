Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244021;
	b=gKADz8zBQs4uq6jvT4h0qQXBQpEM61agWJ4UapJoONpZjLmKPaWrEixBJQDhcSF4KN+F
	 EI7+ziAOY+nMnG366AEKuJCsqPuNqYVD7WFKevWJmHK1XmNZUDDoWnUT7p264qjGYCe7Z
	 Ta7K8HLjWq3Ba1KdwsY1Dgxi6fgRm4ekRzcxJHJHt3dG37HP4zw7AYx6rLrAl/7t8SjWH
	 jvzTDHABgbnntnmd9hh9QGWrQLmpPN/C2xdus9f6rp/O6TvyL1luZqzc5RMYJLqTNAsfd
	 gUCBklGZPWGf0Aro1C5VkcZ0jnUxg/j1WHX7R9J0ANXrofjGwZ9KDVPdLNSIrBCK54w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o0XLFTdWrN2sO/ZXmho8UhMLZmwb5fSxJsxm1JO1NnQ=;
	b=idSNGAqfOKEXyZv5g7nVfrP/AlVvJjxsPxVyFyvs1pyTZdEGEXef2KI2mHpVB+0TnJe+
	 7c0JLdcXnjNMDk9n4XI3A1tIs9PZbeSLDE6EiTRVV51ccqALxwVX6AThxhkGcnKp+GeFQ
	 vfFfm7CTzbc9t1GnzWz6QE4YbFQ+FZGdp76qpiqKmbBJFQvyDYAUpNo6PeMz+TBMtHvRc
	 7jOjwUsnhEJmvcNZWk4JQzDVJakP/KiohRT3mu9P+wXM6nPPubYg+kkEINL0S7VAxehCy
	 qvjFmp4BeBej+Oib1oIYRjNLI7OPCTuoO7cQh7PqPieV4XrIgHqvB4dlqrFqFhAkPIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1ri6Mw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF41606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1ri6Mw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E33B1F0089F;
	Mon,  9 Nov 2026 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244020;
	bh=o0XLFTdWrN2sO/ZXmho8UhMLZmwb5fSxJsxm1JO1NnQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T1ri6Mw0QFyPJcihXpadaZPdI3lB9pEhPM9bSusA/SsCM6ecCGEWRplMOFgN6Kd3o
	 SiRwCKP/Wd26LmEbLIpQxXIWBjo+a5nBsjkyx0luP5lh4hpd9ZYUCMcuupEQrvg+gQ
	 9Z9BPBUcSuVBCiOQQc8wXtTXLBd5r9HNCHeMYZr5UxSgNnDCiNygvn+sotDYu+HzO/
	 xN5LXMNJHd31mFrrk7TgLnBUf6PlO6i3oGwnUto0gYzK+wnarskRneeaWTFSwOg9XN
	 cBE5j2TqYWJxd0e4OC7KBJoxphJbQCISwpHRxJIz+WrCHdTWl605bqzc8Nf0z3xurD
	 GiJCX5QMIugdw==
Message-ID: <sashiko-outbox-205273@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 03/14] ext4: use sb_find_get_block_nonatomic() in
 ext4_get_inode_loc_noio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-3-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-3-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:06:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_get_inode_loc_noio() looks the inode table block up with
> sb_find_get_block(). That's the atomic lookup. It serializes against
> try_to_free_buffers() with i_private_lock instead of the folio lock and
> gives up if the folio is being migrated. So it can report the block as
> not cached while it is.
>=20
> For ext4_fc_snapshot_inode() that only means falling back to a full
> commit. But ext4_sync_inode_metadata() is going to use
> ext4_get_inode_loc_noio() to find the inode block that fsync() has to
> write out and there a dirty block must not be skipped.
>=20
> ext4_fc_snapshot_inode() is the only caller and it can sleep. It runs
> under jbd2_journal_lock_updates() and allocates the snapshot with
> GFP_NOFS. So use sb_find_get_block_nonatomic() which takes the folio
> lock and waits for the migration instead.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D3

