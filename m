Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389729;
	b=d9gBJ9he8QdCAWgmZKyPGlT6bjSnqr4UjzT5QW2MP/zv0MUcvMDvXpQROscDar/49bxs
	 cUu7HktHGOPXbisyoDz/ddNToeAuG+2h0dMoZbix4ftZTXHJ46Y/QtO8w7hTLeRWUwlUr
	 Ugft3ecbRYxlVUTH6K51Lu5MeL2yLn7/YDcY36wIzhMsKKTWc1xDX0xh2/JK2ZWnRoA7t
	 xeDswEQALmQ7XVnIXvTVPopg8z+ratB3qWGH1N+3Pm2Kc/t8Ke7TLnHmmNPpv9hK4VRwZ
	 PFSKYV+y8cQ4/w2TmWw3y/4ChOAQA15x7CA1B6sVFvjoym8ekcIjQCJ4960jCzEtHIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389729;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0wPrDM3ByIgNRkd8um3+s03MrGcxAel/A496/JlTAcw=;
	b=0iikCRmutIW1M0QXESJ6tiHJAeHAEKm/o6aGbzua6cioRGOc50F8K4JEn2HTwnvm8Fra
	 q467wv4Vk89k8cLwXOmX6qh4eSk8Mhy2Uia/xlaQjibm8tERNJk6ZJxn4PK6T45+Dtv2w
	 vwk/LpNtEHUkPB5tJKxEIesq96d9QqonA/CwjqYnV/ltMI5YoUQ/wh8y/C/kWjZTu3LN1
	 2SRwIYsDUP8ZcR2NnJgARnGtiY50oIH+/UC2qseXW7VsM3HpQ4LrwXKxeiF8CSl/cW9kd
	 TA3K6afIdx1Hy9a+fg3okID5N0eQt5/dW0CvTNbRgFNgwqz9Qan+3CF3ArQHmGvq/+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAMQa0RH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF771606A31C;
	Wed, 11 Nov 2026 09:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAMQa0RH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C1C1F00A05;
	Wed, 11 Nov 2026 09:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389729;
	bh=0wPrDM3ByIgNRkd8um3+s03MrGcxAel/A496/JlTAcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAMQa0RHrVEcdCTId5GAxxrGWJDWYg7Xh9YkxitRixioy7tg5wkBQEI9uDd0st8Uh
	 YnLgub2226L347lF9jDxz6rLuPv+BzoRXwpWU0BDi3ju+jCRN2OVUks/c7NHGphhPb
	 yixhl7x1QNHf0c/Lk2q3KpoiDJj3aFjSw/RyQ1fFnXRuUmU7OERWNGYndDndIk28pZ
	 mcUdS46AqNl+Ss3lxn4EkmaINg65asBvoEa4HqvQacm+3kr4vokkQ8k0xi5Y3s3AtZ
	 xSra2BP1eQvakfogTaMApKno9neO8lkjjcSTp8d26FwgVll1KJ2zWA+h/3Hdorto4K
	 Aygw8PaUPL5yQ==
Date: Wed, 11 Nov 2026 10:35:23 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 25/34] gfs2: wait for a pending withdraw before
 remounting read-only
Message-ID: <20261111-dackel-verfechten-eheringe-01ff8d8ee23b@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191244@kernel.org>
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
In-Reply-To: <sashiko-outbox-191244@kernel.org>

On Fri, Oct 30, 2026 at 04:10:09PM +0000, sashiko-bot@kernel.org wrote:
> If the filesystem is subsequently remounted read-only via
> gfs2_reconfigure() -> gfs2_make_fs_ro(), gfs2_log_flush() bails out early on
> the withdrawn filesystem without clearing SDF_JOURNAL_LIVE, leaving
> wait_on_bit() in gfs2_make_fs_ro() sleeping forever while holding
> sb->s_umount.

Pre-existing. The fix is probably to queue the withdraw from
gfs2_reconfigure() and flush it before gfs2_make_fs_ro().
