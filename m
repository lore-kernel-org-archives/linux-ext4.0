Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488580;
	b=PxYJhuZmyBuQpF9paT+I/woaGRUD19B313/Iavpm/KmslYwvmeie8wS3xocTXNy90dxj
	 06xX9xLTNtIn23JFdOj8NDgiitz8xEDqUEGE1ykJ97K7tC2IH9XmjtWqVzBEYoUWphF/D
	 TiRHVIJaZVrMIyfs0lPEUtPhDlK3fjGhrvRR3akLhomYgIRW1TrIVJ5PaKao/ki8ciwO7
	 frtkZl+4O/F7g+mU3KpqJ8UuNo7bljaUZSq4fSAP07El8oamwVDn6dOeMfuhOu4Z1JS1r
	 Omq7vX5/JsqS3CEOpflGObP2c9kxasrnWpJSV5u6nWVaQhl9xPaSH3jNGJmF9t4l6Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488580;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nw+mvrlrOPI3+3A+8ccM3zcb4JjIkLm62XodB8tpOb0=;
	b=x1a4hQiVBZpV7Rz+/BWnadYCrpAvG5vrpNY+Gzh0ZW9UwGwhP+bddWhz6wEkMoIYUpgW
	 xQj8u6Tp1Z+VS10BhAX2aY3AhAHV7ZV7mwEgXnDWgQnQCQnj9ovQ74Y4iPnuY1PfnVWw8
	 5ztuOoTeu7SDLfJQP2NYcC6hbDzdfLojQubpcKWb2etjDZsy0uft/azO8ofwhT7enWl2j
	 mYTwwPUYBRFNHyb8m+HzN5oxWIdq3dmpUx2uQLbLk0+bpV2iPcbdRYc5VUyjQWpf+d9TG
	 8J9ESatBMCiUXzUob6btov/Ohjlg766fBom5if1b5on9TXQOne1r6cUD8X3r+wWb6cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kc/Kjahg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80F606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kc/Kjahg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0D61F00A06;
	Thu, 12 Nov 2026 13:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488579;
	bh=Nw+mvrlrOPI3+3A+8ccM3zcb4JjIkLm62XodB8tpOb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kc/KjahgBnN+IokrkSBcIXB6Zc2sEkKnM1rzxqmyHzcQHeul68ML7AhYi9SBaJVul
	 QsPG8edjRQC0hD0QkSI7c2gK/Q/MI7fQW8v2m1DsdoPjik6bEoranHfIc85By77+0g
	 ZudEOd0ID5NjWbZVf8TxB1cpTVLtTIUoYWhORQlATc4av856Q1nc1IxPGcZnVq/Taw
	 Tb4PH4p0+UwudeajXKOWO2z8j5dHswO0nxgjkbUzfRAuCn6vgqTpAk5rMpZ6PgJStV
	 o07ZD/C6F3npjnVqzwsPjd1Vrg9p7cU2mdsixv122w2IAKfO0UWcquXxesoolsn+N/
	 UN8HU8l4ISGaw==
Message-ID: <sashiko-outbox-211134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: wait for tail page commit in
 ext4_truncate_failed_write()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112124835.114888-1-chandradhar.2003@gmail.com>
References: <20261112124835.114888-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:02:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When a buffered write fails partially (e.g., due to a user page fault)
> on an ext4 filesystem mounted in data=3Djournal mode with blocksize <
> PAGE_SIZE, ext4_journalled_write_end() invokes ext4_truncate_failed_write=
()
> to discard newly allocated blocks beyond inode->i_size.
>=20
> If the updated inode->i_size straddles a folio whose buffers are currently
> being committed to the journal, truncate_inode_pages() attempts to
> partially invalidate that folio via ext4_journalled_invalidate_folio().
> Because JBD2 cannot unmap buffers belonging to a committing transaction
> on a partial folio, journal_unmap_buffer() returns -EBUSY, triggering
> the WARN_ON() in ext4_journalled_invalidate_folio().
>=20
> Unlike the standard truncate path in ext4_truncate_down(),
> ext4_truncate_failed_write() does not wait for the committing
> transaction on the tail page to finish before truncating the page cache.
> Export ext4_wait_for_tail_page_commit() and call it in
> ext4_truncate_failed_write() when data=3Djournal is enabled before
> acquiring filemap_invalidate_lock() and calling truncate_inode_pages().
>=20
> Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
> Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=3Df111db4cb2acd44eb2f4
> Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112124835.1148=
88-1-chandradhar.2003@gmail.com?part=3D1

