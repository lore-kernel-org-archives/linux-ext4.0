Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883271;
	b=fNpQBoT25BtltAW5BQAe+PR0xjx3HnTh8nbFoUMSNpDtd4udnoXnI3QDck0PxajlIM+r
	 hXqJNC5X8TYW5QE23XbP4PIX0PvAnZJy0MqUlO1WUDdEibkzWQt4Mbl9NeaBzSEihJ8gJ
	 Bj0gOs+S1HuU9YjhBrh/a7kU9bf64w34uLTkLaUs8+B7mds1MqIRuHZTD4q9Gty4Cux3X
	 auqoCjo9YkkHhjn01ja6EK+ZGuf77jtqpMhDmUDx1GKsso2obvgHM+q6C5IRFQBKhwzO5
	 pEh8z8G13e1JCINjT/PTyf2KfSw1s649nHHIqiIsUO29gvvK4CXrltdVlcnCcXHZngg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883271;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KIPNoy9prRgIk0QqbRjSFgpNvpxOskQxzNhxtUrTvJY=;
	b=4tAx8bzX1zPs/bkeMzariARWBL2gn9RRXk93rZEBpWRufUF9Igbd00O+655cakbTDvfN
	 WWMwhI65qKD9RANvco0EAQcGBjaTydS/jrNrJeIFYIqutyw/Zfs8iiYMH45G988YMOxhi
	 UlirSv5CHEhPWQMcJZvCiRFYO+y4m6G1IMJuYBr088Xam2HpK68YxvtCpZ4SSDTmx0/IR
	 a/x1DFA3Zn1+z+X9ld9ueTLM5MqyfO/0CWgM7PVsx1MyYUq/bB7fL6eh36UB4Rsl3rkP8
	 6omRGSASkTy0WcNvNPpNXRYSM0G+qQw4dle+J6SKBskhfNZfVFPn57RcsrChvFA+ivQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTEoahuZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07761606A326
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTEoahuZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDFF1F000C1;
	Thu,  5 Nov 2026 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883270;
	bh=KIPNoy9prRgIk0QqbRjSFgpNvpxOskQxzNhxtUrTvJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iTEoahuZU9KNXhois+Uh4hr6ORUlnwxgpDpc32b+wsO5T92nomjno9ALkf0NW/lfV
	 9Q9O3Y1tdkqR119VfqrvB3XQ9EMhroKxM1nb3fywZJQTW2I0XTh1x5+CsTkiv0zfRw
	 9vhPG5gB8A0n1nC6AF1zaDgtXgBRs/ySuVWOHN4GN6QUg/gnkTjj5GvCjqLe7HvjoP
	 lLqfh6AkoMF3SZgER2OkzepguXKMeGPhTbOaGdGuIDUMxlR7mvsDJu/IkOei3j6A+3
	 EcKMYJVMIkddeyQBB4GdnjNhB8MOU7vwcYo+a2jN8+8zcffDzZ62/1j21Q/lVbLy1w
	 YAGL0a36GbhiQ==
Message-ID: <sashiko-outbox-199077@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 06/13] ext4: sync inode metadata in
 ext4_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-6-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-6-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:54:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Without a journal ext4_mark_iloc_dirty() copies the inode into the inode
> table block, marks the block dirty and sets I_METADATA_WRITEBACK so that
> a later fsync() writes the block out and waits for it. But the bit goes
> away with the inode. If the inode is evicted and read back in, fsync()
> finds a clean inode and returns while the block might still be dirty or
> under writeback.
>=20
> Right now that can't happen because inode_lru_isolate() never lets go
> of an inode with I_METADATA_WRITEBACK set. That is about to change.
>=20
> So call ext4_sync_inode_metadata() from ext4_evict_inode() for a linked
> inode that still has the bit set. It syncs the metadata buffers as well
> so it replaces the mmb_sync() there, and since the previous patch it
> doesn't read anything from disk. With a journal the bit is never set
> and nothing changes.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D6

