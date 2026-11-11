Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389630;
	b=ueKVWeW/3/Xj33MCdegLoTwuJYlE3NfQVpRoER+lXSLglUpV2RoSmoSPL8Tuec8xpmwR
	 008Z0ChHUy04YV70SARjWke5pmNR05PjYUAsdSpZMERSR10ZpbDRP63XgODitUmlALN3X
	 98xSk5VyRbBzubKS4W1d+sRCjKOJ45jO5UMf9rTUMCnAiqYE/4d2wHxNYIiVObt2ucyUa
	 Bk27GK8/g1tvoTnxToaY77z5OOqIIHczbcC54CAZUfhWW9loCMx47BGfCI7alK7mWvc4b
	 VXPimIF5T2jidUhScnPkayvO3uVOZu4Apk/UmOV86ysN+iFL+4WJjs4IJIfDa8niPFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389630;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=456qmbozWJFCOonDULqMGwfLm3LOz4ouH9mjjl+y80o=;
	b=sLmNQqKBRjwaHt403N3QxwgHny+cTd7TkHR1he+RK98UHrRd36rYYMhyYmyfj1Plqsii
	 4waQbUJTyqGf4yw760OmlsKQbI2QDu56LIBba5ZRSXoqkYglzhumiU/OlYza3V1HxNYnp
	 INcVxdOAfX2MCHwgqMPzenB12ko/qZTZOPYbQVvsUF9ny16LlqNdFLMaqV0iW86Vib6EV
	 A+JyRbhyUFbvFZFJsczas7re2o0kbLUaCKZIJ8Te1LAjdrK94r/9wiEmTdb+9FwYLGuzd
	 joprExx9z6z66GXYsPFcJpTRdoZLMjUlsppQ/MeSQcYBkjTYzBsUfpqwV3ZINRH0Z+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3Cb6yMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A20606A321;
	Wed, 11 Nov 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3Cb6yMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0931F00A05;
	Wed, 11 Nov 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389630;
	bh=456qmbozWJFCOonDULqMGwfLm3LOz4ouH9mjjl+y80o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n3Cb6yMC6Xx+MhtaqnOrnXGh1yx6okkK2jIpzAW4cu5aUYc8j/y7EU8g3NgNu/QuZ
	 h6aRu73Riaov4wJiTnTP4KKCxNNwt/WLi4lQRVlUpwcuYix3GWpv5VbatMMyd2c2ka
	 bsAKOxkUbXnwPs9gnHyNBgbqw2VZSeX+TvxOlIZowTeU16S9ZvRFLN2y2DgCcctYkQ
	 uKpzfty4H61QbRrp+wcGz2FRiFuijKiwVF5IpDCY/ybtNToPzQn0DiqL5TuyPiT2ba
	 ETQN7xaKj7gXRMaAdX02fBSo5rp8cdjm+07TNPZUCfj2UcYTANvSDnd0dwsYA2Fr6z
	 h9XcZ9pa3YQpQ==
Date: Wed, 11 Nov 2026 10:33:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Viacheslav Dubeyko <slava@dubeyko.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 11/34] hfs: don't set SB_RDONLY after MDB write errors
Message-ID: <20261111-albern-windhund-lockmittel-21301b1f1729@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191230@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191230@kernel.org>

On Fri, Oct 30, 2026 at 04:09:57PM +0000, sashiko-bot@kernel.org wrote:
> Returning early at the top of hfs_file_truncate() skips the out: label
> adjustments as well, leaving HFS_I(inode)->phys_size,
> HFS_I(inode)->fs_blocks, and the inode byte count inflated past
> inode->i_size.

That's all in-memory state. hfs_write_inode() and hfs_mdb_commit()
refuse after the error. None of it reaches the disk.
