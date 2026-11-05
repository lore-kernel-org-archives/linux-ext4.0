Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882870;
	b=xpaDI1zE/fzsXkx/rSw3BkOa422qHPFUChRWGhbJoSTXBiB9Jp1ky5Eq8iH3Th9sEgil
	 o2ThwfI5TmDx79Odz1vY7K51g0bywfP2SN2m1XKqkbc2vFhthiYrnsjCH3Ltl9pQrQ50Y
	 0PlGx5RTofxSgmW91aq7pY8qvS7A3qRcisD8uKiTaa+DBK9/UQ1OTAIrze8wAq3rl20ie
	 uSvcjzbyw7tnMRWsJ/hDfN4/8d/jUW4/T9NJ/TfmIJ60rQc8No9LOZQyf6LU85jWe8BDW
	 DvgohRQM0oYwgKT+rGRCpak16lWMCBlPCQ/qGMfqgQe5y/xqiVGIO7zCa5/4IgCfRXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882870;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oeNGfzN38Q0FgEvAVxj8M6ggLb54qpLh3nkDG50zOH0=;
	b=wRV6AtlKpfrThkcy9UD32UbUaXU3sEam5Sf3PT+f4D0WQk4+2ny2X79BnsCjMlNdp+r3
	 FDU9leBt/3tP1gzXQ5RzBndefVnC8Yf8oVgGhMGiEiltz5obPdf6T6hx7ETOPXQm6oi7C
	 5Qqp6xZm6kDt1dIhiutOKjKJ26NSfgYJiju1hLTCW9G9xYMA/hZHfIcporaK6ZuMv2Jq/
	 5ZyKFxtv+gRKY9rAiCHiIjtn362FITXoOgp1x/pbed64n4Dv+NNPKxCfK/j7E5wse9ZNA
	 wuZha637090j3oGABS5oatvpZGFh/hX7s5KCsMc77+yGQnWMQlrp2Yu/8zgL5N6JkCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fkU9pY47;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9615C606A326
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fkU9pY47
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E4C1F000C1;
	Thu,  5 Nov 2026 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882870;
	bh=oeNGfzN38Q0FgEvAVxj8M6ggLb54qpLh3nkDG50zOH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fkU9pY47xCmCZ1USdsntKvgyyq1QKgUKmXpgOLQ279k0RAnuzkPogAH/8AjxJp4z3
	 fppUwT71umCtIkA92rpKjgQo9sBzKpYeQ3dp5mUKfOARQ5Fh3vXnver/bdSwjZKrrV
	 0DGj4UdWI8CRQBWM9sPsn/vXrJ/y5/JSY2K8oBVvtrCc2MmXb54hE3z/xe+PiBJ3Z4
	 WWFP2fou2p8F7835EOFERf9TJdM+ghQu1FlXsvcD6QNdpwtSjZxqluEW1IMc/81b+Q
	 UpgDx91WtevYGDm/fTEGzFfwZ9qNBd2iwtWmzOrYPxMN/sPqhwPlE4UuE1jcQ/jCl2
	 Cyh85WZd3joRw==
Message-ID: <sashiko-outbox-199060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 02/13] ext2: don't read the inode block in
 ext2_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-2-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-2-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:47:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_sync_inode_metadata() looks the inode block up with
> ext2_get_inode() which reads it from disk if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for.
>=20
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead, the way fat_sync_inode_metadata()
> already does.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D2

