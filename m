Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882778;
	b=JOwnPh9CivI6t7hW67cmyMeAE4p0zd6lcPBFHiz1Drp3dpllvlr5jzwi4EeN4cujNL7h
	 JMBvnIJqEvVweboC9Yyb89MQkmN5ogJnxx4nfgDYPG/bhjj33JydESHyduKszhgRR2IGz
	 kRZ54ZWE7ZLpSTDFKs0DNPnKV0YOXweFyFRV+7589dMJCBU1TJ4p2bgiDv6ZEXDMR5Kkh
	 cpPYVE+sdmc78joT5wKEEXKcqlQE0YO2YGDjSxZsHJFmrMs8dWaBn96ebMw81ue7iWIMD
	 KDz7N0H20i3sooYgXpfrgj4HC7RECRpYKmVqEtiiVcIqEs/wStyIiOIKouLxk+UGgQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rhRg9PZJvjMe/oIdwLJTeofgetbhf2lqaX8uFgvMDPk=;
	b=ue5ZWexJsyMUS07/XCDCvINsVKrePZizY6GwA7V8Q65FWBXQHQsNMt8uoDPQaCvSmo2k
	 ajGY/p2xwJjBZQj6owkX+2jYGIXvbgiDa9PT3wDu78CVS3YLDP7OfWY8A80yw5v07+EoC
	 w6h8T3XyTuYvG4RkYTHUgSkbrRqKKLBNXViLu8iMF3re/7yCKiGUu1FgFbWk1JhMfAskL
	 SOoKygECEae9pqotRtA4o/EbInzIGSgMYxPH7X5AjOTyX7HXKdLxu6CPxLJT8Zq+atn9f
	 UdwNbhD5LlsSPZPl+MNiho9JCSwVB4mdrxbGHlNjIw45W3dqp8K/a6ilF/bIo/G7whg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RX45NQqf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49A6606D807
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RX45NQqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202A81F000C1;
	Thu,  5 Nov 2026 12:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882777;
	bh=rhRg9PZJvjMe/oIdwLJTeofgetbhf2lqaX8uFgvMDPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RX45NQqf5/rR39gfEsL/Td0nWxKhteNtQDoWHR+m04KdGyydpSDdOYxQKOGKI7HVF
	 zxBpHSsmSQrO8P2TZM3pz+0sCldz/lpEL5j27Qy1uVB6J5CGIZhSbN56E88bSsixF1
	 1nDlzJYZL7NADmrVrrwCHgxUZwKdyPHzh5qC9XDLZnIin4Qkycf/0FrCl4PqWTHn4W
	 pRoo8zXa/YstcvHZQ0EYULpI8OLpxBQ2C6gPIWul+Csh213mhol8Z4mbNihpKWTSyX
	 5gqbZg3BIXAKrkQH/aST8ONKTjZUV70gd+rHOaFkVpSwKdX3uD/oCh6l4HCdaJx2ki
	 Dj3bNjbvymG8w==
Message-ID: <sashiko-outbox-199055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 04/13] ext4: use sb_find_get_block_nonatomic() in
 ext4_get_inode_loc_noio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-4-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-4-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:46:16 +0000
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
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D4

