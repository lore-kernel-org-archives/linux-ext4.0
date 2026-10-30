Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376590;
	b=tiGyRtO3F6DRRkma6PpkTdHeSIR2z92SA2J3kd/fD8h7SB5m154CTTbHz312yp2wl5Ph
	 Dv6tONa5KCN+syupxoIhIkXYbtpRZ7Mk6piTwl2+YA2PiBdj19OeRBbxuhVYfdnp9XbKq
	 i0JguBRDJsVB63QJ1w81GguFRHOScwdXjGks+FUYxwmAk1EFzrrQ+JdLwfwKd6+oL9A7c
	 OWmo1w0gtcuytIOJivctPBemBlVWCIRACPcFeBhDVFhUQP4Czo6NaKtr1g7+FxKp1RESo
	 0I2qcS056yjRe4gK8xENdzzO3iQG8IK2N7PNHet4CMT9oH/REC1vTI6yI0HLW8RNzXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376590;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/Mychch7C97ZshwEL9ueE88CfYbxixMq3ZaDwvqpgks=;
	b=RWQp+HpUpz9lVgIzQGL9+kdxsp15Zt7Z10BzDdqa/B9m3SKzPv/Zikq52IsJdGwPOVwB
	 iO4VGOiW6vkXJO1pBLRhsfOIHKEWXsRSyrSupJj8BZngevH/i5wlRsOJrqSRx2LKkHJu8
	 A0DGa9IT2pZ5Q0MYH9ghUhjzQtFqJKoUzH+waPATk7KQKFoNPjFDXVbJQ7IJO0VS02KjL
	 dMrqC/dGaDo10LUiG+5FvGBYVDamSidNKPQlAuAxE6Nt16zxMjisfz6RmIXybce644Oho
	 09HWjw6doUSwQVq8ZVGu1xRWXTyaelgW8JMx74p5TrP986eCxZXZMk6IKHE3b0B4i1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMKXxT+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5AC606A321;
	Fri, 30 Oct 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMKXxT+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68531F0093A;
	Fri, 30 Oct 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376589;
	bh=/Mychch7C97ZshwEL9ueE88CfYbxixMq3ZaDwvqpgks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RMKXxT+B4dNKzdHHvyHv7QRa6GglJeLRWrTxOikxDwc+SHMb9xEBrc8c1E9TrVOgi
	 mGRCZmfYcTpwdmiI/rDvNEsuRV9zmPLQs9306hQFzPqtnwO1tweYM6fsBJmWTJHCls
	 M60ZKwJvGWH6hZPdqx5fTZg68tpin62dI971F3w0H7Evh06LXtdzT/FuCJKVvucO4h
	 9kTAPmXgB97nIAHmjSnQLmOlFmtmqO4k81UX7OuFWTo/Ti9+6gy8rvCksSOeO5HcOA
	 nP8VIjciRIKaR9iRXnHUu4XmgWL2lJe7XKja19iNq7XFA4nJOjWleVOBosgPGKedBh
	 ZR6+8hCxaOHHQ==
Message-ID: <sashiko-outbox-191221@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:48 +0000
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
- [Medium] ecryptfs: ECRYPTFS_KEY_VALID left set after ecryptfs_initialize_=
file() fails
--

commit f7dbc785a33f0a188b62f1d0ae6c24e5fc32a62c
Author: Christian Brauner <brauner@kernel.org>

ecryptfs: fall back to a read-only lower file

This commit falls back to opening the lower file read-only when opening it
read-write fails with EROFS, and rejects writes to a read-only lower file in
ecryptfs_write_lower() and __ecryptfs_truncate() with EROFS.

> diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> index b3b451c2b9410..b3956ae50ff66 100644
> --- a/fs/ecryptfs/read_write.c
> +++ b/fs/ecryptfs/read_write.c
> @@ -33,6 +33,9 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, =
char *data,
>  	lower_file =3D ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
>  	if (!lower_file)
>  		return -EIO;
> +	/* ecryptfs_open_lower() may have fallen back to a read-only file. */
> +	if (!(lower_file->f_mode & FMODE_WRITE))
> +		return -EROFS;

[Severity: Medium]
When opening an existing 0-byte lower file with O_RDONLY on a read-only low=
er
mount (or a lower filesystem in an error state) with default mount options,
ecryptfs_open() sets ECRYPTFS_POLICY_APPLIED | ECRYPTFS_ENCRYPTED on
crypt_stat->flags and calls read_or_initialize_metadata().

Because the lower file is empty, ecryptfs_read_metadata() fails and
read_or_initialize_metadata() calls ecryptfs_initialize_file():

fs/ecryptfs/inode.c:ecryptfs_initialize_file() {
	rc =3D ecryptfs_new_file_context(ecryptfs_inode);
	if (rc) {
		...
		goto out;
	}
	rc =3D ecryptfs_get_lower_file(ecryptfs_dentry, ecryptfs_inode);
	...
	rc =3D ecryptfs_write_metadata(ecryptfs_dentry, ecryptfs_inode);
	if (rc)
		printk(KERN_ERR "Error writing headers; rc =3D [%d]\n", rc);
	ecryptfs_put_lower_file(ecryptfs_inode);
out:
	return rc;
}

ecryptfs_new_file_context() sets ECRYPTFS_ENCRYPTED | ECRYPTFS_KEY_VALID in
crypt_stat->flags before ecryptfs_write_metadata() calls
ecryptfs_write_lower() and fails with -EROFS. Neither
ecryptfs_initialize_file() nor read_or_initialize_metadata() clears
ECRYPTFS_KEY_VALID (or ECRYPTFS_POLICY_APPLIED) on failure.

On a second open(O_RDONLY) or ecryptfs_setattr() on the same cached inode,
read_or_initialize_metadata() checks the flags at the start of the function:

fs/ecryptfs/file.c:read_or_initialize_metadata() {
	if (crypt_stat->flags & ECRYPTFS_POLICY_APPLIED &&
	    crypt_stat->flags & ECRYPTFS_KEY_VALID) {
		rc =3D 0;
		goto out;
	}
	...
}

Because both flags remain set from the failed initialization, does the seco=
nd
open short-circuit metadata validation and succeed on the uninitialized emp=
ty
file (and if the lower mount is later remounted read-write, allow writes us=
ing
an in-memory key whose header was never written to disk)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D2
